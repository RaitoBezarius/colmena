let
  tools = import ./tools.nix { insideVm = true; };

  testPkg = let
    text = builtins.trace "must appear during evaluation" ''
      echo "must appear during build"
      mkdir -p $out
    '';
  in tools.pkgs.runCommand "test-package" {} text;
in {
  registry.liminix =
  let
    eval-config = import "${tools.liminix}/lib/evalModules.nix" {
      nixpkgs = tools.pkgs;
    };
  in
  {
    evalSystem = eval-config;
    # Call switch-to-configuration $goal
    activation.apply = ''
      echo "must appear before activation (custom)"
    '';
  };

  meta = {
    nixpkgs = tools.pkgs;
  };

  defaults = {};

  deployer = tools.getStandaloneConfigFor "deployer";
  alpha = { lib, ... }: {
    imports = [
      (tools.getStandaloneConfigFor "alpha")
    ];

    deployment.systemType = "liminix";
    environment.systemPackages = [ testPkg ];
    documentation.nixos.enable = lib.mkForce true;
    system.activationScripts.colmena-test.text = ''
      echo "must appear during activation (via Nix)"
    '';
  };

}

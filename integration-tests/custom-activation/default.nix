{ pkgs
, evaluator ? "chunked"
}:

let
  tools = pkgs.callPackage ../tools.nix {};
in tools.runTest {
  name = "colmena-apply-custom-activation-${evaluator}";

  colmena.test = {
    bundle = ./.;
    testScript = ''
      colmena = "${tools.colmenaExec}"
      evaluator = "${evaluator}"
    '' + builtins.readFile ./test-script.py;
  };
}

# Custom activation

With custom activation, you can deploy to other system types than NixOS or customize further the ways your NixOS system gets deployed.

```nix
{
   # https://www.liminix.org/
   registry.liminix = {
      evalSystem = colmenaModules: systemModule: {
      };
      supportsBuildOnTarget = false;
      
      activation.apply = ''
      '';
   };
   
   router01 = { pkgs, ... }: {
     # Will be deployed using `registry.liminix` machinery rather
     # than the default `registry.nixos` machinery.
     deployment.systemType = "liminix";
   }
}
```

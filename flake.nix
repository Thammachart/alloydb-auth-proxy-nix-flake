{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      overlays = [
        (final: prev: rec {})
      ];
      supportedSystems = [ "x86_64-linux" ];

      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f rec {
        pkgs = import nixpkgs { inherit overlays system; };

        pulumi-cli = pkgs.callPackage ./package.nix {};
      });
    in
    {
      packages = forEachSupportedSystem ({ pulumi-cli, ... }: {
        default = pulumi-cli;

        pulumi-cli = pulumi-cli;
      });
    };
}

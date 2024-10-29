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

        alloydb = pkgs.callPackage ./package.nix {};
      });
    in
    {
      packages = forEachSupportedSystem ({ alloydb, ... }: {
        default = alloydb;
        alloydb-auth-proxy = alloydb;
      });
    };
}

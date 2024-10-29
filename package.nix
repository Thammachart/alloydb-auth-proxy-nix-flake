{ lib, stdenv, fetchurl, ... }:
let
  metadata = lib.importJSON ./metadata.json;
in
stdenv.mkDerivation {
  pname = "alloydb-auth-proxy";
  inherit (metadata) version;

  src = fetchurl metadata.systems.${stdenv.hostPlatform.system};

  phases = [ "installPhase" ];

  installPhase = ''
    install -m755 -D $src $out/bin/alloydb-auth-proxy
  '';

  # nativeBuildInputs = [];
  # buildInputs = [ stdenv.cc.cc.libgcc or null ];

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/alloydb-auth-proxy";
    description = "AlloyDB Auth Proxy Nix Flake";
  };
}

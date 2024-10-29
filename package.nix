{ lib, stdenv, fetchurl, ... }:
let
  metadata = lib.importJSON ./metadata.json;
in
stdenv.mkDerivation {
  pname = "alloydb-auth-proxy";
  inherit (metadata) version;

  src = fetchurl metadata.systems.${stdenv.hostPlatform.system};

  installPhase = ''
    install -D -t $out/bin/ *
  '';

  # nativeBuildInputs = [];
  # buildInputs = [ stdenv.cc.cc.libgcc or null ];

  meta = with lib; {
    homepage = "https://pulumi.io/";
    description = "Pulumi CLI (unwrapped)";
  };
}

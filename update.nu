let systems = [
  { os: "linux", arch: "amd64", archNix: "x86_64" }
];

def createUrl [version: string, os: string, arch: string] {
  $"https://storage.googleapis.com/alloydb-auth-proxy/v($version)/alloydb-auth-proxy.($os).($arch)"
}

def sha256sum [url: string] {
  http get $url | hash sha256
}

# Be careful of GitHub Rate Limiting
def findLatestVersion [] {
  http get "https://api.github.com/repos/GoogleCloudPlatform/alloydb-auth-proxy/releases/latest" | get tag_name | str trim --char 'v'
}

def generateMetadata [rec: record] {
  $rec | to json
}

def main [versionTag: string = "latest"] {
  let version = if $versionTag == "latest" { findLatestVersion } else { $versionTag | str trim --char 'v' };

  mut nixos = {};
  for sys in $systems {
    let url = createUrl $version $sys.os $sys.arch;
    let sha256 = sha256sum $url;
    $nixos = $nixos | insert $"($sys.archNix)-($sys.os)" { url: $url, sha256: $sha256 };
  }
  generateMetadata { version: $version, systems: $nixos } | save --force metadata.json;
  nix flake update;
}

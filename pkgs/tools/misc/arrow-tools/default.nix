{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "arrow-tools";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "domoritz";
    repo = "arrow-tools";
    rev = "v${version}";
    sha256 = "sha256-xKjFI3ZtlpIkH94U90NP/SHJK3RX2y5jNmYDi4BweqE=";
  };

  cargoHash = "sha256-6yjNjBC2w0dx/8QqFvaljQJAP0dWLnNur9023HeZ2e4=";

  meta = with lib; {
    description = "A collection of handy CLI tools to convert CSV and JSON to Apache Arrow and Parquet ";
    homepage = "https://github.com/domoritz/arrow-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ john-shaffer ];
  };
}

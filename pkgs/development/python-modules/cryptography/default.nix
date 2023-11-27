{ lib
, stdenv
, buildPythonPackage
, callPackage
, cargo
, cffi
, fetchPypi
, hypothesis
, iso8601
, isPyPy
, libiconv
, libxcrypt
, openssl
, pkg-config
, pretend
, py
, pytest-subtests
, pytestCheckHook
, pythonOlder
, pytz
, rustc
, rustPlatform
, Security
, setuptoolsRustBuildHook
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "41.0.5"; # Also update the hash in vectors.nix
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OSy4i1lyRxdxcuAtpremPe7/GTf6b+w7v5AuvXXZfsc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-ABCK144//RUJ3AksFHEgqC+kHvoHl1ifpVuqMTkGNH8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptoolsRustBuildHook
    cargo
    rustc
    pkg-config
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    libiconv
  ] ++ lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  propagatedBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    cryptography-vectors
    hypothesis
    iso8601
    pretend
    py
    pytestCheckHook
    pytest-subtests
    pytz
  ];

  pytestFlagsArray = [
    "--disable-pytest-warnings"
  ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # aarch64-darwin forbids W+X memory, but this tests depends on it:
    # * https://cffi.readthedocs.io/en/latest/using.html#callbacks
    "tests/hazmat/backends/test_openssl_memleak.py"
  ];

  meta = with lib; {
    description = "A package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v"
      + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

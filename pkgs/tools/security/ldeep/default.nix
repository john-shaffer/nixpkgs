{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.48";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    rev = "refs/tags/${version}";
    hash = "sha256-E/gqt8+eD/syOHczq9k07YIq39W84vC5VFScMxxj4uI=";
  };

  nativeBuildInputs = with python3.pkgs; [
    cython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    commandparse
    cryptography
    dnspython
    ldap3
    pycryptodomex
    six
    termcolor
    tqdm
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "ldeep"
  ];

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    changelog = "https://github.com/franc-pentest/ldeep/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

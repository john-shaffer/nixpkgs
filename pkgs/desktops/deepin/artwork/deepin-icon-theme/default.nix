{ stdenvNoCC
, lib
, fetchFromGitHub
, gtk3
, xcursorgen
, papirus-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-icon-theme";
  version = "2023.11.28";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-kCWJAmJa0VmhnuegE+acj82Ojl4Z5D8g7/q2PzppJwg=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [
    gtk3
    xcursorgen
  ];

  propagatedBuildInputs = [
    papirus-icon-theme
  ];

  dontDropIconThemeCache = true;

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Provides the base icon themes on deepin";
    homepage = "https://github.com/linuxdeepin/deepin-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

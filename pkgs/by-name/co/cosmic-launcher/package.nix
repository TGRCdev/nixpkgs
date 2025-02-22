{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  makeBinaryWrapper,
  libxkbcommon,
  wayland,
  appstream-glib,
  desktop-file-utils,
  intltool,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-launcher";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-launcher";
    rev = "epoch-${version}";
    hash = "sha256-0htDjdS8431orzNnetK0ubNvjO/5748YYqeESJKTUUs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WW1o9MFxNd41ODS5p4piLQtpy277E5a/oN2yYdJc8y4=";

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    wayland
    appstream-glib
    desktop-file-utils
    intltool
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-launcher"
  ];

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
  '';

  postInstall = ''
    wrapProgram $out/bin/cosmic-launcher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  RUSTFLAGS = "--cfg tokio_unstable";

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-launcher";
    description = "Launcher for the COSMIC Desktop Environment";
    mainProgram = "cosmic-launcher";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}

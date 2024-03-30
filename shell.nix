let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) stdenv fetchFromGitHub;
in stdenv.mkDerivation {
  pname = "glfw";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "glfw";
    rev = "228e582";
    sha256 = "sha256-MaKW8GH5E6N+O1R0uS3CadQRdonMycMw0LqPd8K7HBU=";
  };

  buildInputs = with pkgs; [
    cmake
    gcc pkgsCross.mingwW64.buildPackages.gcc
    pkg-config
    libffi

    libGL

    # Wayland
    wayland
    wayland-protocols
    libxkbcommon

    # X11
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    xorg.libXext
  ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
  cmake -S $src -B linux_build -D BUILD_SHARED_LIBS=ON
  cmake --build linux_build

  cmake -S $src -B windows_build -D BUILD_SHARED_LIBS=ON -D CMAKE_TOOLCHAIN_FILE=CMake/x86_64-w64-mingw32.cmake
  cmake --build windows_build
  '';

  installPhase = ''
  mkdir -p $out

  cp $(readlink -f linux_build/src/libglfw.so) $out/libglfw.so
  cp windows_build/src/glfw3.dll $out/glfw3.dll
  '';
}
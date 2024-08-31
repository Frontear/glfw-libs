{
  src,

  runCommandLocal,

  glfw,
  pkgsCross,
}:
let
  glfwAttrs = {
    version = "3.5";

    inherit src;

    # Remove all NixOS specific fixes
    patches = null;
    cmakeFlags = [ "-D BUILD_SHARED_LIBS=ON" ];
    postPatch = "";
    postFixup = "";
  };

  x86_64-linux.glfw = glfw.overrideAttrs (glfwAttrs);
  mingwW64.glfw = pkgsCross.mingwW64.glfw.overrideAttrs (glfwAttrs);
in runCommandLocal "glfw-libs" {} ''
  mkdir -p $out

  cp $(readlink -f ${x86_64-linux.glfw}/lib/libglfw.so) $out
  cp ${mingwW64.glfw}/bin/glfw3.dll $out
''
/*
stdenv.mkDerivation {
  name = "glfw-libs";

  src = /var/empty; 

  installPhase = ''
    mkdir -p $out

    cp $(readlink -f ${x86_64-linux.glfw}/lib/libglfw.so) $out
    cp ${mingwW64.glfw}/bin/glfw3.dll $out
  '';
}
*/
/*
stdenv.mkDerivation {
  name = "glfw-libs";

  inherit src;

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [ cmake extra-cmake-modules wayland-scanner ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
  ];

  buildPhase = ''
   cmake -S $src -B linux_build -D BUILD_SHARED_LIBS=ON
   cmake --build linux_build

   #cmake -S $src -B windows_build -D BUILD_SHARED_LIBS=ON -D CMAKE_TOOLCHAIN_FILE=CMake/x86_64-w64-mingw32.cmake
   #cmake --build windows_build
  '';

  installPhase = ''
   mkdir -p $out

   cp $(readlink -f linux_build/src/libglfw.so) $out/libglfw.so
   #cp windows_build/src/glfw3.dll $out/glfw3.dll
  '';
}
*/

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

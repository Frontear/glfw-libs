{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    glfw = {
      url = "github:glfw/glfw";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs:
  let
    # https://ayats.org/blog/no-flake-utils
    eachSystem = function: inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system: function (import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }));
  in {
    packages = eachSystem (pkgs: {
      default = pkgs.callPackage ({ pkgs, stdenv }: stdenv.mkDerivation {
        name = "glfw-libs";

        src = inputs.glfw;

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
      }) {};
    });
  };
}
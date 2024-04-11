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
      default = pkgs.callPackage ./glfw.nix { inherit (inputs) glfw; };
    });
  };
}
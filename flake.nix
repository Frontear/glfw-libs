{
  description = "Simple flake with a package that exposes shared libraries for x86_64-linux and mingwW64 systems.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    glfw.url = "github:glfw/glfw";
    glfw.flake = false;
  };

  outputs = inputs@{ flake-parts, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      ./nix
    ];

    systems = [ "x86_64-linux" ]; # TODO: can x86_64-darwin work?
  };
}

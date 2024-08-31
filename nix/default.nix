{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.default = pkgs.callPackage ./package.nix { src = inputs.glfw; };
  };
}

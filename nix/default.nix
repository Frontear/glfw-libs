{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.default = pkgs.callPackage ./package.nix { inherit (inputs) glfw; };
  };
}

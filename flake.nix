{
  description = "Code release for Conditional Object-Centric Learning from Video";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-22.11";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs: {
    # overlays = {
    #   # Overlay that is exposed for downstream packages to depend on.
    #   dev = nixpkgs.lib.composeManyExtensions [
    #     (final: prev: {
    #       pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    #         (python-final: python-prev: {
    #         })
    #       ];
    #     })
    #   ];
    # };
  } // utils.lib.eachSystem ["x86_64-linux"] (system: let

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };

  in rec {
    devShells = {
      default = pkgs.mkShell rec {
        name = "slot-attention-video";

        packages = let pythonEnv = pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
          jaxlibWithCuda
          absl-py
          numpy
          tensorflowWithoutCuda
          tensorflow-datasets
          flax
          chex
          optax
          # clu
          ml-collections
          # sckit-learn-image
        ]); in [
          pythonEnv
        ];

        shellHook = ''
          export PS1="$(echo -e '\uf3e2') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
          export PYTHONPATH="$(pwd):$PYTHONPATH"
        '';
      };
    };

    packages.default = pkgs.python3Packages.icbt;
    
  });
}

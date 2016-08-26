let
  np = import <nixpkgs> {};
  hp = np.haskellPackages.override {
    overrides = with np.haskell.lib; self: super: {
      cabal-install = dontCheck (self.callPackage ../cabal/cabal-install {});
      fast-init = addBuildDepends (self.callPackage ./fast-init.nix {}) [ super.ghcid ];
    };
  };

in
  hp.fast-init

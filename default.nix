let
  np = import <nixpkgs> {};

  cabal-repo = np.fetchFromGitHub {
    owner = "Profpatsch";
    repo = "cabal";
    rev = "64cfdb573149dabc18f9b851b5fcf0b231e3d6dd";
    sha256 = "0xx9fxd3zc65xwk6dj4fyvpa0qbfkxrx34hlck3sbp8kq3b3gary";
  };

  cabal-src = "${cabal-repo}/cabal-install";

  cabal-nix = np.runCommand "cabal-install.nix" {
    buildInputs = with np; [ haskellPackages.cabal2nix ];
  }  ''
    cd ${cabal-src}
    cabal2nix . > $out
  '';

  hp = np.haskellPackages.override {
    overrides = with np.haskell.lib; self: super: {
      cabal-install = dontCheck (overrideCabal (super.callPackage cabal-nix {})
        (drv: { src = cabal-src; }));
      fast-init = addBuildDepends (self.callPackage ./fast-init.nix {}) [ super.ghcid ];
    };
  };

in
  hp.fast-init

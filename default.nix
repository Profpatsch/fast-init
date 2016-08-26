# let
#   np = import <nixpkgs> {};
#   hp = np.haskellPackages.override {
#     overrides = with np.haskell.lib; self: super: {
#       fast-init = addBuildDepends (hp.callPackage ./fast-init.nix {}) [ super.ghcid ];
#     };
#   };

# in
#   hp.fast-init

with import <nixpkgs> {}; haskellPackages.callPackage ./fast-init.nix {}

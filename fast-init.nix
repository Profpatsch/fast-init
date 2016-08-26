{ mkDerivation, base, Cabal, cabal-install, protolude, stdenv }:
mkDerivation {
  pname = "fast-init";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base Cabal cabal-install protolude ];
  license = stdenv.lib.licenses.gpl3;
}

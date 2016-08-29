{-# LANGUAGE DeriveGeneric, RecordWildCards, TypeOperators, DataKinds, ViewPatterns #-}
module Main where

import Protolude
import Distribution.Client.Init.Types
import Distribution.Simple.Setup (Flag(Flag, NoFlag))
import Distribution.License (License(GPL))
import Distribution.Package (PackageName(PackageName)
                            , Dependency(Dependency))
import Distribution.Version (thisVersion, Version(Version), orLaterVersion, anyVersion)
import Distribution.Verbosity (silent)

import Distribution.Client.Init (initCabalNoHeuristics)
import Language.Haskell.Extension (Language(Haskell2010))

import Options.Generic

type Name = Text
type Package = Text
data Args = Args { name         :: Name <?> "project name"
                 , isExecutable :: Bool <?> "default: library project" }
          deriving (Show, Generic)

instance ParseRecord Args

main :: IO ()
main = getRecord "fast cabal init" >>= init

defaultPackages :: [Package]
defaultPackages = [ "base", "protolude" ]

init :: Args -> IO ()
init Args{ name = Helpful name
         , isExecutable = Helpful (bool Library Executable -> exec) }
  = initCabalNoHeuristics $ flags name exec defaultPackages

flags :: Name -> PackageType -> [Text] -> InitFlags
flags name type_ packages = InitFlags
  { nonInteractive = Flag True
  , quiet          = Flag False
  , packageDir     = NoFlag
  , noComments     = Flag True
  , minimal        = Flag True

  , packageName    = Flag . PackageName $ toS name
  , version        = Flag $ Version [0,0,1,0] []
  , cabalVersion   = Flag . orLaterVersion $ Version [1,10] []
  , license        = Flag $ GPL (Just $ Version [3] [])
  , author         = Flag "Profpatsch"
  , email          = Flag "mail@profpatsch.de"
  , homepage       = Flag $ "github.com/Profpatsch/" <> toS name

  , synopsis       = Flag ""
  , category       = Flag $ Left ""
  , extraSrc       = Nothing

  , packageType    = Flag type_
  , mainIs         = Flag "Main.hs"
  , language       = Flag Haskell2010

  , exposedModules = Nothing
  , otherModules   = Nothing
  , otherExts      = Nothing

  , dependencies   = Just $ fmap (\p -> Dependency (PackageName $ toS p) anyVersion) packages
  , sourceDirs     = Just ["src"]
  , buildTools     = Nothing

  , initVerbosity  = Flag silent
  , overwrite      = Flag False }

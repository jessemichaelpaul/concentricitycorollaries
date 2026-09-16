module Main (main) where

import SemanticHarness
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["policy"] -> putStr (renderPolicy concentricityPolicy)
    ["route", signalText] ->
      either die (putStr . renderRoute . routeSignal) (parseSignal signalText)
    ["lint", manifestPath] -> runManifest manifestPath lintClear
    ["assess", manifestPath] -> runManifest manifestPath promotable
    _ -> die usage

runManifest :: FilePath -> (Assessment -> Bool) -> IO ()
runManifest manifestPath accepted = do
  source <- readFile manifestPath
  case parseCandidate source of
    Left problem -> die problem
    Right candidate -> do
      let assessment = assessCandidate concentricityPolicy candidate
      putStr (renderAssessment assessment)
      if accepted assessment then exitSuccess else exitFailure

promotable :: Assessment -> Bool
promotable assessment =
  assessmentState assessment `elem` [ProductionEligible, ReleaseEligible]

lintClear :: Assessment -> Bool
lintClear assessment =
  notElem (assessmentState assessment) [ScratchOnly, ProductionRejected]

die :: String -> IO a
die message = putStrLn message >> exitFailure

usage :: String
usage =
  unlines
    [ "usage:"
    , "  semantic-harness policy"
    , "  semantic-harness route <signal>"
    , "  semantic-harness lint <candidate.manifest>"
    , "  semantic-harness assess <candidate.manifest>"
    ]

module Main (main) where

import CodexHook (runCodexHook)
import MiniJson (asString, decodeJson, lookupKey)
import System.Directory (doesDirectoryExist, getCurrentDirectory)
import System.Environment (getArgs)
import System.FilePath (takeDirectory, (</>))

main :: IO ()
main = do
  arguments <- getArgs
  raw <- getContents
  current <- getCurrentDirectory
  let eventCwd =
        case decodeJson raw of
          Right event -> maybe current id (lookupKey "cwd" event >>= asString)
          Left _ -> current
      start =
        case arguments of
          [root] -> root
          _ -> eventCwd
  root <- findProjectRoot start
  output <- runCodexHook root raw
  putStrLn output

findProjectRoot :: FilePath -> IO FilePath
findProjectRoot start = do
  present <- doesDirectoryExist (start </> "tools" </> "semantic-harness")
  if present
    then pure start
    else
      let parent = takeDirectory start
       in if parent == start then pure start else findProjectRoot parent

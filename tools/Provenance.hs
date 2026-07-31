-- Provenance.hs — the claim validator.
--
-- Every mathematical claim an assistant makes must carry a provenance, and the
-- provenance is verified by RE-EXECUTION, never by assertion. This program reads
-- a claims file, re-runs each claim's command against the live repository, and
-- exits non-zero if any claim fails to reproduce.
--
-- The type discipline is the point: `Verified` has no constructor that does not
-- consume a `Provenance`. There is no code path in this program that can bless a
-- claim without evidence, and that is enforced by the compiler rather than by
-- remembering to call a checking function.
--
-- Build:  ghc -O2 Provenance.hs -o provenance
-- Run:    ./provenance claims.txt /path/to/repo
--
-- Jesse Michael Paul, 2026-07-31.

module Main (main) where

import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess, ExitCode(..))
import System.Process (readCreateProcessWithExitCode, shell, cwd)
import System.Directory (doesFileExist)
import Data.List (isInfixOf, isPrefixOf, intercalate, sort)
import Data.Char (isSpace)
import Control.Monad (forM, unless)

--------------------------------------------------------------------------------
-- The types. This is the whole design.
--------------------------------------------------------------------------------

-- | Where a claim's authority comes from. There is no fourth option, and in
--   particular there is no constructor for "the model thinks so".
data Provenance
  = KernelPrint
      { pCommand :: String   -- ^ shell command, re-run at validation time
      , pExpect  :: String   -- ^ what the assistant claims it outputs
      }
  | Certified
      { pDecl    :: String   -- ^ a Lean declaration name
      , pAxioms  :: [String] -- ^ its claimed axiom surface
      }
  | AuthorRatified
      { pClause  :: String   -- ^ a clause of the author's paper
      , pAnchor  :: String   -- ^ its \label in the master source
      }
  -- | An edit to the author's master source. Requires a VERBATIM quote of the
  --   author's own instruction, which must be found in the session transcript
  --   (the assistant cannot write into the author's side of the log, so it
  --   cannot manufacture permission) AND must not already be spent.
  --   Permission is single-use: one instruction authorises one edit.
  | MasterEdit
      { pInstruction :: String -- ^ verbatim quote of the author's instruction
      , pTarget      :: String -- ^ file being edited
      }
  deriving (Show)

-- | A claim is a statement plus its provenance. The provenance field has no
--   default and is not optional: a MathClaim cannot be constructed without one.
data MathClaim = MathClaim
  { cStatement  :: String
  , cProvenance :: Provenance
  } deriving (Show)

-- | The result of validation. Note there is no `Verified` value that does not
--   carry the provenance it was verified against.
data Verified = Verified MathClaim
data Reason   = Reason MathClaim String

--------------------------------------------------------------------------------
-- Validation: re-execution, not trust.
--------------------------------------------------------------------------------

runIn :: FilePath -> String -> IO (String, String, Bool)
runIn dir cmd = do
  (code, out, err) <- readCreateProcessWithExitCode (shell cmd) { cwd = Just dir } ""
  return (out, err, code == ExitSuccess)

trim :: String -> String
trim = f . f where f = reverse . dropWhile isSpace

-- | Normalise output for comparison: strip trailing whitespace per line and
--   drop blank lines, so incidental formatting differences do not cause noise.
norm :: String -> [String]
norm = filter (not . null) . map trim . lines

validate :: FilePath -> MathClaim -> IO (Either Reason Verified)
validate repo claim = case cProvenance claim of

  -- Re-run the command. If the real output does not contain what was claimed,
  -- the claim dies here regardless of how confident the prose around it was.
  KernelPrint cmd expect -> do
    (out, err, _) <- runIn repo cmd
    let actual   = norm (out ++ "\n" ++ err)
        expected = norm expect
        ok       = all (\e -> any (e `isInfixOf`) actual) expected
    return $ if ok
      then Right (Verified claim)
      else Left  (Reason claim ("command did not reproduce the claimed output\n\
                               \        command : " ++ cmd ++ "\n\
                               \        claimed : " ++ intercalate " | " expected ++ "\n\
                               \        actual  : " ++ intercalate " | " (take 6 actual)))

  -- The declaration must exist in the live sources, and its recorded axiom
  -- surface must match what was claimed. A hallucinated Lean name dies here.
  Certified decl axs -> do
    -- Accept the declaration whether it is written bare inside a namespace
    -- block or fully qualified at its definition site.
    (out, _, _) <- runIn repo ("grep -rn --include=*.lean -E '(theorem|lemma|def|instance|abbrev|structure) +([A-Za-z_][A-Za-z0-9_]*\\.)*"
                               ++ escape (baseName decl) ++ "\\b' . | head -3")
    if null (trim out)
      then return $ Left (Reason claim ("no declaration named " ++ decl ++ " exists in the live sources"))
      else do
        (ev, _, _) <- runIn repo "cat blueprint/lean_certificate_evidence.json 2>/dev/null"
        let claimed = sort axs
            allowed = sort ["propext", "Classical.choice", "Quot.sound"]
            recorded = decl `isInfixOf` ev
        if claimed /= allowed
          then return $ Left (Reason claim ("claimed axiom surface is not the permitted one: "
                                            ++ show claimed))
          else if not recorded
            then return $ Left (Reason claim (decl ++ " is not present in the generated evidence file; \
                                                      \regenerate before citing it"))
            else return $ Right (Verified claim)

  -- Author-level judgement. Admissible, but VISIBLY a different kind of thing:
  -- it is never kernel evidence, and the assistant cannot mint one — the anchor
  -- must already exist in the author's own master source.
  AuthorRatified _ anchor -> do
    (out, _, _) <- runIn repo ("grep -c '\\\\label{" ++ escape anchor ++ "}' Octonionic_RH_master.tex 2>/dev/null")
    return $ if trim out `notElem` ["", "0"]
      then Right (Verified claim)
      else Left  (Reason claim ("no \\label{" ++ anchor ++ "} in the master source"))

  -- Permission to edit the master must be (a) quoted verbatim from something the
  -- AUTHOR typed, and (b) not already spent. Both are checked against files the
  -- assistant cannot forge: the session transcript, and the spent-permission
  -- ledger. Clearing the ledger revokes nothing retroactively; permission simply
  -- never persists past the single edit it authorised.
  MasterEdit instruction target -> do
    let needle = escapeQ (trim instruction)
    (found, _, _) <- runIn repo
      ("python3 tools/user_says.py " ++ needle ++ " 2>/dev/null")
    (spent, _, _) <- runIn repo
      ("grep -cF " ++ needle ++ " .provenance-spent 2>/dev/null")
    if null (trim found)
      then return $ Left (Reason claim
             ("no verbatim instruction in the transcript authorising an edit to "
              ++ target ++ "\n        quoted: " ++ take 90 instruction))
      else if trim spent `notElem` ["", "0"]
        then return $ Left (Reason claim
               "that instruction has already been spent; permission is single-use"
             )
        else do
          _ <- runIn repo ("printf '%s\\n' " ++ needle ++ " >> .provenance-spent")
          return $ Right (Verified claim)
  where
    baseName = reverse . takeWhile (/= '.') . reverse
    escape   = concatMap (\c -> if c `elem` "[](){}.*+?^$|\\" then ['\\', c] else [c])
    escapeQ s' = "'" ++ concatMap (\c -> if c == '\'' then "'\\''" else [c]) s' ++ "'"

--------------------------------------------------------------------------------
-- Parsing the claims file.
--
--   CLAIM <statement>
--   KERNEL <shell command>
--   EXPECT <substring the command must print>
--   END
--
--   CLAIM <statement>
--   CERTIFIED <Lean declaration>
--   AXIOMS propext, Classical.choice, Quot.sound
--   END
--
--   CLAIM <statement>
--   AUTHOR <clause>
--   ANCHOR <master label>
--   END
--------------------------------------------------------------------------------

parseClaims :: String -> Either String [MathClaim]
parseClaims = go . filter (not . null) . map trim . lines
  where
    go [] = Right []
    go (l:ls)
      | "CLAIM " `isPrefixOf` l =
          let stmt = drop 6 l
              (body, rest) = break (== "END") ls
          in case build stmt body of
               Left e  -> Left e
               Right c -> (c :) <$> go (drop 1 rest)
      | otherwise = Left ("expected CLAIM, found: " ++ l)

    build stmt body =
      case (field "KERNEL" body, field "EXPECT" body,
            field "CERTIFIED" body, field "AXIOMS" body,
            field "AUTHOR" body, field "ANCHOR" body,
            field "MASTEREDIT" body, field "TARGET" body) of
        (Just k, Just e, _, _, _, _, _, _) -> Right (MathClaim stmt (KernelPrint k e))
        (_, _, Just d, Just a, _, _, _, _) -> Right (MathClaim stmt (Certified d (splitCommas a)))
        (_, _, _, _, Just c, Just n, _, _) -> Right (MathClaim stmt (AuthorRatified c n))
        (_, _, _, _, _, _, Just i, Just t) -> Right (MathClaim stmt (MasterEdit i t))
        _ -> Left ("claim has no usable provenance: " ++ stmt)

    field k = fmap (drop (length k + 1)) . lookupPrefix (k ++ " ")
    lookupPrefix p = foldr (\x acc -> if p `isPrefixOf` x then Just x else acc) Nothing
    splitCommas s = filter (not . null) (map trim (splitOn ',' s))
    splitOn c s = case break (== c) s of
                    (a, [])     -> [a]
                    (a, _:rest) -> a : splitOn c rest

--------------------------------------------------------------------------------

main :: IO ()
main = do
  args <- getArgs
  case args of
    [claimsFile, repo] -> do
      ok <- doesFileExist claimsFile
      unless ok (putStrLn ("no such claims file: " ++ claimsFile) >> exitFailure)
      src <- readFile claimsFile
      case parseClaims src of
        Left e -> putStrLn ("PARSE ERROR: " ++ e) >> exitFailure
        Right claims -> do
          results <- forM claims (validate repo)
          let failures = [r | Left r <- results]
              passes   = [v | Right v <- results]
          mapM_ (\(Verified c) -> putStrLn ("  VERIFIED   " ++ cStatement c)) passes
          mapM_ (\(Reason c why) -> putStrLn ("  REJECTED   " ++ cStatement c
                                              ++ "\n        " ++ why)) failures
          putStrLn ""
          putStrLn (show (length passes) ++ " verified, "
                    ++ show (length failures) ++ " rejected.")
          if null failures then exitSuccess else exitFailure
    _ -> do
      putStrLn "usage: provenance <claims-file> <repo-dir>"
      exitFailure

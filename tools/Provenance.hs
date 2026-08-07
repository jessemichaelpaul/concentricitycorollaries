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
  -- | Kernel-checked AND about a NAMED object of the author's. The claimer must
  --   say which object must occur in the declaration's statement; the validator
  --   confirms it does. A theorem whose statement quantifies over an arbitrary
  --   object of the right shape FAILS here, because nothing author-specific was
  --   certified: it is a generic instantiation, i.e. an unresolved binding
  --   wearing a certificate.
  | CertifiedAt
      { pDeclAt :: String   -- ^ the declaration
      , pObject :: String   -- ^ the author's object that MUST occur in its type
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

splitOn' :: Char -> String -> [String]
splitOn' c s = case break (== c) s of
                 (a, [])     -> [a]
                 (a, _:rest) -> a : splitOn' c rest

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
    -- LIVE. Elaborates the declaration now and reads the kernel's own answer.
    -- Reading a stored evidence file would be reading yesterday's answer.
    (out, _, _) <- runIn repo ("python3 tools/axioms_of.py " ++ escapeQ decl ++ " 2>&1")
    -- axioms_of.py prints TWO lines: an `AXIOM_PRINT '<decl>' depends on ...`
    -- echo of the kernel's own words, then the `AXIOMS a, b, c` summary.
    -- Trimming the whole output and prefix-testing it reads the FIRST line,
    -- which starts with AXIOM_PRINT, so every claim died with "no axiom line
    -- produced" -- and the model then reported the author's prober as broken.
    -- It is not. Pick the line that answers the question.
    let ls       = norm out
        pick p   = case [l | l <- ls, p `isPrefixOf` l] of
                     (l:_) -> Just l
                     []    -> Nothing
        line     = case (pick "AXIOMS", pick "UNKNOWN") of
                     (Just l, _)  -> l
                     (_, Just l)  -> l
                     _            -> trim out
        claimed  = sort axs
        allowed  = sort ["propext", "Classical.choice", "Quot.sound"]
    let live = sort [trim a | a <- splitOn' ',' (drop 7 line), not (null (trim a))]
        axiomVerdict
          | "UNKNOWN" `isPrefixOf` line =
              Left ("axiom surface COULD NOT BE DETERMINED -- this is not \
                    \clean, it is unknown.\n        " ++ drop 8 line)
          | not ("AXIOMS" `isPrefixOf` line) =
              Left ("no axiom line produced for " ++ decl)
          | "sorryAx" `isInfixOf` line =
              Left ("carries sorryAx: " ++ drop 7 line)
          | live /= allowed =
              Left ("live axiom surface is not the permitted one: " ++ drop 7 line)
          | claimed /= allowed =
              Left ("claimed axiom surface differs from the permitted one: "
                    ++ show claimed)
          | otherwise = Right ()
    return $ case axiomVerdict of
      Left why -> Left (Reason claim why)
      Right () -> Right (Verified claim)

  -- Author-level judgement. Admissible, but VISIBLY a different kind of thing:
  -- it is never kernel evidence, and the assistant cannot mint one — the anchor
  -- must already exist in the author's own master source.
  AuthorRatified _ anchor -> do
    (out, _, _) <- runIn repo ("grep -c '\\\\label{" ++ escape anchor ++ "}' Octonionic_RH_master.tex 2>/dev/null")
    return $ if trim out `notElem` ["", "0"]
      then Right (Verified claim)
      else Left  (Reason claim ("no \\label{" ++ anchor ++ "} in the master source"))

  -- Generic instantiation is detected here, and nowhere else: does the
  -- author's object actually occur in the statement, or does a bound variable
  -- stand in its chair?
  CertifiedAt decl object -> do
    (sig, _, _) <- runIn repo ("python3 tools/decl_sig.py " ++ escapeQ decl ++ " 2>/dev/null")
    let stmt = trim sig
    return $ if null stmt
      then Left (Reason claim ("no declaration named " ++ decl ++ " in the live sources"))
      else if object `isInfixOf` stmt
        then Right (Verified claim)
        else Left (Reason claim ("GENERIC INSTANTIATION: " ++ object ++ " does not occur in the statement of " ++ decl ++ " -- the slot is a bound variable, so nothing author-specific is certified. REMAINING: instantiate it."))

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
            field "MASTEREDIT" body, field "TARGET" body,
            field "CERTIFIEDAT" body, field "OBJECT" body) of
        (Just k, Just e, _, _, _, _, _, _, _, _) -> Right (MathClaim stmt (KernelPrint k e))
        (_, _, Just d, Just a, _, _, _, _, _, _) -> Right (MathClaim stmt (Certified d (splitCommas a)))
        (_, _, _, _, Just c, Just n, _, _, _, _) -> Right (MathClaim stmt (AuthorRatified c n))
        (_, _, _, _, _, _, Just i, Just t, _, _) -> Right (MathClaim stmt (MasterEdit i t))
        (_, _, _, _, _, _, _, _, Just d, Just o) -> Right (MathClaim stmt (CertifiedAt d o))
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
          let rejected = [(c, why) | Left (Reason c why) <- results]
              passes   = [v | Right v <- results]
          mapM_ (\(Verified c) -> putStrLn ("  VERIFIED   " ++ cStatement c)) passes
          mapM_ (\(c, why) -> putStrLn ("  REJECTED   " ++ cStatement c
                                        ++ "\n        " ++ why)) rejected
          putStrLn ""
          putStrLn (show (length passes) ++ " verified, "
                    ++ show (length rejected) ++ " rejected.")
          if null rejected then exitSuccess else exitFailure
    _ -> do
      putStrLn "usage: provenance <claims-file> <repo-dir>"
      exitFailure

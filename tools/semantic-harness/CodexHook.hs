module CodexHook
  ( Decision (..)
  , decidePreTool
  , runCodexHook
  ) where

import Control.Exception (IOException, try)
import Data.Char (isAlphaNum, toLower)
import Data.List (isInfixOf, isPrefixOf, isSuffixOf)
import Data.Maybe (fromMaybe)
import MiniJson
import System.Directory
  ( copyFile
  , createDirectoryIfMissing
  , doesFileExist
  )
import System.FilePath ((</>), takeFileName)

data Decision = Allow | Deny String
  deriving (Eq, Show)

runCodexHook :: FilePath -> String -> IO String
runCodexHook root raw =
  case decodeJson raw of
    Left problem ->
      pure
        ( encodeJson
            ( object
                [ ("continue", JBool False)
                , ("stopReason", JString ("Semantic harness could not parse hook input: " ++ problem))
                ]
            )
        )
    Right event -> encodeJson <$> handleEvent root event

handleEvent :: FilePath -> Json -> IO Json
handleEvent root event =
  case fieldString "hook_event_name" event of
    "SessionStart" -> sessionContext root "SessionStart"
    "UserPromptSubmit" -> capturePrompt root event
    "PreCompact" -> archiveAndCheck root event
    "SessionEnd" -> archiveTranscript root event >> pure emptyObject
    "PreToolUse" -> preToolUse root event
    _ -> pure emptyObject

sessionContext :: FilePath -> String -> IO Json
sessionContext root eventName = do
  context <- loadContext root
  pure
    ( object
        [ ( "hookSpecificOutput"
          , object
              [ ("hookEventName", JString eventName)
              , ("additionalContext", JString context)
              ]
          )
        ]
    )

capturePrompt :: FilePath -> Json -> IO Json
capturePrompt root event = do
  ensureStateDirectories root
  let prompt = fieldString "prompt" event
      record =
        object
          [ ("kind", JString "user-prompt")
          , ("session_id", JString (fieldString "session_id" event))
          , ("turn_id", JString (fieldString "turn_id" event))
          , ("prompt", JString prompt)
          ]
  appendFile (historyPath root) (encodeJson record ++ "\n")
  writeFile (lastPromptPath root) prompt
  sessionContext root "UserPromptSubmit"

archiveAndCheck :: FilePath -> Json -> IO Json
archiveAndCheck root event = do
  archiveTranscript root event
  context <- readIfPresent (contextPath root)
  contract <- readIfPresent (contractPath root)
  let contextCurrent =
        isInfixOf "A-2026-09-14-043" context
          && isInfixOf "GPV uniqueness" context
          && isInfixOf "Orbit-stabilizer remains" context
      contractCurrent =
        isInfixOf "contract-revision=A-2026-09-16/ratified-authored-route-v2" contract
          && isInfixOf "required=gpv-uniqueness" contract
          && isInfixOf "required=orbit-stabilizer" contract
  if contextCurrent && contractCurrent
    then pure emptyObject
    else
      pure
        ( object
            [ ("continue", JBool False)
            , ( "stopReason"
              , JString
                  "Compaction paused because the Concentricity author contract or task contract is missing. Restore those files before compacting."
              )
            ]
        )

preToolUse :: FilePath -> Json -> IO Json
preToolUse root event = do
  let toolName = fieldString "tool_name" event
      toolInput = fromMaybe JNull (lookupKey "tool_input" event)
      baseDecision = decidePreTool toolName toolInput
  decision <-
    case baseDecision of
      Deny reason -> pure (Deny reason)
      Allow -> applyStatefulBoundaries root toolName toolInput
  case decision of
    Allow -> pure emptyObject
    Deny reason -> do
      logDenial root event reason
      pure
        ( object
            [ ( "hookSpecificOutput"
              , object
                  [ ("hookEventName", JString "PreToolUse")
                  , ("permissionDecision", JString "deny")
                  , ("permissionDecisionReason", JString reason)
                  ]
              )
            ]
        )

decidePreTool :: String -> Json -> Decision
decidePreTool toolName toolInput
  | isAgentTool normalizedTool =
      Deny
        "This project is in single-collaborator mode. Do not spawn agents or route mathematical judgment to another model."
  | isPatchTool normalizedTool payload = decidePatch payload
  | isShellTool normalizedTool = decideShell payload
  | otherwise = Allow
  where
    normalizedTool = lower toolName
    payload = unlines (stringsDeep toolInput)

decidePatch :: String -> Decision
decidePatch payload
  | not productionPatch = Allow
  | productionPatch && forbiddenProductionPattern addedText =
      Deny
        "This patch reintroduces a quarantined semantic route: an N/frame/coordinate/object-position realization, shared beta or pole comparison, a replacement residue carrier, a pre-collapse read, or an inactive alternative. Stop production editing, explain the exact semantic effect back to Jesse, and ask one concrete question."
  | preservesAuthoredOrbitStabilizerRoute removedLines addedText = Allow
  | any orbitStabilizerLine removedLines =
      Deny
        "Orbit-stabilizer is an authored part of the A-specific route. Do not delete or rewrite it. Preserve the matrix group action and ask Jesse for an explain-back if an interface appears to conflict."
  | otherwise = Allow
  where
    patchLines = lines payload
    addedLines =
      [ drop 1 line
      | line <- patchLines
      , isPrefixOf "+" line
      , not (isPrefixOf "+++" line)
      ]
    removedLines =
      [ drop 1 line
      | line <- patchLines
      , isPrefixOf "-" line
      , not (isPrefixOf "---" line)
      ]
    addedText = lower (unlines addedLines)
    productionPatch = any isProductionPath (touchedPaths patchLines)

decideShell :: String -> Decision
decideShell payload
  | any (\fragment -> isInfixOf fragment normalized) destructiveShellFragments =
      Deny
        "The command is destructive or bypasses reviewable patch editing. Use a read-only check or a visible apply-patch edit within the author-approved scope."
  | otherwise = Allow
  where
    normalized = " " ++ lower payload ++ " "

applyStatefulBoundaries :: FilePath -> String -> Json -> IO Decision
applyStatefulBoundaries root toolName toolInput
  | not (isPatchTool (lower toolName) payload) = pure Allow
  | otherwise = do
      promptResult <- try (readFile (lastPromptPath root)) :: IO (Either IOException String)
      contract <- readIfPresent (contractPath root)
      let prompt = either (const "") id promptResult
          paths = touchedPaths (lines payload)
          protected = filter isProtectedPath paths
          frozen = contractValues "frozen-path" contract
          approvedProtected = contractValues "approved-protected-path" contract
          unapprovedProtected =
            [ path
            | path <- protected
            , path `notElem` approvedProtected
            ]
          frozenTouched = [path | path <- paths, any (pathMatches path) frozen]
          allowedProduction = contractValues "allowed-production-prefix" contract
          productionPaths = filter isProductionPath paths
          outsideStage =
            [ path
            | path <- productionPaths
            , not (any (pathMatches path) allowedProduction)
            ]
      if not (null frozenTouched)
        then
          pure
            ( Deny
                ( "The finalized task contract freezes this path at the active node: "
                    ++ unwords frozenTouched
                    ++ ". Do not work around the freeze; present the required plan transition to Jesse."
                )
            )
        else
          if not (null outsideStage)
            then
              pure
                ( Deny
                    ( "This production edit falls outside the finalized active node: "
                        ++ unwords outsideStage
                        ++ ". Keep implementation work inside the allowed path or ask Jesse to approve a task-contract transition."
                    )
                )
            else
              if null unapprovedProtected || authorizesProtectedEdit prompt unapprovedProtected
                then pure Allow
                else
                  pure
                    ( Deny
                        ( "This edit touches protected author/governance state without a matching explicit request in the current user prompt or an exact persistent task-contract approval: "
                            ++ unwords unapprovedProtected
                            ++ ". Continue read-only work or ask Jesse one concrete authorization question."
                        )
                    )
  where
    payload = unlines (stringsDeep toolInput)

authorizesProtectedEdit :: String -> [FilePath] -> Bool
authorizesProtectedEdit prompt paths = all authorized paths
  where
    normalized = lower prompt
    hasAction = any (\word -> isInfixOf word normalized) actionWords
    mentions wordsForClass = any (\word -> isInfixOf word normalized) wordsForClass
    denied wordsForClass =
      any
        (\prefix -> any (\word -> isInfixOf (prefix ++ " " ++ word) normalized) wordsForClass)
        negativePhrases
    authorized path
      | path == "Octonionic_RH_master.tex" =
          hasAction && mentions ["master"] && not (denied ["master"])
      | isPrefixOf ".local/semantic-interview/" path =
          hasAction
            && mentions ["conversation history", "interview", "semantic record", "saved conversation"]
            && not (denied ["conversation history", "interview", "semantic record"])
      | isPrefixOf ".local/semantic-harness/" path =
          hasAction
            && mentions ["harness", "haskell", "history", "memory", "contract"]
            && not (denied ["harness", "haskell", "history", "memory", "contract"])
      | isPrefixOf "tools/semantic-harness/" path =
          hasAction
            && mentions ["harness", "haskell", "hook"]
            && not (denied ["harness", "haskell", "hook"])
      | isPrefixOf ".codex/" path =
          hasAction && mentions ["codex", "hook", "harness"] && not (denied ["codex", "hook", "harness"])
      | path == "AGENTS.override.md"
          || path == "KernelGroundTruth.md"
          || path == "CONCENTRICITY_EXECUTION_PLAN.md"
          || path == "PROVENANCE.md" =
          hasAction
            && mentions ["governance", "provenance", "instruction", "plan", "memory", "harness"]
            && not (denied ["governance", "provenance", "instruction", "plan", "memory", "harness"])
      | otherwise = False

contractValues :: String -> String -> [String]
contractValues key source =
  [ drop (length marker) line
  | line <- lines source
  , isPrefixOf marker line
  ]
  where
    marker = key ++ "="

pathMatches :: FilePath -> FilePath -> Bool
pathMatches path rule = path == rule || isPrefixOf rule path

isAgentTool :: String -> Bool
isAgentTool toolName =
  toolName == "agent"
    || isInfixOf "spawn_agent" toolName
    || isInfixOf "create_thread" toolName

isPatchTool :: String -> String -> Bool
isPatchTool toolName payload =
  isInfixOf "apply_patch" toolName
    || isInfixOf "apply_patch" (lower payload)

isShellTool :: String -> Bool
isShellTool toolName =
  any (\fragment -> isInfixOf fragment toolName) ["bash", "exec_command", "shell", "functions.exec"]

orbitStabilizerLine :: String -> Bool
orbitStabilizerLine line =
  let normalized = lower line
   in isInfixOf "orbit" normalized && isInfixOf "stabil" normalized

-- A semantic correction may replace a mistaken north-point stabilizer lemma
-- while preserving orbit-stabilizer itself.  The exception is deliberately
-- narrow: the replacement must positively retain the GPV-unique matrix group
-- action on the input's actual sphere.  Known forbidden additions are checked
-- before this predicate, so this cannot excuse a quarantined route.
preservesAuthoredOrbitStabilizerRoute :: [String] -> String -> Bool
preservesAuthoredOrbitStabilizerRoute removedLines addedText =
  any orbitStabilizerLine removedLines
    && orbitStabilizerLine addedText
    && any (`isInfixOf` addedText) ["actual sphere", "actual slice sphere"]
    && isInfixOf "matrix" addedText
    && isInfixOf "gpv" addedText
    && any (`isInfixOf` addedText) ["unique", "uniqueness"]

forbiddenProductionPattern :: String -> Bool
forbiddenProductionPattern text =
  any (\fragment -> isInfixOf fragment text) forbiddenProductionFragments

forbiddenProductionFragments :: [String]
forbiddenProductionFragments =
  [ "projectiveobjectframe"
  , "projectivearrowelement"
  , "north-point frame"
  , "north point frame"
  , "object-position"
  , "object position"
  , "coordinatewise action"
  , "coordinate-wise action"
  , "shared beta"
  , "shared-beta"
  , "pole stabilizer"
  , "pole comparison"
  , "residuecomponentread"
  , "pre-collapse read"
  , "precollapse"
  , "reachabilityresiduetotal"
  , "reachability residue"
  , "centre invariance"
  , "center invariance"
  , "image-span route"
  , "thomason route"
  , "homotopy-colimit route"
  ]

destructiveShellFragments :: [String]
destructiveShellFragments =
  [ " rm "
  , " rm\t"
  , "git reset"
  , "git restore"
  , "git checkout"
  , "git clean"
  , "git commit"
  , "git push"
  , "sed -i"
  , "perl -pi"
  , " tee "
  , " > "
  , " >> "
  ]

touchedPaths :: [String] -> [FilePath]
touchedPaths patchLines =
  [ trimPath (drop (length marker) line)
  | line <- patchLines
  , marker <- ["*** Update File: ", "*** Add File: ", "*** Delete File: "]
  , isPrefixOf marker line
  ]

trimPath :: FilePath -> FilePath
trimPath path =
  case stripWorkspacePrefix path of
    Just relative -> relative
    Nothing -> path

stripWorkspacePrefix :: FilePath -> Maybe FilePath
stripWorkspacePrefix path =
  let marker = "/concentricity/"
   in case breakOn marker path of
        Nothing -> Nothing
        Just (_, suffix) -> Just suffix

breakOn :: String -> String -> Maybe (String, String)
breakOn needle haystack = search "" haystack
  where
    search _ [] = Nothing
    search before rest@(character : remaining)
      | isPrefixOf needle rest = Just (reverse before, drop (length needle) rest)
      | otherwise = search (character : before) remaining

isProductionPath :: FilePath -> Bool
isProductionPath path =
  path == "Octonionic_RH_master.tex"
    || isSuffixOf ".lean" (lower path)

isProtectedPath :: FilePath -> Bool
isProtectedPath path =
  path == "Octonionic_RH_master.tex"
    || path == "AGENTS.override.md"
    || path == "KernelGroundTruth.md"
    || path == "CONCENTRICITY_EXECUTION_PLAN.md"
    || path == "PROVENANCE.md"
    || isPrefixOf ".codex/" path
    || isPrefixOf "tools/semantic-harness/" path
    || isPrefixOf ".local/semantic-interview/" path
    || isPrefixOf ".local/semantic-harness/" path

loadContext :: FilePath -> IO String
loadContext root = do
  context <- readIfPresent (contextPath root)
  contract <- readIfPresent (contractPath root)
  anchors <- readIfPresent (anchorsPath root)
  pure
    ( unlines
        [ "CONCENTRICITY AUTHOR CONTRACT (injected by the project hook)"
        , context
        , contract
        , anchors
        , "A known open sorry or frame dependency is the assigned implementation work, not a qualification of Jesse's argument. At the active node, carry the GPV-derived matrix action into the production diagram. Treat a Lean type mismatch as an exact interface repair; do not repeat the known gap as a stopping reason."
        , "If Lean exposes an interface mismatch, classify it as an implementation issue. Do not redesign Jesse's mathematics. If the sources genuinely conflict, pause production and enter one-question author explain-back."
        ]
    )

readIfPresent :: FilePath -> IO String
readIfPresent path = do
  exists <- doesFileExist path
  if exists then readFile path else pure ("[missing: " ++ path ++ "]")

archiveTranscript :: FilePath -> Json -> IO ()
archiveTranscript root event = do
  ensureStateDirectories root
  let transcript = fieldString "transcript_path" event
      session = safeName (fieldString "session_id" event)
      turn = safeName (fieldString "turn_id" event)
      target = rawTranscriptDirectory root </> session ++ "-" ++ turn ++ "-" ++ takeFileName transcript
  exists <- doesFileExist transcript
  if null transcript || not exists
    then pure ()
    else do
      copied <- try (copyFile transcript target) :: IO (Either IOException ())
      case copied of
        Left _ -> pure ()
        Right _ -> pure ()

logDenial :: FilePath -> Json -> String -> IO ()
logDenial root event reason = do
  ensureStateDirectories root
  let record =
        object
          [ ("kind", JString "pre-tool-denial")
          , ("session_id", JString (fieldString "session_id" event))
          , ("turn_id", JString (fieldString "turn_id" event))
          , ("tool_name", JString (fieldString "tool_name" event))
          , ("reason", JString reason)
          ]
  appendFile (denialsPath root) (encodeJson record ++ "\n")

ensureStateDirectories :: FilePath -> IO ()
ensureStateDirectories root = do
  createDirectoryIfMissing True (stateDirectory root)
  createDirectoryIfMissing True (rawTranscriptDirectory root)

fieldString :: String -> Json -> String
fieldString key value = fromMaybe "" (lookupKey key value >>= asString)

safeName :: String -> String
safeName value =
  let cleaned =
        [ if isAlphaNum character || elem character "-_." then character else '_'
        | character <- value
        ]
   in if null cleaned then "unknown-session" else cleaned

lower :: String -> String
lower = map toLower

emptyObject :: Json
emptyObject = object []

stateDirectory :: FilePath -> FilePath
stateDirectory root = root </> ".local" </> "semantic-harness"

contextPath :: FilePath -> FilePath
contextPath root = stateDirectory root </> "current-context.md"

contractPath :: FilePath -> FilePath
contractPath root = stateDirectory root </> "task-contract.txt"

anchorsPath :: FilePath -> FilePath
anchorsPath root = stateDirectory root </> "conversation-anchors.md"

historyPath :: FilePath -> FilePath
historyPath root = stateDirectory root </> "conversation-history.jsonl"

lastPromptPath :: FilePath -> FilePath
lastPromptPath root = stateDirectory root </> "last-user-prompt.txt"

denialsPath :: FilePath -> FilePath
denialsPath root = stateDirectory root </> "denials.jsonl"

rawTranscriptDirectory :: FilePath -> FilePath
rawTranscriptDirectory root = stateDirectory root </> "raw-transcripts"

actionWords :: [String]
actionWords =
  [ "add"
  , "change"
  , "delete"
  , "edit"
  , "fix"
  , "implement"
  , "integrate"
  , "record"
  , "remove"
  , "restore"
  , "rewrite"
  , "save"
  , "update"
  , "wire"
  ]

negativePhrases :: [String]
negativePhrases =
  [ "do not"
  , "don't"
  , "never"
  , "no delete"
  , "no change"
  , "must not"
  ]

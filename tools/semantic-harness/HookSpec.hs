module Main (main) where

import CodexHook
import Data.List (isInfixOf)
import MiniJson
import System.Directory (createDirectoryIfMissing)
import System.Exit (exitFailure)
import System.FilePath ((</>))
import Data.Time.Clock.POSIX (getPOSIXTime)

main :: IO ()
main = do
  results <- sequence tests
  if and results
    then putStrLn (show (length results) ++ " Codex-hook tests passed")
    else exitFailure

tests :: [IO Bool]
tests =
  [ expect "ordinary matrix action is allowed" Allow (patch "+ exact matrix group action")
  , expect "orbit-stabilizer additions are allowed" Allow (patch "+ orbitStabilizer supplies functoriality")
  , expect
      "north-stabilizer prose can be corrected while preserving the authored route"
      Allow
      ( masterPatch
          [ "-\\begin{lemma}[North stabilizer uniqueness]\\label{lem:orbit-stab}"
          , "+\\begin{lemma}[Orbit--stabilizer on the actual slice sphere]\\label{lem:orbit-stab}"
          , "+GPV uniqueness makes the matrix group action well defined on the actual sphere."
          ]
      )
  , expectDeny "orbit-stabilizer deletion is blocked" (patch "- orbit-stabilizer supplies functoriality")
  , expectDeny
      "a vague orbit-stabilizer rewrite without the GPV action remains blocked"
      ( masterPatch
          [ "-\\begin{lemma}[North stabilizer uniqueness]\\label{lem:orbit-stab}"
          , "+\\begin{lemma}[Orbit--stabilizer]\\label{lem:orbit-stab}"
          ]
      )
  , expectDeny
      "forbidden additions dominate an otherwise valid orbit-stabilizer rewrite"
      ( masterPatch
          [ "-\\begin{lemma}[North stabilizer uniqueness]\\label{lem:orbit-stab}"
          , "+\\begin{lemma}[Orbit--stabilizer on the actual slice sphere]\\label{lem:orbit-stab}"
          , "+GPV uniqueness makes the matrix group action well defined on the actual sphere."
          , "+Route both states through a shared beta."
          ]
      )
  , expectDeny "north frame is blocked" (patch "+ use projectiveObjectFrame at the north point")
  , expectDeny "object position is blocked" (patch "+ define an object-position matrix")
  , expectDeny "shared beta is blocked" (patch "+ route both states through a shared beta")
  , expectDeny "pre-collapse read is blocked" (patch "+ add a pre-collapse read")
  , expect
      "a comment naming the obsolete frame is allowed"
      Allow
      (patch "+ -- projectiveObjectFrame is the obsolete assignment")
  , expectDeny "agent delegation is blocked" (decidePreTool "Agent" (object []))
  , expectDeny
      "destructive shell is blocked"
      (decidePreTool "exec_command" (object [("cmd", JString "git reset --hard")]))
  , expectStateful
      "task-contract approval authorizes a protected multi-step edit"
      "approved"
      False
      [ "allowed-production-prefix=Octonionic_RH_master.tex"
      , "approved-protected-path=Octonionic_RH_master.tex"
      ]
  , expectStateful
      "a protected edit without prompt or contract approval is blocked"
      "unapproved"
      True
      ["allowed-production-prefix=Octonionic_RH_master.tex"]
  , expectStateful
      "a frozen path remains blocked even when listed as approved"
      "frozen"
      True
      [ "allowed-production-prefix=Octonionic_RH_master.tex"
      , "approved-protected-path=Octonionic_RH_master.tex"
      , "frozen-path=Octonionic_RH_master.tex"
      ]
  , expectStatefulPath
      "persistent approvals match an exact protected path, not a prefix"
      "approval-prefix-collision"
      "tools/semantic-harness/CodexHook.hs.backup"
      True
      ["approved-protected-path=tools/semantic-harness/CodexHook.hs"]
  , expectStopWorkflow "formalization without an edit continues once" True False Nothing
  , expectStopWorkflow "the second stop is bounded" False True Nothing
  , expectStopWorkflow "an audit turn can finish" False False (Just "Audit this formalization task and report its status.")
  , expectStopWorkflow "a comment-only edit does not count" True False (Just "-- status note\ndef x := 1\n")
  , expectStopWorkflow "a production Lean code edit counts" False False (Just "def x := 2\n")
  , expectPromptIsolation
  ]

expectPromptIsolation :: IO Bool
expectPromptIsolation = do
  unique <- round . (* 1000000) <$> getPOSIXTime :: IO Integer
  let root = "/private/tmp/concentricity-prompt-isolation-spec-" ++ show unique
      state = root </> ".local" </> "semantic-harness"
      identifiers = [("session_id", JString "authorized-task"), ("turn_id", JString "authorized-turn")]
      promptEvent =
        object
          ( ("hook_event_name", JString "UserPromptSubmit")
              : ("prompt", JString "Please update the Haskell task contract.")
              : identifiers
          )
      patchEvent =
        object
          ( ("hook_event_name", JString "PreToolUse")
              : ("tool_name", JString "apply_patch")
              : ("tool_input", object [("patch", JString (unlines ["*** Begin Patch", "*** Update File: .local/semantic-harness/task-contract.txt", "@@", "+completed-transition=test", "*** End Patch"]))])
              : identifiers
          )
  createDirectoryIfMissing True state
  writeFile (state </> "task-contract.txt") ""
  _ <- runCodexHook root (encodeJson promptEvent)
  writeFile (state </> "last-user-prompt.txt") "Another task asked for an explanation."
  output <- runCodexHook root (encodeJson patchEvent)
  if not (isInfixOf "permissionDecision" output)
    then putStrLn "PASS  protected edits use their own task prompt" >> pure True
    else putStrLn ("FAIL  protected edits use their own task prompt: " ++ output) >> pure False

expectStopWorkflow :: String -> Bool -> Bool -> Maybe String -> IO Bool
expectStopWorkflow label wantBlocked alreadyContinued newSource = do
  unique <- round . (* 1000000) <$> getPOSIXTime :: IO Integer
  let root = "/private/tmp/concentricity-stop-spec-" ++ show unique ++ "-" ++ show (length label)
      state = root </> ".local" </> "semantic-harness"
      leanPath = "Concentricity/ASectionActionDiagram.lean"
      sourcePath = root </> leanPath
      sessionId = "spec-session"
      turnId = "spec-turn"
      common name =
        [ ("hook_event_name", JString name)
        , ("session_id", JString sessionId)
        , ("turn_id", JString turnId)
        ]
      prompt =
        case newSource of
          Just value | isInfixOf "Audit" value -> value
          _ -> "Formalize and close ASection.concentricity by rebuilding the indexed action diagram."
      promptEvent = object (common "UserPromptSubmit" ++ [("prompt", JString prompt)])
      patchEvent name =
        object
          ( common name
              ++ [ ("tool_name", JString "apply_patch")
                 , ("tool_use_id", JString "one-edit")
                 , ( "tool_input"
                   , object
                       [ ( "patch"
                         , JString
                             (unlines ["*** Begin Patch", "*** Update File: " ++ leanPath, "@@", "+def x := 2", "*** End Patch"])
                         )
                       ]
                   )
                 ]
          )
      stopEvent = object (common "Stop" ++ [("stop_hook_active", JBool alreadyContinued)])
  createDirectoryIfMissing True (root </> "Concentricity")
  createDirectoryIfMissing True state
  writeFile sourcePath "def x := 1\n"
  writeFile (state </> "task-contract.txt") "allowed-production-prefix=Concentricity/ASection\n"
  _ <- runCodexHook root (encodeJson promptEvent)
  case newSource of
    Just source | not (isInfixOf "Audit" source) -> do
      _ <- runCodexHook root (encodeJson (patchEvent "PreToolUse"))
      writeFile sourcePath source
      _ <- runCodexHook root (encodeJson (patchEvent "PostToolUse"))
      pure ()
    _ -> pure ()
  output <- runCodexHook root (encodeJson stopEvent)
  let blocked = lookupKey "decision" =<< either (const Nothing) Just (decodeJson output)
  if blocked == (if wantBlocked then Just (JString "block") else Nothing)
    then putStrLn ("PASS  " ++ label) >> pure True
    else putStrLn ("FAIL  " ++ label ++ ": got " ++ output) >> pure False

patch :: String -> Decision
patch body =
  decidePreTool
    "apply_patch"
    ( object
        [ ( "patch"
          , JString
              ( unlines
                  [ "*** Begin Patch"
                  , "*** Update File: Concentricity/ASectionActionDiagram.lean"
                  , "@@"
                  , body
                  , "*** End Patch"
                  ]
              )
          )
        ]
    )

masterPatch :: [String] -> Decision
masterPatch body =
  decidePreTool
    "apply_patch"
    ( object
        [ ( "patch"
          , JString
              ( unlines
                  ( [ "*** Begin Patch"
                    , "*** Update File: Octonionic_RH_master.tex"
                    , "@@"
                    ]
                      ++ body
                      ++ ["*** End Patch"]
                  )
              )
          )
        ]
    )

expect :: String -> Decision -> Decision -> IO Bool
expect label wanted actual
  | wanted == actual = putStrLn ("PASS  " ++ label) >> pure True
  | otherwise = do
      putStrLn ("FAIL  " ++ label ++ ": expected " ++ show wanted ++ ", got " ++ show actual)
      pure False

expectDeny :: String -> Decision -> IO Bool
expectDeny label actual =
  case actual of
    Deny _ -> putStrLn ("PASS  " ++ label) >> pure True
    Allow -> do
      putStrLn ("FAIL  " ++ label ++ ": expected a denial, got Allow")
      pure False

expectStateful :: String -> String -> Bool -> [String] -> IO Bool
expectStateful label fixtureName wantDenied contractLines =
  expectStatefulPath label fixtureName "Octonionic_RH_master.tex" wantDenied contractLines

expectStatefulPath :: String -> String -> FilePath -> Bool -> [String] -> IO Bool
expectStatefulPath label fixtureName patchPath wantDenied contractLines = do
  let root = "/tmp/concentricity-hook-stateful-spec-" ++ fixtureName
      state = root </> ".local" </> "semantic-harness"
      event =
        object
          [ ("hook_event_name", JString "PreToolUse")
          , ("tool_name", JString "apply_patch")
          , ( "tool_input"
            , object
                [ ( "patch"
                  , JString
                      ( unlines
                          [ "*** Begin Patch"
                          , "*** Update File: " ++ patchPath
                          , "@@"
                          , "+Approved prose edit."
                          , "*** End Patch"
                          ]
                      )
                  )
                ]
            )
          ]
  createDirectoryIfMissing True state
  writeFile (state </> "last-user-prompt.txt") "please continue"
  writeFile (state </> "task-contract.txt") (unlines contractLines)
  output <- runCodexHook root (encodeJson event)
  let denied = isInfixOf "permissionDecision" output
  if denied == wantDenied
    then putStrLn ("PASS  " ++ label) >> pure True
    else do
      putStrLn
        ( "FAIL  "
            ++ label
            ++ ": expected denied="
            ++ show wantDenied
            ++ ", got "
            ++ output
        )
      pure False

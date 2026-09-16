module Main (main) where

import CodexHook
import Data.List (isInfixOf)
import MiniJson
import System.Directory (createDirectoryIfMissing)
import System.Exit (exitFailure)
import System.FilePath ((</>))

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
  ]

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

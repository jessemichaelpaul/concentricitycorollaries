module Main (main) where

import Data.List (isInfixOf)
import qualified Data.Set as Set
import SemanticHarness
import System.Exit (exitFailure)

main :: IO ()
main = do
  results <- sequence tests
  if and results
    then putStrLn (show (length results) ++ " semantic-harness tests passed")
    else exitFailure

tests :: [IO Bool]
tests =
  [ expectState "policy-clear manifest still needs verified evidence" EvidenceIncomplete validSlice
  , expectFinding "GPV uniqueness is required for slice-action well-definedness" "missing-authored-technique" missingGpvUniqueness
  , expectState "shared beta is rejected" ProductionRejected sharedBeta
  , expectState "impl prefix cannot hide shared beta" ProductionRejected disguisedSharedBeta
  , expectState "new semantic move is quarantined" ScratchOnly proposedCarrier
  , expectState "readout cannot skip singleton" ProductionRejected skippedReadout
  , expectState "old correction invalidates candidate" ProductionRejected stalePolicy
  , expectState "old plan invalidates candidate" ProductionRejected stalePlan
  , expectFinding "manifest receipts are not trusted" "unverified-receipt" declaredEvidence
  , expectRoute "interface failures stay with proof engineering" LocalProofWorker InterfaceMismatch
  , expectRoute "missing identifiers use retrieval" LibraryRetrievalScout IdentifierMissing
  , expectRoute "kernel green triggers independent review" ReadOnlyFidelityReviewer CandidateKernelGreen
  , expectRoute "blueprints use a source-aware role" SourceAwareBlueprinter BlueprintConstructionNeeded
  , expectWithheld "routing cannot grant promotion" PromoteToProduction IntegrationReady
  , expectWithheld "explain-back cannot grant master edits" WriteMasterDocument ExplainBackAccepted
  , expectWithheld "integration cannot grant delegation" SpawnSubagent IntegrationReady
  , expectRoute "master edits require operational scope review" OperationalScopeReviewer MasterEditProposed
  , expectOnly "stop permits only cancellation" StopAllWork StopRequested
  , expectRoute "plan drift triggers read-only review" ReadOnlyFidelityReviewer PlanDriftDetected
  , expectWithheld "workers cannot rewrite the frozen plan" ChangeFrozenPlan PlanNodeReady
  ]

expectState :: String -> PromotionState -> Candidate -> IO Bool
expectState label expected candidateUnderTest = do
  let actual = assessmentState (assessCandidate concentricityPolicy candidateUnderTest)
  report label expected actual

expectRoute :: String -> Role -> Signal -> IO Bool
expectRoute label expected signal = report label expected (routeRole (routeSignal signal))

expectWithheld :: String -> Capability -> Signal -> IO Bool
expectWithheld label capability signal =
  report label True (capability `Set.member` routeNotGranted (routeSignal signal))

expectOnly :: String -> Capability -> Signal -> IO Bool
expectOnly label capability signal =
  report label (Set.singleton capability) (routeSuggestedCapabilities (routeSignal signal))

expectFinding :: String -> String -> Candidate -> IO Bool
expectFinding label code candidateUnderTest = do
  let present =
        any ((== code) . findingCode)
          (assessmentFindings (assessCandidate concentricityPolicy candidateUnderTest))
  report label True present

report :: (Eq a, Show a) => String -> a -> a -> IO Bool
report label expected actual
  | expected == actual = putStrLn ("PASS  " ++ label) >> pure True
  | otherwise = do
      putStrLn ("FAIL  " ++ label ++ ": expected " ++ show expected ++ ", got " ++ show actual)
      pure False

validSlice :: Candidate
validSlice =
  candidate
    SliceAction
    [C2GlobalPackage, SliceAction]
    [ "full-c2-gpv-package"
    , "actual-sphere-input"
    , "direct-slice-action"
    , "matrix-as-action-data"
    , "orbit-stabilizer-functoriality"
    , "gpv-uniqueness-well-definedness"
    , "impl:local-rewrite"
    ]
    []

sharedBeta :: Candidate
sharedBeta =
  validSlice
    { candidateName = "shared beta recurrence"
    , candidateTechniques = candidateTechniques validSlice ++ [NamedTechnique "shared-beta-waypoint"]
    }

missingGpvUniqueness :: Candidate
missingGpvUniqueness =
  validSlice
    { candidateName = "slice action missing GPV uniqueness"
    , candidateTechniques =
        filter (/= NamedTechnique "gpv-uniqueness-well-definedness") (candidateTechniques validSlice)
    }

disguisedSharedBeta :: Candidate
disguisedSharedBeta =
  validSlice
    { candidateName = "shared beta disguised as implementation"
    , candidateTechniques = candidateTechniques validSlice ++ [ProposedImplementation "shared-beta-waypoint"]
    }

proposedCarrier :: Candidate
proposedCarrier =
  validSlice
    { candidateName = "new semantic carrier"
    , candidateTechniques = candidateTechniques validSlice ++ [ProposedSemanticMove "alternate residue total"]
    }

skippedReadout :: Candidate
skippedReadout =
  validSlice
    { candidateName = "pre-collapse readout"
    , candidateStage = PostCollapseReadout
    , candidatePath = [C2GlobalPackage, SliceAction, PostCollapseReadout]
    , candidateTechniques = candidateTechniques validSlice ++ [NamedTechnique "precollapse-real-read"]
    }

stalePolicy :: Candidate
stalePolicy = validSlice {candidatePolicyRevision = "A-2026-09-12-020"}

stalePlan :: Candidate
stalePlan = validSlice {candidatePlanRevision = "superseded-plan"}

declaredEvidence :: Candidate
declaredEvidence =
  case parseCandidate declaredEvidenceManifest of
    Left problem -> error problem
    Right result -> result

candidate :: Stage -> [Stage] -> [String] -> [Receipt] -> Candidate
candidate stage path techniques receipts =
  Candidate
    { candidateName = "candidate"
    , candidateStage = stage
    , candidatePath = path
    , candidateTechniques = map parseUse techniques
    , candidateSourceFingerprint = sourceFingerprint
    , candidatePolicyRevision = revision
    , candidatePlanRevision = planRevision
    , candidateReceipts = receipts
    }

parseUse :: String -> TechniqueUse
parseUse raw
  | "impl:" `isInfixOf` raw = ProposedImplementation (drop 5 raw)
  | otherwise = NamedTechnique raw

sourceFingerprint :: String
sourceFingerprint = "demo-source-v1"

revision :: String
revision = "A-2026-09-14-043/gpv-orbit-author-route-v1"

planRevision :: String
planRevision = "CONCENTRICITY_EXECUTION_PLAN/checkpoints-1-5/A-2026-09-14-043"

declaredEvidenceManifest :: String
declaredEvidenceManifest =
  unlines
    [ "name=declared evidence"
    , "stage=slice-action"
    , "path=c2-global-package,slice-action"
    , "source-fingerprint=" ++ sourceFingerprint
    , "policy-revision=" ++ revision
    , "plan-revision=" ++ planRevision
    , "technique=full-c2-gpv-package"
    , "technique=actual-sphere-input"
    , "technique=direct-slice-action"
    , "technique=matrix-as-action-data"
    , "technique=orbit-stabilizer-functoriality"
    , "technique=gpv-uniqueness-well-definedness"
    , "receipt=focused-kernel-build|" ++ sourceFingerprint ++ "|" ++ revision ++ "|" ++ planRevision
    , "receipt=semantic-fidelity-review|" ++ sourceFingerprint ++ "|" ++ revision ++ "|" ++ planRevision
    , "receipt=production-reachability-audit|" ++ sourceFingerprint ++ "|" ++ revision ++ "|" ++ planRevision
    ]

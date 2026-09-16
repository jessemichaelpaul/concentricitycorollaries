module SemanticHarness
  ( AuthorityRef (..)
  , Assessment (..)
  , Candidate (..)
  , Capability (..)
  , EvidenceKind (..)
  , Finding (..)
  , FindingLevel (..)
  , Policy
  , PromotionState (..)
  , Receipt
  , Role (..)
  , RouteDecision (..)
  , Signal (..)
  , Stage (..)
  , TechniqueUse (..)
  , assessCandidate
  , concentricityPolicy
  , parseCandidate
  , parseSignal
  , renderAssessment
  , renderPolicy
  , renderRoute
  , routeSignal
  , stageKey
  ) where

import Data.Char (isSpace, toLower)
import Data.List (intercalate, isPrefixOf, nub, sort)
import qualified Data.Map.Strict as Map
import Data.Map.Strict (Map)
import qualified Data.Set as Set
import Data.Set (Set)

-- Semantic authority is intentionally distinct from kernel evidence.  Lean can
-- certify a term at a type; it cannot certify that the type states Jesse's
-- intended mathematics.
data AuthorityRef
  = AuthorCorrection String
  | MasterAnchor String
  | GroundTruthEntry String
  | ExecutionCheckpoint Int
  deriving (Eq, Ord, Show)

data Stage
  = C2GlobalPackage
  | SliceAction
  | IndexedActionDiagram
  | GrothendieckTotal
  | SemanticResidue
  | DirectPolePassage
  | Connectedness
  | Components
  | SingletonComponents
  | PostCollapseReadout
  | RepresentativeEvaluation
  | ConcentricityTheorem
  deriving (Eq, Ord, Enum, Bounded, Show)

data SemanticEffect
  = PreservesMeaning
  | ChangesCarrier
  | ChangesArrow
  | ChangesHypothesis
  | ChangesProofOrder
  | AddsSemanticBridge
  | AddsInvariancePremise
  | ImportsDownstreamBias
  deriving (Eq, Ord, Show)

data TechniqueOrigin
  = Authored AuthorityRef
  | LibraryInfrastructure
  | AgentProposal
  | RetiredArchitecture
  deriving (Eq, Ord, Show)

data TechniqueDisposition
  = RequiredTechnique
  | AllowedTechnique
  | ScratchOnlyTechnique
  | ForbiddenProductionTechnique
  deriving (Eq, Ord, Show)

data TechniqueRule = TechniqueRule
  { ruleName :: String
  , ruleOrigin :: TechniqueOrigin
  , ruleEffect :: SemanticEffect
  , ruleDisposition :: TechniqueDisposition
  , ruleReason :: String
  }
  deriving (Eq, Show)

-- Unknown implementation moves and unknown semantic moves are deliberately
-- different constructors.  The former remain flexible; the latter cannot be
-- promoted merely because an agent found a compiling encoding.
data TechniqueUse
  = NamedTechnique String
  | ProposedImplementation String
  | ProposedSemanticMove String
  deriving (Eq, Ord, Show)

data EvidenceKind
  = FocusedKernelBuild
  | SemanticFidelityReview
  | ProductionReachabilityAudit
  | FullProjectBuild
  | EscapeHatchAudit
  | AxiomSurfaceAudit
  | DependencyPathAudit
  | MasterSourceAudit
  | IndependentKernelReplay
  deriving (Eq, Ord, Enum, Bounded, Show)

-- Receipts are bound to the source, semantic-policy revision, and frozen plan.
-- A source edit, correction, or approved plan amendment automatically makes
-- dependent evidence stale.
data Receipt = Receipt
  { receiptKind :: EvidenceKind
  , receiptSourceFingerprint :: String
  , receiptPolicyRevision :: String
  , receiptPlanRevision :: String
  , receiptTrust :: ReceiptTrust
  }
  deriving (Eq, Ord, Show)

-- The manifest parser can record a claimed receipt, but it cannot mint trusted
-- evidence. AdapterVerified is intentionally not exported and currently has no
-- public constructor; a future fixed-command Lean adapter must live behind this
-- module boundary.
data ReceiptTrust = ManifestDeclared | AdapterVerified
  deriving (Eq, Ord, Show)

data Candidate = Candidate
  { candidateName :: String
  , candidateStage :: Stage
  , candidatePath :: [Stage]
  , candidateTechniques :: [TechniqueUse]
  , candidateSourceFingerprint :: String
  , candidatePolicyRevision :: String
  , candidatePlanRevision :: String
  , candidateReceipts :: [Receipt]
  }
  deriving (Eq, Show)

data FindingLevel = Information | Caution | Quarantine | BlockProduction
  deriving (Eq, Ord, Show)

data Finding = Finding
  { findingLevel :: FindingLevel
  , findingCode :: String
  , findingMessage :: String
  }
  deriving (Eq, Show)

data PromotionState
  = EvidenceIncomplete
  | ScratchOnly
  | ProductionRejected
  | ProductionEligible
  | ReleaseEligible
  deriving (Eq, Ord, Show)

data Assessment = Assessment
  { assessmentCandidate :: Candidate
  , assessmentState :: PromotionState
  , assessmentFindings :: [Finding]
  }
  deriving (Eq, Show)

data Policy = Policy
  { policyName :: String
  , policyRevision :: String
  , policyPlanRevision :: String
  , policyAuthorities :: [AuthorityRef]
  , policyPath :: [Stage]
  , policyTechniqueRules :: Map String TechniqueRule
  , policyRequirements :: Map Stage (Set String)
  , policyProductionEvidence :: Set EvidenceKind
  , policyReleaseEvidence :: Set EvidenceKind
  }
  deriving (Eq, Show)

data Signal
  = BlueprintConstructionNeeded
  | PlanNodeReady
  | PlanDriftDetected
  | PlanAmendmentProposed
  | SourceInterpretationNeeded
  | ExplainBackAccepted
  | AuthorCorrectionArrived
  | MasterConflict
  | DelegationProposed
  | MasterEditProposed
  | GovernanceEditProposed
  | CleanupOrRevertProposed
  | StopRequested
  | KnownOpenGoal
  | IdentifierMissing
  | InterfaceMismatch
  | MissingLeanImplementation
  | ProofSearchStalled
  | CandidateKernelGreen
  | RejectedPatternRepeated
  | DownstreamBiasDetected
  | IntegrationReady
  | ReleaseRequested
  deriving (Eq, Ord, Show)

data Role
  = SourceAwareBlueprinter
  | ReadOnlyFidelityReviewer
  | OperationalScopeReviewer
  | HaltCoordinator
  | LibraryRetrievalScout
  | LocalProofWorker
  | ScratchExplorer
  | SemanticRefiner
  | ProductionIntegrator
  | ReleaseAuditor
  deriving (Eq, Ord, Show)

data Capability
  = ReadCurrentTaskScope
  | ReadFrozenPlan
  | ExecuteAssignedPlanNode
  | ChangeFrozenPlan
  | ReadMaster
  | ReadGroundTruth
  | ReadRelevantAuthorAnswers
  | ReadLeanTarget
  | SearchLeanLibrary
  | RunLean
  | WriteScratch
  | WriteTargetBody
  | WriteLocalHelpers
  | ChangeTargetType
  | ChangeSemanticGraph
  | ReadDownstreamCorollaries
  | PromoteToProduction
  | AskAuthorExplainBack
  | RunReleaseChecks
  | SpawnSubagent
  | WriteMasterDocument
  | WriteGovernanceFiles
  | WriteSemanticRecords
  | DeleteOrRevertFiles
  | StopAllWork
  deriving (Eq, Ord, Enum, Bounded, Show)

data RouteDecision = RouteDecision
  { routeRole :: Role
  , routeSuggestedCapabilities :: Set Capability
  , routeNotGranted :: Set Capability
  , routeReason :: String
  , routeNextArtifact :: String
  }
  deriving (Eq, Show)

concentricityPolicy :: Policy
concentricityPolicy =
  Policy
    { policyName = "Concentricity semantic harness"
    , policyRevision = "A-2026-09-14-043/gpv-orbit-author-route-v1"
    , policyPlanRevision = "CONCENTRICITY_EXECUTION_PLAN/checkpoints-1-5/A-2026-09-14-043"
    , policyAuthorities =
        [ AuthorCorrection "A-2026-09-12-011"
        , AuthorCorrection "A-2026-09-12-022"
        , AuthorCorrection "A-2026-09-12-023"
        , AuthorCorrection "A-2026-09-12-024--027"
        , AuthorCorrection "A-2026-09-13-037"
        , AuthorCorrection "A-2026-09-13-038"
        , AuthorCorrection "A-2026-09-13-039"
        , AuthorCorrection "A-2026-09-14-041"
        , AuthorCorrection "A-2026-09-14-042"
        , AuthorCorrection "A-2026-09-14-043"
        , MasterAnchor "def:residue-subdiagram"
        , MasterAnchor "eq:concentricity-built-chain"
        , MasterAnchor "lem:c-residue-transitive"
        , MasterAnchor "eq:through-pole-base-route"
        , MasterAnchor "eq:through-pole-total-route"
        , ExecutionCheckpoint 4
        ]
    , policyPath = authoredPath
    , policyTechniqueRules = Map.fromList [(ruleName r, r) | r <- techniqueRules]
    , policyRequirements = requirements
    , policyProductionEvidence =
        Set.fromList
          [ FocusedKernelBuild
          , SemanticFidelityReview
          , ProductionReachabilityAudit
          ]
    , policyReleaseEvidence =
        Set.fromList
          [ FocusedKernelBuild
          , SemanticFidelityReview
          , ProductionReachabilityAudit
          , FullProjectBuild
          , EscapeHatchAudit
          , AxiomSurfaceAudit
          , DependencyPathAudit
          , MasterSourceAudit
          ]
    }
  where
    authoredPath =
      [ C2GlobalPackage
      , SliceAction
      , IndexedActionDiagram
      , GrothendieckTotal
      , SemanticResidue
      , DirectPolePassage
      , Connectedness
      , Components
      , SingletonComponents
      , PostCollapseReadout
      , RepresentativeEvaluation
      , ConcentricityTheorem
      ]

    requirements =
      Map.fromList
        [ (C2GlobalPackage, Set.fromList ["full-c2-gpv-package"])
        , ( SliceAction
          , Set.fromList
              [ "actual-sphere-input"
              , "direct-slice-action"
              , "matrix-as-action-data"
              , "orbit-stabilizer-functoriality"
              , "gpv-uniqueness-well-definedness"
              ]
          )
        , (IndexedActionDiagram, Set.fromList ["frame-free-indexed-action", "original-a-o-evaluation"])
        , (GrothendieckTotal, Set.fromList ["a-specific-grothendieck-total"])
        , ( SemanticResidue
          , Set.fromList ["semantic-inverse-image-residue", "inherited-matrix-g2-arrows"]
          )
        , ( DirectPolePassage
          , Set.fromList ["endpoint-gpv-fibres", "direct-pole-continuation"]
          )
        , (Connectedness, Set.fromList ["direct-pole-continuation"])
        , (Components, Set.fromList ["pi0-consumes-morphisms"])
        , (SingletonComponents, Set.fromList ["singleton-components"])
        , (PostCollapseReadout, Set.fromList ["post-collapse-readout"])
        , (RepresentativeEvaluation, Set.fromList ["representative-centre-evaluation"])
        , (ConcentricityTheorem, Set.empty)
        ]

techniqueRules :: [TechniqueRule]
techniqueRules = authored ++ implementation ++ scratch ++ forbidden
  where
    fullPackage = AuthorCorrection "A-2026-09-12-011"
    realAction = AuthorCorrection "A-2026-09-12-022"
    reuseHomomorphism = AuthorCorrection "A-2026-09-12-023"
    gpvWellDefined = AuthorCorrection "A-2026-09-14-043"
    indexedInputOutput = AuthorCorrection "A-2026-09-12-024--027"
    residueSource = MasterAnchor "def:residue-subdiagram"
    polePassage = AuthorCorrection "A-2026-09-13-037"
    componentCollapse = AuthorCorrection "A-2026-09-13-038"
    postCollapse = AuthorCorrection "A-2026-09-13-039"
    authored =
      [ required "full-c2-gpv-package" fullPackage "Use the global package retaining the real preimage, direction, winding, and branch-independent value."
      , required "actual-sphere-input" fullPackage "The normalized input supplies the actual sphere and acted point."
      , required "direct-slice-action" realAction "Specialize the ordinary matrix action directly; do not reconstruct it from a chosen frame."
      , required "matrix-as-action-data" realAction "The GPV matrix is morphism/action data rather than an object or object position."
      , required "orbit-stabilizer-functoriality" reuseHomomorphism "Functoriality comes from the group action and orbit-stabilizer."
      , required "gpv-uniqueness-well-definedness" gpvWellDefined "Well-definedness of the slice-preserving exponential group action consumes the Part 2 GPV lemmas and propositions, especially uniqueness."
      , required "frame-free-indexed-action" indexedInputOutput "Build A_A from the checked action on the actual sphere."
      , required "original-a-o-evaluation" indexedInputOutput "Retain the checked evaluation against the original A_O value."
      , required "a-specific-grothendieck-total" (MasterAnchor "eq:concentricity-built-chain") "T_A is the global A-specific total, not a continuation-only category."
      , required "semantic-inverse-image-residue" residueSource "R_A is the semantic inverse-image full subgroupoid inside T_A."
      , required "inherited-matrix-g2-arrows" residueSource "Residue morphisms are inherited matrix and G2 actions."
      , required "endpoint-gpv-fibres" polePassage "The endpoints a and b are their own unique GPV real fibres."
      , required "direct-pole-continuation" polePassage "Compose the endpoint continuations through p_A with the authored orientation."
      , required "pi0-consumes-morphisms" componentCollapse "Connected components consume the action-groupoid identifications."
      , required "singleton-components" componentCollapse "Prove pi_0(R_A) is the singleton {kappa}."
      , required "post-collapse-readout" postCollapse "Construct Lbar only after singleton connected components."
      , required "representative-centre-evaluation" postCollapse "Evaluate the actual representative against the sphere centre after collapse."
      ]
    implementation =
      [ allowed "mathlib-lemma" LibraryInfrastructure "Library retrieval is implementation-level when it preserves the authored objects and arrows."
      , allowed "local-helper" AgentProposal "Local helper declarations are allowed when they terminate at the assigned production target."
      , allowed "lean-syntax-refactor" AgentProposal "Lean syntax and local refactors remain flexible."
      , allowed "temporary-probe" AgentProposal "Temporary probes are diagnostic evidence, not production progress by themselves."
      ]
    scratch =
      [ scratchOnly "auxiliary-equivalence" AgentProposal AddsSemanticBridge "An unrequested equivalence may be explored but needs authored justification before production use."
      , scratchOnly "candidate-semantic-carrier" AgentProposal ChangesCarrier "A replacement carrier is a semantic proposal, not proof engineering."
      , scratchOnly "unapproved-semantic-bridge" AgentProposal AddsSemanticBridge "A new bridge requires an authored source or explicit author approval."
      , scratchOnly "adversarial-refutation" AgentProposal ChangesHypothesis "A broad refutation campaign is outside ordinary production proof work."
      ]
    forbidden =
      [ forbid "north-point-frame" ChangesCarrier "A^slice is not reconstructed from a north-point frame or chosen transporter."
      , forbid "object-position-matrix" ChangesCarrier "A matrix is action data, not a sphere object or object position."
      , forbid "orbit-representative-construction" ChangesCarrier "The supplied actual sphere must not be replaced by a chosen orbit representative."
      , forbid "shared-beta-waypoint" ChangesArrow "The endpoint fibres a and b must not be replaced by a third shared beta_A."
      , forbid "pole-stabilizer-k" ChangesArrow "The direct continuation has no stabilizer k at the pole."
      , forbid "pole-comparison" AddsSemanticBridge "No comparison morphism is inserted at p_A."
      , forbid "generic-base-closure-substitute" ChangesArrow "Generic closure must not replace the A-specific direct pole passage."
      , forbid "precollapse-real-read" ChangesProofOrder "No real read is available before pi_0 has consumed the residue morphisms."
      , forbid "centre-invariance-premise" AddsInvariancePremise "The common centre is a conclusion, not a pre-collapse invariance premise."
      , forbid "reachability-residue-carrier" ChangesCarrier "R_A is a semantic inverse image, not a reachability-defined replacement carrier."
      , forbid "component-colimit-readout" ChangesProofOrder "The retired component-colimit/pre-collapse route is outside production."
      , forbid "residue-read-naturality" AddsInvariancePremise "The obsolete pre-collapse naturality obligation is not a production dependency."
      , forbid "c2-local-transport-conflation" ChangesCarrier "The global C2 package and local C1/C3 GpvTransport remain distinct data."
      , forbid "continuation-only-total" ChangesCarrier "T_A is global and A-specific; continuation is used locally for transitivity."
      , forbid "downstream-rh-bias" ImportsDownstreamBias "Downstream RH content cannot choose upstream Concentricity definitions or obligations."
      ]

required :: String -> AuthorityRef -> String -> TechniqueRule
required name source reason =
  TechniqueRule name (Authored source) PreservesMeaning RequiredTechnique reason

allowed :: String -> TechniqueOrigin -> String -> TechniqueRule
allowed name origin reason =
  TechniqueRule name origin PreservesMeaning AllowedTechnique reason

scratchOnly :: String -> TechniqueOrigin -> SemanticEffect -> String -> TechniqueRule
scratchOnly name origin effect reason =
  TechniqueRule name origin effect ScratchOnlyTechnique reason

forbid :: String -> SemanticEffect -> String -> TechniqueRule
forbid name effect reason =
  TechniqueRule name RetiredArchitecture effect ForbiddenProductionTechnique reason

assessCandidate :: Policy -> Candidate -> Assessment
assessCandidate policy candidate =
  Assessment candidate promotion findings
  where
    findings =
      concat
        [ policyRevisionFindings policy candidate
        , planRevisionFindings policy candidate
        , pathFindings policy candidate
        , techniqueFindings policy candidate
        , requirementFindings policy candidate
        , receiptFindings policy candidate
        ]
    levels = map findingLevel findings
    has level = level `elem` levels
    releaseComplete =
      policyReleaseEvidence policy `Set.isSubsetOf` freshEvidence candidate
        && candidateStage candidate == ConcentricityTheorem
    productionComplete =
      policyProductionEvidence policy `Set.isSubsetOf` freshEvidence candidate
    promotion
      | has BlockProduction = ProductionRejected
      | has Quarantine = ScratchOnly
      | not productionComplete = EvidenceIncomplete
      | releaseComplete = ReleaseEligible
      | otherwise = ProductionEligible

policyRevisionFindings :: Policy -> Candidate -> [Finding]
policyRevisionFindings policy candidate
  | candidatePolicyRevision candidate == policyRevision policy = []
  | otherwise =
      [ Finding
          BlockProduction
          "stale-policy-revision"
          ( "Candidate uses semantic policy "
              ++ candidatePolicyRevision candidate
              ++ "; current policy is "
              ++ policyRevision policy
              ++ ". Reassess after the correction rather than replaying the old plan."
          )
      ]

planRevisionFindings :: Policy -> Candidate -> [Finding]
planRevisionFindings policy candidate
  | candidatePlanRevision candidate == policyPlanRevision policy = []
  | otherwise =
      [ Finding
          BlockProduction
          "stale-plan-revision"
          ( "Candidate executes plan "
              ++ candidatePlanRevision candidate
              ++ "; frozen plan is "
              ++ policyPlanRevision policy
              ++ ". Quarantine the candidate; only an author-visible plan amendment may change the plan."
          )
      ]

pathFindings :: Policy -> Candidate -> [Finding]
pathFindings policy candidate
  | candidatePath candidate == expected = []
  | otherwise =
      [ Finding
          BlockProduction
          "authored-path-mismatch"
          ( "The declared path does not equal the authored prefix through "
              ++ stageKey (candidateStage candidate)
              ++ ". Expected: "
              ++ intercalate " -> " (map stageKey expected)
          )
      ]
  where
    expected = prefixThrough (candidateStage candidate) (policyPath policy)

techniqueFindings :: Policy -> Candidate -> [Finding]
techniqueFindings policy candidate = concatMap inspect (candidateTechniques candidate)
  where
    inspect use = case use of
      ProposedImplementation name ->
        case Map.lookup name (policyTechniqueRules policy) of
          Just rule
            | ruleDisposition rule == ForbiddenProductionTechnique ->
                [ Finding
                    BlockProduction
                    "forbidden-production-technique"
                    (ruleReason rule ++ " Prefixing it with impl: does not change its semantic effect.")
                ]
          Just rule
            | ruleDisposition rule == ScratchOnlyTechnique ->
                [Finding Quarantine "scratch-only-technique" (ruleReason rule)]
          _ ->
            [ Finding
                Information
                "implementation-flexibility"
                ("Unregistered implementation move remains allowed subject to ordinary review: " ++ name)
            ]
      ProposedSemanticMove name ->
        [ Finding
            Quarantine
            "semantic-review-required"
            ("Unapproved semantic move is scratch-only until anchored or author-confirmed: " ++ name)
        ]
      NamedTechnique name -> case Map.lookup name (policyTechniqueRules policy) of
        Nothing ->
          [ Finding
              Quarantine
              "semantic-review-required"
              ( "Unknown technique '"
                  ++ name
                  ++ "'. Classify it explicitly as impl:<name> or semantic:<name>; do not infer its status from compilation."
              )
          ]
        Just rule -> case ruleDisposition rule of
          RequiredTechnique -> []
          AllowedTechnique -> []
          ScratchOnlyTechnique ->
            [Finding Quarantine "scratch-only-technique" (ruleReason rule)]
          ForbiddenProductionTechnique ->
            [Finding BlockProduction "forbidden-production-technique" (ruleReason rule)]

requirementFindings :: Policy -> Candidate -> [Finding]
requirementFindings policy candidate
  | Set.null missing = []
  | otherwise =
      [ Finding
          BlockProduction
          "missing-authored-technique"
          ("The candidate omits required authored commitments: " ++ commaList (Set.toList missing))
      ]
  where
    stages = prefixThrough (candidateStage candidate) (policyPath policy)
    requiredNames = Set.unions [Map.findWithDefault Set.empty s (policyRequirements policy) | s <- stages]
    presentNames = Set.fromList [name | NamedTechnique name <- candidateTechniques candidate]
    missing = requiredNames `Set.difference` presentNames

receiptFindings :: Policy -> Candidate -> [Finding]
receiptFindings policy candidate = declaredNotes ++ staleNotes ++ missingNote
  where
    declared =
      [ receiptKind r
      | r <- candidateReceipts candidate
      , receiptTrust r == ManifestDeclared
      ]
    declaredNotes
      | null declared = []
      | otherwise =
          [ Finding
              Caution
              "unverified-receipt"
              ( "Manifest-declared receipts are recorded but never trusted for promotion: "
                  ++ commaList (map evidenceKey declared)
              )
          ]
    stale =
      [ receiptKind r
      | r <- candidateReceipts candidate
      , receiptTrust r == AdapterVerified
      , not (receiptIsFresh candidate r)
      ]
    staleNotes
      | null stale = []
      | otherwise =
          [ Finding
              Caution
              "stale-receipt"
              ("Ignoring receipts from another source or semantic revision: " ++ commaList (map evidenceKey stale))
          ]
    requiredEvidence
      | candidateStage candidate == ConcentricityTheorem = policyReleaseEvidence policy
      | otherwise = policyProductionEvidence policy
    missing = requiredEvidence `Set.difference` freshEvidence candidate
    missingNote
      | Set.null missing = []
      | otherwise =
          [ Finding
              Caution
              "evidence-incomplete"
              ( "Not yet promotable at this stage; missing fresh receipts: "
                  ++ commaList (map evidenceKey (Set.toList missing))
              )
          ]

freshEvidence :: Candidate -> Set EvidenceKind
freshEvidence candidate =
  Set.fromList
    [ receiptKind receipt
    | receipt <- candidateReceipts candidate
    , receiptTrust receipt == AdapterVerified
    , receiptIsFresh candidate receipt
    ]

receiptIsFresh :: Candidate -> Receipt -> Bool
receiptIsFresh candidate receipt =
  receiptSourceFingerprint receipt == candidateSourceFingerprint candidate
    && receiptPolicyRevision receipt == candidatePolicyRevision candidate
    && receiptPlanRevision receipt == candidatePlanRevision candidate

prefixThrough :: Eq a => a -> [a] -> [a]
prefixThrough target stages = case break (== target) stages of
  (before, _ : _) -> before ++ [target]
  _ -> []

allCapabilities :: Set Capability
allCapabilities = Set.fromList [minBound .. maxBound]

routeSignal :: Signal -> RouteDecision
routeSignal signal = case signal of
  BlueprintConstructionNeeded ->
    RouteDecision
      SourceAwareBlueprinter
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch]
      )
      "Propose a source-anchored semantic and implementation DAG without proving nodes or changing production."
      "A reviewable blueprint proposal with exact source anchors and declared dependencies"
  PlanNodeReady ->
    proofRoute "Execute exactly the next ready frozen-plan node. The node contract, target, predecessors, file scope, and non-goals remain fixed."
  PlanDriftDetected ->
    readOnlyReview "Quarantine the candidate and compare its actual edits, target type, techniques, and dependencies with the frozen plan. Compilation cannot waive drift."
  PlanAmendmentProposed ->
    RouteDecision
      SourceAwareBlueprinter
      (Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch]
      )
      "A worker cannot rewrite the frozen plan to fit its proof. Prepare a separate source-anchored amendment for author review."
      "A proposed plan diff with affected nodes, invalidated receipts, and no production edit"
  SourceInterpretationNeeded ->
    RouteDecision
      ReadOnlyFidelityReviewer
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, AskAuthorExplainBack])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, AskAuthorExplainBack]
      )
      "Recover the authored meaning first; if the exact sources do not settle it, ask one bounded explain-back question."
      "A source-anchored fidelity finding or one concrete explain-back question"
  ExplainBackAccepted ->
    readOnlyReview "A correct explain-back is semantic evidence only. It does not grant delegation, file mutation, promotion, or repair authority."
  MasterConflict ->
    RouteDecision
      ReadOnlyFidelityReviewer
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, AskAuthorExplainBack])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, AskAuthorExplainBack]
      )
      "The master, current correction, and Lean representation disagree. Ask one concrete explain-back question only after recovering the exact sources."
      "A source-anchored conflict report or confirmed author answer"
  DelegationProposed ->
    scopeReview
      "Creating an agent is a separate operational action. General routing advice cannot enlarge the current user's task scope."
      "An exact current-task delegation grant or a denied proposal; no agent is created by this route"
  MasterEditProposed ->
    scopeReview
      "A master edit requires an exact, current user grant naming that edit. Semantic agreement, project instructions, and recovery intent are not substitutes."
      "A no-op denial, or an exact diff preview and single-use permission request"
  GovernanceEditProposed ->
    scopeReview
      "Governance, provenance, execution-plan, and semantic-record writes require their own current-task scope; Lean formalization authority does not imply them."
      "A no-op denial, or an exact target list and single-use permission request"
  CleanupOrRevertProposed ->
    scopeReview
      "Cleanup, deletion, restoration, and compensating edits are new mutations. A prior mistake does not authorize a broader repair."
      "A read-only recovery plan with exact targets, preserved snapshots, and an explicit permission boundary"
  StopRequested ->
    RouteDecision
      HaltCoordinator
      (Set.singleton StopAllWork)
      (allCapabilities `Set.difference` Set.singleton StopAllWork)
      "Stop is monotone: cancel in-flight agents and processes, then perform no new writes, cleanup, repair, or status mutation."
      "No artifact; only cancellation and a factual read-only audit if the user asks for one"
  KnownOpenGoal ->
    productionRepairRoute
      "The assigned open goal and its known dependency gap are the implementation work. Their continued presence does not qualify the authored argument or reopen its construction. Make the next production edit."
  AuthorCorrectionArrived ->
    RouteDecision
      SemanticRefiner
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget, WriteScratch]
      )
      "Invalidate dependent plans and receipts, identify the affected semantic sub-DAG, and prepare a visible correction before production integration."
      "A supersession set, affected-artifact list, and revised semantic checksum"
  IdentifierMissing ->
    RouteDecision
      LibraryRetrievalScout
      (Set.fromList [ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch]
      )
      "A failed name search is a retrieval problem, not evidence of missing mathematics."
      "Exact accessible declarations, signatures, imports, and a focused probe"
  InterfaceMismatch ->
    productionRepairRoute
      "Keep the authored group actions and repair the exact Lean interface. A type mismatch does not change their mathematical meaning or justify another author question."
  MissingLeanImplementation ->
    productionRepairRoute
      "Implement the recorded mathematical step at the active production node with focused kernel feedback."
  ProofSearchStalled ->
    RouteDecision
      ScratchExplorer
      (Set.fromList [ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch]
      )
      "Explore bounded proof alternatives off the production path; escalation depends on diagnosed evidence, not elapsed effort."
      "A minimized proof-state trace and one classified failure"
  CandidateKernelGreen -> readOnlyReview "Kernel-green is evidence about the term, not yet about source fidelity or production reachability."
  RejectedPatternRepeated ->
    RouteDecision
      ReadOnlyFidelityReviewer
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget]
      )
      "Stop the loop, quarantine the branch, and compare its semantic graph with the current authored route."
      "A structural recurrence report and invalidated candidate list"
  DownstreamBiasDetected ->
    RouteDecision
      ReadOnlyFidelityReviewer
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadLeanTarget])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadLeanTarget]
      )
      "Rebuild the context pack from Concentricity-only sources; downstream claims cannot choose upstream definitions."
      "A sanitized context pack and restored semantic checksum"
  IntegrationReady ->
    RouteDecision
      ProductionIntegrator
      (Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ExecuteAssignedPlanNode, ReadMaster, ReadGroundTruth, ReadLeanTarget, RunLean, WriteTargetBody, WriteLocalHelpers])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ExecuteAssignedPlanNode, ReadMaster, ReadGroundTruth, ReadLeanTarget, RunLean, WriteTargetBody, WriteLocalHelpers]
      )
      "Routing may suggest local integration work; actual write authority comes only from the current work envelope. Routing cannot mint promotion authority."
      "A focused candidate patch to be assessed against fresh fidelity, reachability, and kernel receipts"
  ReleaseRequested ->
    RouteDecision
      ReleaseAuditor
      (Set.fromList [ReadMaster, ReadGroundTruth, ReadLeanTarget, RunLean, RunReleaseChecks])
      ( allCapabilities
          `Set.difference` Set.fromList [ReadMaster, ReadGroundTruth, ReadLeanTarget, RunLean, RunReleaseChecks]
      )
      "Release certification is independent, read-only, transitive, and tied to the exact source, semantic policy, and frozen plan revision."
      "Full-build, escape-hatch, axiom, dependency, and master receipts; optional independent replay hardening"
  where
    scopeReview why artifact =
      RouteDecision
        OperationalScopeReviewer
        (Set.singleton ReadCurrentTaskScope)
        (allCapabilities `Set.difference` Set.singleton ReadCurrentTaskScope)
        why
        artifact
    readOnlyReview why =
      RouteDecision
        ReadOnlyFidelityReviewer
        (Set.fromList [ReadFrozenPlan, ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget])
        ( allCapabilities
            `Set.difference` Set.fromList [ReadFrozenPlan, ReadMaster, ReadGroundTruth, ReadRelevantAuthorAnswers, ReadLeanTarget]
        )
        why
        "A source-anchored fidelity finding; no production edit"
    proofRoute why =
      RouteDecision
        LocalProofWorker
        (Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ExecuteAssignedPlanNode, ReadMaster, ReadGroundTruth, ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch, WriteTargetBody, WriteLocalHelpers])
        ( allCapabilities
            `Set.difference` Set.fromList [ReadCurrentTaskScope, ReadFrozenPlan, ExecuteAssignedPlanNode, ReadMaster, ReadGroundTruth, ReadLeanTarget, SearchLeanLibrary, RunLean, WriteScratch, WriteTargetBody, WriteLocalHelpers]
        )
        why
        "A local proof patch or an exact interface diagnostic"
    productionRepairRoute why =
      (proofRoute why)
        { routeRole = ProductionIntegrator
        , routeNextArtifact =
            "The next edit on the live production dependency path and its focused Lean result; if it fails, the exact expected and actual types and the next repair"
        }

parseCandidate :: String -> Either String Candidate
parseCandidate input = do
  fields <- traverse parseLine meaningful
  rejectUnknownKeys fields
  name <- exactlyOne "name" fields
  stage <- exactlyOne "stage" fields >>= parseStage
  path <- exactlyOne "path" fields >>= traverse parseStage . splitOn ','
  sourceFingerprint <- exactlyOne "source-fingerprint" fields
  revision <- exactlyOne "policy-revision" fields
  planRevision <- exactlyOne "plan-revision" fields
  techniques <- traverse parseTechnique (values "technique" fields)
  receipts <- traverse parseReceipt (values "receipt" fields)
  pure
    Candidate
      { candidateName = name
      , candidateStage = stage
      , candidatePath = path
      , candidateTechniques = techniques
      , candidateSourceFingerprint = sourceFingerprint
      , candidatePolicyRevision = revision
      , candidatePlanRevision = planRevision
      , candidateReceipts = receipts
      }
  where
    meaningful =
      [ trim line
      | line <- lines input
      , let cleaned = trim line
      , not (null cleaned)
      , not ("#" `isPrefixOf` cleaned)
      ]

parseLine :: String -> Either String (String, String)
parseLine line = case break (== '=') line of
  (key, '=' : value)
    | not (null (trim key)) && not (null (trim value)) -> Right (trim key, trim value)
  _ -> Left ("Expected key=value, found: " ++ line)

rejectUnknownKeys :: [(String, String)] -> Either String ()
rejectUnknownKeys fields
  | null unknown = Right ()
  | otherwise = Left ("Unknown manifest keys: " ++ commaList unknown)
  where
    known = Set.fromList ["name", "stage", "path", "technique", "source-fingerprint", "policy-revision", "plan-revision", "receipt"]
    unknown = sort . nub $ [key | (key, _) <- fields, key `Set.notMember` known]

exactlyOne :: String -> [(String, String)] -> Either String String
exactlyOne key fields = case values key fields of
  [value] -> Right value
  [] -> Left ("Missing required field: " ++ key)
  _ -> Left ("Field must occur exactly once: " ++ key)

values :: String -> [(String, String)] -> [String]
values key fields = [value | (key', value) <- fields, key == key']

parseTechnique :: String -> Either String TechniqueUse
parseTechnique raw
  | "impl:" `isPrefixOf` normalized =
      nonEmpty ProposedImplementation (drop (length "impl:") normalized)
  | "semantic:" `isPrefixOf` normalized =
      nonEmpty ProposedSemanticMove (drop (length "semantic:") normalized)
  | otherwise = nonEmpty NamedTechnique normalized
  where
    normalized = normalizeKey raw
    nonEmpty constructor value
      | null value = Left ("Technique name is empty: " ++ raw)
      | otherwise = Right (constructor value)

parseReceipt :: String -> Either String Receipt
parseReceipt raw = case map trim (splitOn '|' raw) of
  [kindText, fingerprint, revision, planRevision]
    | all (not . null) [fingerprint, revision, planRevision] -> do
        kind <- parseEvidence kindText
        Right (Receipt kind fingerprint revision planRevision ManifestDeclared)
  _ -> Left ("Receipt must be kind|source-fingerprint|policy-revision|plan-revision: " ++ raw)

parseStage :: String -> Either String Stage
parseStage raw = lookupKey "stage" raw [(stageKey stage, stage) | stage <- [minBound .. maxBound]]

parseEvidence :: String -> Either String EvidenceKind
parseEvidence raw = lookupKey "evidence kind" raw [(evidenceKey kind, kind) | kind <- [minBound .. maxBound]]

parseSignal :: String -> Either String Signal
parseSignal raw = lookupKey "signal" raw [(signalKey signal, signal) | signal <- signals]
  where
    signals =
      [ BlueprintConstructionNeeded
      , PlanNodeReady
      , PlanDriftDetected
      , PlanAmendmentProposed
      , SourceInterpretationNeeded
      , ExplainBackAccepted
      , AuthorCorrectionArrived
      , MasterConflict
      , DelegationProposed
      , MasterEditProposed
      , GovernanceEditProposed
      , CleanupOrRevertProposed
      , StopRequested
      , KnownOpenGoal
      , IdentifierMissing
      , InterfaceMismatch
      , MissingLeanImplementation
      , ProofSearchStalled
      , CandidateKernelGreen
      , RejectedPatternRepeated
      , DownstreamBiasDetected
      , IntegrationReady
      , ReleaseRequested
      ]

lookupKey :: String -> String -> [(String, a)] -> Either String a
lookupKey kind raw choices = case lookup (normalizeKey raw) choices of
  Just value -> Right value
  Nothing -> Left ("Unknown " ++ kind ++ " '" ++ raw ++ "'. Expected one of: " ++ commaList (map fst choices))

stageKey :: Stage -> String
stageKey stage = case stage of
  C2GlobalPackage -> "c2-global-package"
  SliceAction -> "slice-action"
  IndexedActionDiagram -> "indexed-action-diagram"
  GrothendieckTotal -> "grothendieck-total"
  SemanticResidue -> "semantic-residue"
  DirectPolePassage -> "direct-pole-passage"
  Connectedness -> "connectedness"
  Components -> "components"
  SingletonComponents -> "singleton-components"
  PostCollapseReadout -> "post-collapse-readout"
  RepresentativeEvaluation -> "representative-evaluation"
  ConcentricityTheorem -> "concentricity-theorem"

evidenceKey :: EvidenceKind -> String
evidenceKey kind = case kind of
  FocusedKernelBuild -> "focused-kernel-build"
  SemanticFidelityReview -> "semantic-fidelity-review"
  ProductionReachabilityAudit -> "production-reachability-audit"
  FullProjectBuild -> "full-project-build"
  EscapeHatchAudit -> "escape-hatch-audit"
  AxiomSurfaceAudit -> "axiom-surface-audit"
  DependencyPathAudit -> "dependency-path-audit"
  MasterSourceAudit -> "master-source-audit"
  IndependentKernelReplay -> "independent-kernel-replay"

signalKey :: Signal -> String
signalKey signal = case signal of
  BlueprintConstructionNeeded -> "blueprint-construction-needed"
  PlanNodeReady -> "plan-node-ready"
  PlanDriftDetected -> "plan-drift-detected"
  PlanAmendmentProposed -> "plan-amendment-proposed"
  SourceInterpretationNeeded -> "source-interpretation-needed"
  ExplainBackAccepted -> "explain-back-accepted"
  AuthorCorrectionArrived -> "author-correction-arrived"
  MasterConflict -> "master-conflict"
  DelegationProposed -> "delegation-proposed"
  MasterEditProposed -> "master-edit-proposed"
  GovernanceEditProposed -> "governance-edit-proposed"
  CleanupOrRevertProposed -> "cleanup-or-revert-proposed"
  StopRequested -> "stop-requested"
  KnownOpenGoal -> "known-open-goal"
  IdentifierMissing -> "identifier-missing"
  InterfaceMismatch -> "interface-mismatch"
  MissingLeanImplementation -> "missing-lean-implementation"
  ProofSearchStalled -> "proof-search-stalled"
  CandidateKernelGreen -> "candidate-kernel-green"
  RejectedPatternRepeated -> "rejected-pattern-repeated"
  DownstreamBiasDetected -> "downstream-bias-detected"
  IntegrationReady -> "integration-ready"
  ReleaseRequested -> "release-requested"

renderAssessment :: Assessment -> String
renderAssessment assessment =
  unlines
    ( [ "candidate: " ++ candidateName candidate
      , "stage: " ++ stageKey (candidateStage candidate)
      , "plan-revision: " ++ candidatePlanRevision candidate
      , "promotion: " ++ promotionKey (assessmentState assessment)
      ]
        ++ renderFindings (assessmentFindings assessment)
    )
  where
    candidate = assessmentCandidate assessment
    renderFindings [] = ["findings: none"]
    renderFindings findings =
      "findings:" : ["  - [" ++ levelKey (findingLevel f) ++ "] " ++ findingCode f ++ ": " ++ findingMessage f | f <- findings]

renderRoute :: RouteDecision -> String
renderRoute decision =
  unlines
    [ "role: " ++ roleKey (routeRole decision)
    , "reason: " ++ routeReason decision
    , "suggested-capabilities: " ++ commaList (map capabilityKey (Set.toList (routeSuggestedCapabilities decision)))
    , "not-granted-by-routing: " ++ commaList (map capabilityKey (Set.toList (routeNotGranted decision)))
    , "next-artifact: " ++ routeNextArtifact decision
    ]

renderPolicy :: Policy -> String
renderPolicy policy =
  unlines
    [ "policy: " ++ policyName policy
    , "revision: " ++ policyRevision policy
    , "frozen-plan: " ++ policyPlanRevision policy
    , "authored-path: " ++ intercalate " -> " (map stageKey (policyPath policy))
    , "semantic-authorities: " ++ commaList (map renderAuthority (policyAuthorities policy))
    , "ordinary-work-mode: advisory routing; exploration remains open"
    , "promotion-mode: strict semantic, freshness, and production-reachability checks"
    ]

promotionKey :: PromotionState -> String
promotionKey state = case state of
  EvidenceIncomplete -> "evidence-incomplete"
  ScratchOnly -> "scratch-only"
  ProductionRejected -> "production-rejected"
  ProductionEligible -> "production-eligible"
  ReleaseEligible -> "release-eligible"

levelKey :: FindingLevel -> String
levelKey level = case level of
  Information -> "info"
  Caution -> "caution"
  Quarantine -> "quarantine"
  BlockProduction -> "block-production"

roleKey :: Role -> String
roleKey role = case role of
  SourceAwareBlueprinter -> "source-aware-blueprinter"
  ReadOnlyFidelityReviewer -> "read-only-fidelity-reviewer"
  OperationalScopeReviewer -> "operational-scope-reviewer"
  HaltCoordinator -> "halt-coordinator"
  LibraryRetrievalScout -> "library-retrieval-scout"
  LocalProofWorker -> "local-proof-worker"
  ScratchExplorer -> "scratch-explorer"
  SemanticRefiner -> "semantic-refiner"
  ProductionIntegrator -> "production-integrator"
  ReleaseAuditor -> "release-auditor"

capabilityKey :: Capability -> String
capabilityKey capability = case capability of
  ReadCurrentTaskScope -> "read-current-task-scope"
  ReadFrozenPlan -> "read-frozen-plan"
  ExecuteAssignedPlanNode -> "execute-assigned-plan-node"
  ChangeFrozenPlan -> "change-frozen-plan"
  ReadMaster -> "read-master"
  ReadGroundTruth -> "read-ground-truth"
  ReadRelevantAuthorAnswers -> "read-relevant-author-answers"
  ReadLeanTarget -> "read-lean-target"
  SearchLeanLibrary -> "search-lean-library"
  RunLean -> "run-lean"
  WriteScratch -> "write-scratch"
  WriteTargetBody -> "write-target-body"
  WriteLocalHelpers -> "write-local-helpers"
  ChangeTargetType -> "change-target-type"
  ChangeSemanticGraph -> "change-semantic-graph"
  ReadDownstreamCorollaries -> "read-downstream-corollaries"
  PromoteToProduction -> "promote-to-production"
  AskAuthorExplainBack -> "ask-author-explain-back"
  RunReleaseChecks -> "run-release-checks"
  SpawnSubagent -> "spawn-subagent"
  WriteMasterDocument -> "write-master-document"
  WriteGovernanceFiles -> "write-governance-files"
  WriteSemanticRecords -> "write-semantic-records"
  DeleteOrRevertFiles -> "delete-or-revert-files"
  StopAllWork -> "stop-all-work"

renderAuthority :: AuthorityRef -> String
renderAuthority authority = case authority of
  AuthorCorrection ref -> ref
  MasterAnchor ref -> "master:" ++ ref
  GroundTruthEntry ref -> "ground-truth:" ++ ref
  ExecutionCheckpoint n -> "checkpoint:" ++ show n

normalizeKey :: String -> String
normalizeKey = trim . map normalize
  where
    normalize c
      | c == '_' || isSpace c = '-'
      | otherwise = toLower c

trim :: String -> String
trim = dropWhileEnd isSpace . dropWhile isSpace

dropWhileEnd :: (a -> Bool) -> [a] -> [a]
dropWhileEnd predicate = reverse . dropWhile predicate . reverse

splitOn :: Char -> String -> [String]
splitOn delimiter value = case break (== delimiter) value of
  (before, []) -> [before]
  (before, _ : after) -> before : splitOn delimiter after

commaList :: [String] -> String
commaList = intercalate ", "

## 🗄 Database Schema Structure

The DSR Artifact Management System is designed with the following database schema to capture and manage the lifecycle of research artifacts effectively:

```markdown
Artifacts
├── ArtifactID (PK)
├── Title
├── Author(s)
├── CreationDate
├── Version
└── Keywords
    ├── ContextMotivation
    │   ├── ContextID (PK)
    │   ├── ArtifactID (FK)
    │   ├── ProblemTargeted
    │   ├── Objectives
    │   ├── HypothesesAssumptions
    │   └── Context
    ├── ArtifactDescription
    │   ├── DescriptionID (PK)
    │   ├── ArtifactID (FK)
    │   ├── Type
    │   ├── MainComponents
    │   ├── TechniquesUsed
    │   └── UniqueFeatures
    ├── DevelopmentProcess
    │   └── IterationID (FK)
    │       ├── DevelopmentID (PK)
    │       ├── ArtifactID (FK)
    │       ├── StagesTasks
    │       ├── ChallengesSolutions
    │       └── FeedbackChanges
    │           ├── Iterations
    │           │   ├── IterationID (PK)
    │           │   ├── ArtifactID (FK)
    │           │   ├── StartDate
    │           │   ├── EndDate
    │           │   └── Description
    │           │       ├── Changes
    │           │       │   ├── ChangeID (PK)
    │           │       │   ├── IterationID (FK)
    │           │       │   ├── Timestamp
    │           │       │   ├── Description
    │           │       │   ├── Reason
    │           │       │   └── Impact
    │           │       └── IterationEvaluations
    │           │           ├── EvaluationID (PK)
    │           │           ├── IterationID (FK)
    │           │           ├── Methodology
    │           │           ├── Results
    │           │           └── Timestamp
    ├── ArtifactVersions
    │   ├── VersionID (PK)
    │   ├── ArtifactID (FK)
    │   ├── VersionNumber
    │   ├── Description
    │   └── ReleaseDate
    ├── ArtifactUsage
    │   ├── UsageID (PK)
    │   ├── ArtifactID (FK)
    │   ├── UsageContext
    │   ├── ImpactDescription
    │   └── Timestamp
    ├── ArtifactFeedback
    │   ├── FeedbackID (PK)
    │   ├── ArtifactID (FK)
    │   ├── Source
    │   ├── FeedbackContent
    │   └── DateReceived
    └── Contributors
        ├── ContributorID (PK)
        ├── Name
        ├── Role
        └── Affiliation
            └── ArtifactContributors
                ├── ArtifactID (FK)
                ├── ContributorID (FK)
                ├── ContributionType
                └── Timestamp
    └── References
        ├── ReferenceID (PK)
        ├── ArtifactID (FK)
        ├── RelatedWorks
        └── KeyReferences
```

This schema is foundational to our system's ability to track, manage, and analyze DSR artifacts through their entire lifecycle. It's designed to facilitate easy data entry, comprehensive tracking of artifact evolution, and detailed analysis of research impact.

Contributors are encouraged to explore this structure and consider how it might be expanded or refined to support additional research management needs. We welcome your ideas and contributions to make this project even more valuable to the research community.
```

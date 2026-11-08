## ADDED Requirements

### Requirement: Project reports use defined Azure DevOps sources
The harness SHALL produce project reports only from configured Azure DevOps project data and SHALL identify the report generation time, query scope, and source work-item or pipeline data used.

#### Scenario: Generate delivery status report
- **WHEN** an operator requests a delivery status report for a configured project and reporting period
- **THEN** the harness returns a report with the stated scope, generation time, source data references, delivery progress, risks, and work-item status

### Requirement: Reports distinguish evidence from analysis
The harness SHALL label agent-generated summaries, risks, and recommendations as analysis and SHALL preserve links or identifiers for the Azure DevOps data supporting each factual claim.

#### Scenario: Report identifies an at-risk milestone
- **WHEN** the agent identifies a milestone as at risk from Azure DevOps data
- **THEN** the report labels the assessment as analysis and includes the relevant work-item, iteration, or pipeline evidence

### Requirement: Report publication is controlled
The harness SHALL generate reports as reviewable local artifacts by default. Publishing a report to Azure DevOps, a repository, or another collaboration system MUST require explicit operator confirmation and use a configured destination.

#### Scenario: Publish an approved report
- **WHEN** an operator confirms publication of a generated report to a configured Azure DevOps Wiki location
- **THEN** the harness publishes the reviewed report only to that location and records the published artifact reference

## ADDED Requirements

### Requirement: Scoped Azure DevOps work-item access
The harness SHALL require every work-item workflow to identify an Azure DevOps organization, project, and work-item scope before invoking an Azure DevOps integration. The harness MUST reject a request that does not supply a configured target or requests a target outside the operator's approved scope.

#### Scenario: Query within an approved project
- **WHEN** an operator requests a work-item query for a configured project
- **THEN** the agent retrieves only work items allowed by the configured organization, project, and identity permissions

#### Scenario: Request outside configured scope
- **WHEN** an operator requests work-item access for an unconfigured organization or project
- **THEN** the harness refuses the request and identifies the scope that must be configured

### Requirement: Reviewable work-item mutations
The harness SHALL present a structured change preview before creating or modifying an Azure DevOps work item. The preview MUST identify the target, changed fields, linked work items, and agent rationale; the harness MUST obtain explicit operator confirmation before executing a mutation.

#### Scenario: Approved work-item update
- **WHEN** an operator confirms a preview to update a work item's state and acceptance criteria
- **THEN** the harness applies only the displayed changes and reports the resulting work-item identifier and revision

#### Scenario: Declined work-item update
- **WHEN** an operator declines or does not confirm a mutation preview
- **THEN** the harness does not call an Azure DevOps write operation

### Requirement: Work-item workflow traceability
The harness SHALL record the request, selected scope, proposed changes, confirmation outcome, Azure DevOps response identifier, and any failure for each work-item mutation.

#### Scenario: Mutation audit record
- **WHEN** a confirmed work-item mutation completes
- **THEN** the harness creates a trace record that can be correlated with the Azure DevOps work item and its resulting revision

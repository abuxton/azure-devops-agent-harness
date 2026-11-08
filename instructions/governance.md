# Governance

## Required approvals

| Action | Required user decision |
| --- | --- |
| Every Azure DevOps MCP tool call | Allow or deny in VS Code |
| Work-item mutation | Confirm the structured preview, then allow the tool call |
| External report publication | Confirm the destination, then allow the tool call |

Never enable automatic MCP tool approval. A tool-call approval does not replace mutation or publication confirmation.

## Scope and identities

- Select a named local profile before tool use.
- Use a read-only identity for queries and reports.
- Use a separately approved write identity only for the confirmed mutation.
- Do not cross organizations or projects from the selected profile.

## Audit artifact

For each mutation or publication, record a local JSON or Markdown artifact in `audit/` with:

- request and selected profile;
- proposed change or destination;
- user confirmation outcome;
- Azure DevOps response identifier and revision;
- failure details, if any.

Do not include credentials or copied sensitive content in the artifact.

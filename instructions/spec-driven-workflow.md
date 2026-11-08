# Required local spec-driven workflow

Every harness engagement begins with a local OpenSpec change, including read-only queries, reports, work-item changes, and non-Azure DevOps work.

1. Create or select a change under `openspec/changes/`.
2. Record objective, selected profile, intended Azure DevOps effects, evidence plan, and review decision.
3. Place temporary tool output and scratch work in `tmp/`.
4. Obtain user review before an Azure DevOps MCP tool call.
5. Promote durable artifacts deliberately; leave intermediate material in `tmp/` for local review.

ADRs are out of scope for the initial template. OpenSpec artifacts are the in-loop review record.

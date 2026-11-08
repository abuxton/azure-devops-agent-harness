# Manual Azure DevOps smoke test

Run this test only against an approved non-production Azure DevOps project using a read-only profile.

1. Create and review a local OpenSpec change for the test.
2. Select the read-only local profile.
3. Start the Azure DevOps Remote MCP Server in VS Code.
4. Ask for a read-only work-item query scoped to the profile project.
5. Deny the first presented tool call and verify that no result or external write occurs.
6. Repeat the query and allow the presented tool call.
7. Verify that returned work items are in the selected project and that no mutation or publication is attempted.
8. Retain the OpenSpec and scratch evidence in `tmp/` for local review.

Record the date, client version, profile type, and result in `instructions/compatibility-matrix.md`.

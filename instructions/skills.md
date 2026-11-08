# Local skill deployment

`skills-lock.json` is a reviewed recommendation manifest, not an installer.

For each skill:

1. Review its source repository, path, license, and pinned `computedHash`.
2. Use organization-approved local skill-management tooling to install it under `.agents/skills/`.
3. Verify the installed content hash against `skills-lock.json`.
4. Review skill upgrades before changing the lock.
5. Remove the local skill if it is no longer approved.

Do not commit `.agents/skills/`, install skills from VS Code configuration, or add a task that installs or runs a skill.

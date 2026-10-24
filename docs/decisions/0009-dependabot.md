# Dependabot updates the lock file only

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `.github/dependabot.yml`

## Context

Dependabot's `pip` ecosystem updates `pyproject.toml` but not `uv.lock`, so CI's
`uv sync --locked` fails on its pull requests. The minimum versions in `pyproject.toml`
are deliberate: CI tests them, and users of a package may need them.

## Decision

Dependabot uses the `uv` ecosystem with `versioning-strategy: lockfile-only`, plus the
`github-actions` ecosystem. All Actions updates come in one pull request, and so do
minor and patch updates of development dependencies; runtime dependencies and major
updates come one pull request each. Commit messages start with `build:` without a
scope, and carry the `dependencies` and `build` labels.

## Rationale and alternatives

- **The `pip` ecosystem:** leaves `uv.lock` stale.
- **Letting Dependabot raise minimum versions:** drops support for versions that still
  work, with no change in the project to justify it.

## Consequences

Minimum versions move only when a project raises them on purpose. The labels and
prefix match the [agent-skills](https://github.com/jmfontaine/agent-skills) repository
setup.

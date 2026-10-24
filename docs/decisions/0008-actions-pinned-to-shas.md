# GitHub Actions pinned to commit SHAs

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** the workflows under `.github/workflows/`, in generated
  projects and in this repository

## Context

A workflow that references an action by tag runs whatever code the tag points to when
the job starts, and the action's owner can move the tag.

## Decision

Every action is pinned to a full commit SHA, with its version in a comment:
`uses: actions/checkout@<sha>  # vX.Y.Z`. No checkout keeps its token
(`persist-credentials: false`).

## Rationale and alternatives

- **Tags:** readable, but mutable.
- **Branches such as `release/v1`:** move on every release by design.

## Consequences

Dependabot updates the SHA and its comment together in each project. It does not
update the template's own copies of the workflows, so those are updated by hand.

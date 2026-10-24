# Releases through version pull requests

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated packages, `justfile` and `CONTRIBUTING.md`

## Context

Releasing used to mean committing a version bump on `main` and pushing it with the tag.
That bypasses pull requests and the required checks, and a build from `main` between
releases carried the last release's version.

## Decision

`main` changes only through pull requests, and between releases it carries a
development version, `X.Y.Z.devN`, which sorts below `X.Y.Z`:

1. `just release-prepare` opens a pull request that sets the release version. Merging
   it approves the release.
2. `just release` creates a signed tag on the merged commit and pushes only the tag,
   which starts the publish workflow.
3. `just release-next` opens a pull request that sets the next development version.

## Rationale and alternatives

- **Bumping on `main` and pushing it with the tag:** skips review and the checks, and
  needs a ruleset bypass.
- **No development version:** a build from `main` cannot be told apart from the last
  release.

## Consequences

Each release takes two small pull requests. The recipes refuse to run unless `main` is
clean and in sync with `origin/main`, and refuse versions in the wrong state. Both
version pull requests are left out of the release notes.

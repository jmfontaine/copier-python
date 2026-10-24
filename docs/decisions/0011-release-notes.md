# Release notes from git-cliff

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated packages, `cliff.toml` and `pyproject.toml`

## Context

The commits on `main` are the squash-merged pull request titles (see
[0007](0007-commit-titles.md)), so they already describe each change for users.

## Decision

git-cliff builds the release notes from those commits, grouped by type in a fixed
order (`chore` and `ci` share one group), with breaking changes in their own section
and the version pull requests left out.
It is pinned in the `dev` dependency group, so `just changelog-preview` and the
publish workflow run the same version.

## Rationale and alternatives

- **Groups by scope:** the titles have no scope.
- **git-cliff through `uvx` or git-cliff-action:** a version outside `uv.lock`, which
  can differ between the preview and the release.
- **A hand-written changelog:** repeats the pull request titles and drifts from them.

## Consequences

A pull request title is user-facing text. A title that is not a Conventional Commit is
left out of the notes without failing anything, since nothing checks titles. The
GitHub release carries the notes; the repository has no `CHANGELOG.md`.

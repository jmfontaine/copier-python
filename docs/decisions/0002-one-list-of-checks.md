# pre-commit as the one list of checks

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `.pre-commit-config.yaml`, `justfile`
  and `.github/workflows/ci.yml`

## Context

Checks can be listed in three places: the pre-commit hooks, `just qa`, and CI. Separate
lists drift. When pre-commit pins its own version of a tool, `uv.lock` can move the
tool to a new version while the hook stays on the old one, and CI fails on `main`.

## Decision

pre-commit is installed from the project's `dev` dependency group. The tools the
justfile also runs on their own (ruff, pyproject-fmt, ty, deptry, rumdl) are `dev`
dependencies and run as local hooks through `uv run`, so a hook and a recipe use the
version `uv.lock` pins. `just qa` and CI's lint job both run every hook on all files.
Packages add pyright `--verifytypes`, outside the hooks: it scores the whole public
API, and fails a new library until its first export, so as a hook it would block a
project's first commits.

## Rationale and alternatives

- **Remote hook repositories for ruff and pyproject-fmt:** pin a second version of
  each tool, which drifts from `uv.lock`.
- **A global pre-commit, or prek:** one more tool to install outside the project, at
  a version the project does not control.
- **Separate lists in `just qa` and CI:** every new check had to be added in three
  places.

## Consequences

A check added to `.pre-commit-config.yaml` runs everywhere. `just qa` lets fixers
rewrite files, and sees only files git tracks. The other hooks (the general file
checks, actionlint, cspell) run only through pre-commit, so their own repositories,
pinned in `.pre-commit-config.yaml`, are their single version.

A new package fails `just qa` and CI's lint job until it exports its first public
symbol; the commit hooks still pass.

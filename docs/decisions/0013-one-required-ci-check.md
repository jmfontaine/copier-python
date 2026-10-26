# One required CI check

- **Date:** 2026-10-26
- **Status:** Accepted
- **Related artifacts:** in generated projects, `.github/workflows/ci.yml`; in this
  repository, `.github/workflows/ci.yml`

## Context

A ruleset that requires each CI job by name has to change whenever a job is added,
renamed or removed, and a template update that does so breaks every project's pull
requests until someone edits the ruleset. A matrix job reports one check per
combination, so a new Python version changes the check names too.

## Decision

The CI workflow ends with a job `ci-passed`, displayed as `CI passed`. It needs every
other job of the workflow, runs whatever they did, and fails when any of them failed or
was canceled. A repository requires only `CI passed`, plus any required check that
comes from a different workflow.

## Rationale and alternatives

- **Requiring each job:** every change to the jobs or the matrix needs a matching
  ruleset change, made outside the pull request that causes it.
- **A summary job without `if: always()`:** a failed job skips it, and GitHub counts a
  skipped required check as passed, so the failure could merge.

## Consequences

A new job joins the `needs` list of `ci-passed`, or its failure goes unnoticed. The
check is named by the job's display name, so renaming it needs a ruleset change.

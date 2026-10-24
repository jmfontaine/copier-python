# Scopeless Conventional Commit titles

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `AGENTS.md`,
  `.github/pull_request_template.md` and, for packages, `cliff.toml`

## Context

Pull requests are squash-merged, so each pull request title becomes one commit on
`main`, and the release notes are built from those commits. Titles therefore need one
format that a tool can group.

## Decision

Pull request titles follow Conventional Commits without a scope,
`<type>: <description>`, with one of `feat`, `fix`, `perf`, `refactor`, `docs`, `test`,
`build`, `ci` or `chore`, and `!` before the colon for a breaking change. Commits on a
branch are free-form.

## Rationale and alternatives

- **Scoped titles:** scopes differ from one project to the next and are easy to apply
  inconsistently, so release notes cannot rely on them.
- **A narrower type list:** performance, build and CI changes would have no type of
  their own.

## Consequences

The release notes group commits by type, with breaking changes listed first. The
`git-commit` and `github-workflow` skills in
[agent-skills](https://github.com/jmfontaine/agent-skills) use the same rule.

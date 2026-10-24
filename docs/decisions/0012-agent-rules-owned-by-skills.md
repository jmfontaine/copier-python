# AGENTS.md leaves git rules to the skills

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects and in this repository, `AGENTS.md`;
  [ADR 0007](0007-commit-titles.md)

## Context

`AGENTS.md` repeated rules that the `git-commit` and `git-branch` skills in
[agent-skills](https://github.com/jmfontaine/agent-skills) already give agents: the
Conventional Commits pull request titles of ADR 0007, with signed branch commits, and a
rule against `git -C`. The copies had already drifted: `AGENTS.md` banned `git -C`
outright, while the skills forbid `git -C <path>` only when the current directory is
already the repository root. A project copying the old text contradicts the skills
whenever they change.

## Decision

`AGENTS.md`, in generated projects and in this repository, does not restate the rules
the `git-commit` and `git-branch` skills own. The skills' wording applies, including
their narrower `git -C` rule. The decision of ADR 0007 stands; only where it is written
changes.

## Rationale and alternatives

- **Keep the copies in `AGENTS.md`:** agents without the skills would read them, but
  each skill change would need the same edit in every project.

## Consequences

People and agents without the skills find the title rule in the pull request template
and, for packages, in `CONTRIBUTING.md`. Signed commits are enforced by the
signed-commit ruleset of the `github-workflow` skill's repository setup; for packages,
`CONTRIBUTING.md` also asks contributors to sign. Nothing outside the skills states the
`git -C` rule.

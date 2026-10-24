# AGENTS.md leaves git rules to the skills

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects and in this repository, `AGENTS.md`;
  [ADR 0007](0007-commit-titles.md)

## Context

`AGENTS.md` repeated two rules that the `git-commit` and `git-branch` skills in
[agent-skills](https://github.com/jmfontaine/agent-skills) already give agents: the
Conventional Commits pull request titles of ADR 0007, with signed branch commits, and
never running `git -C`. Two copies of a rule drift apart, and a project copying the old
text then contradicts the skills.

## Decision

`AGENTS.md`, in generated projects and in this repository, does not restate a rule the
skills own. It keeps what is specific to the project. The decision of ADR 0007 stands;
only where it is written changes.

## Rationale and alternatives

- **Keep the copies in `AGENTS.md`:** agents without the skills would read them, but
  each skill change would need the same edit in every project.

## Consequences

People and agents without the skills find the title rule in the pull request template
and, for packages, in `CONTRIBUTING.md`. Nothing outside the skills states the `git -C`
rule.

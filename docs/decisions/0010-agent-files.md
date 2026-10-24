# AGENTS.md as the only agent instruction file

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `AGENTS.md`

## Context

Coding agents read instruction files from the repository. Claude Code reads `AGENTS.md`
since its 2.1.277 release, so a `CLAUDE.md` that only imports it adds nothing.

## Decision

Generated projects ship `AGENTS.md` and no other agent instruction or configuration
file: no `CLAUDE.md`, no `.claude/settings.json`, no agent hooks.

## Rationale and alternatives

- **A `CLAUDE.md` importing `AGENTS.md`:** a second file to keep in step. Claude Code
  Review reads only `CLAUDE.md`, but no project uses it.
- **Agent permissions or hooks in `.claude/settings.json`:** specific to one agent and
  to how each maintainer works, so they belong outside the template.

## Consequences

One file holds the commands, conventions and Architecture section for every agent. By
default Claude Code skips `AGENTS.md` when a `CLAUDE.md` or `CLAUDE.local.md` exists in
the checkout or above it, so a contributor who keeps one must set Claude Code's project
instructions to read both. Revisit if a project starts using a tool that reads only its
own file.

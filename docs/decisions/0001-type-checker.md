# ty as the type checker

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `pyproject.toml` and
  `.pre-commit-config.yaml`

## Context

Generated projects need a type checker that runs on every commit and in CI. Packages
also need pyright's `--verifytypes`, which audits the completeness of a public API and
has no equivalent in other checkers.

## Decision

Generated projects check types with ty. Packages also run pyright `--verifytypes`, and
use pyright for nothing else.

## Rationale and alternatives

- **ty:** fast enough for a commit hook, and run from `uv.lock` like the other tools.
- **Strict mypy:** slower, and a second set of rules and plugins to configure next to
  pyright.
- **pyright as the checker:** it already runs for `--verifytypes`, but as a full
  checker it would be slower on every commit.

## Consequences

One type checker to configure and to satisfy. Suppressions use
`# ty: ignore[<rule>]`: ty skips mypy codes in `# type: ignore[...]`, and ruff's
`PGH003` flags a bare `# type: ignore`. Revisit if ty misses errors a project needs
caught, or stops being maintained.

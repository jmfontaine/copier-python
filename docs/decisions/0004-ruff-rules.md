# Ruff rule selection

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `pyproject.toml`

## Context

Ruff's defaults enable only a few rule sets. Selecting more catches more problems, but
some families flag code that is fine, and every ignore a project adds needs a reason
and upkeep. Selecting `ALL` also enables every new rule on each ruff update.

## Decision

Generated projects select, by name, every stable rule family that finds bugs or that
ruff fixes automatically, when it almost never fires on sound code. They ignore
nothing. The selection, starting from the families ruff recommends, lives in
`lint.select` in `pyproject.toml`, one commented line per family.

`E501` stays: the formatter cannot wrap long strings and comments, so it is the only
check that holds the line length.

## Rationale and alternatives

Each family was weighed by running `ruff check --select ALL` on about 90,000 lines of
four mature projects. The selected families that those projects did not already
enforce fired a handful of times, mostly on real problems. The families left out fired
hundreds or thousands of times on code the projects accepted, or need a policy
decision:

- `S` includes `S101`, which flags every `assert`, the way pytest checks results.
- `ANN` duplicates the type checker; `D` enforces a docstring style.
- `COM` conflicts with the formatter.
- `PLR` limits counts of arguments, branches and statements, and flags literal values;
  `C90` limits complexity. Code that is fine trips them, so projects ignore them.
- `EM` and `TRY` (through `TRY003`) move exception messages away from the `raise`,
  which reads worse; keeping `TRY` would need that rule ignored.
- `TC` moves typing-only imports behind `TYPE_CHECKING` for little gain.
- `T20`, `FBT`, `SLF` and `ARG` flag printing in command-line tools, boolean
  parameters, private access in tests, and callbacks with unused arguments.
- `INP` flags script directories that are not packages.
- `CPY`, `ERA`, `FIX` and `TD` enforce policies: copyright headers, commented-out code,
  task markers.
- Framework families (`DJ`, `NPY`, `PD`, `AIR`, `FAST`) belong to the projects that use
  the framework.
- `Q` conflicts with the formatter. `PYI` targets stub files, `INT` gettext, `ICN`
  import aliases for data libraries, and `YTT` and `FA` versions older than any the
  template supports. `SLOT`, `TID` and `PLC` enforce conventions rather than find bugs.

`ALL` with ignores was rejected because each ruff update can add rules that fail
existing code.

## Consequences

Adding or removing a family under this principle changes the template's
`pyproject.toml` only; a change to the principle itself takes a new ADR that supersedes
this one. A project that needs another family adds it to its own `pyproject.toml`. New
rules in a selected family apply on the next ruff update. Revisit a family when it
fires often on sound code, or when a family left out gains rules that find bugs.

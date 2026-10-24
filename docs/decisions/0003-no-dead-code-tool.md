# No dead-code tool

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `.pre-commit-config.yaml`

## Context

deadcode finds unused code, but on Python 3.14 it crashed, and it exited 0 when it
found something. Running it needed workarounds: an older Python, and a wrapper to fail
on its findings.

## Decision

Generated projects run no dead-code analyzer. deptry checks for unused and undeclared
dependencies.

## Rationale and alternatives

- **deadcode:** the crash and the exit code made it unreliable as a check.

## Consequences

Unused code is found in review rather than by a check. Revisit when a dead-code tool
runs on the development Python and fails on its findings.

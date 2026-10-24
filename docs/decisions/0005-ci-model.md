# CI tests what is published

- **Date:** 2026-10-24
- **Status:** Accepted
- **Related artifacts:** in generated projects, `.github/workflows/ci.yml` and, for
  packages, `.github/workflows/publish.yml`

## Context

A package's tests pass from the source tree while the published wheel can still miss a
file, require a dependency version older than any the lock file installs, or fail on a
Python version nobody ran. Running Dependabot pull requests through
`pull_request_target` gives untrusted code a write token.

## Decision

For packages:

- the tests run on every supported Python version;
- they also run against the oldest dependency versions `pyproject.toml` allows, with
  deprecation warnings as errors;
- the wheel and sdist are built once and checked; the wheel is installed into a clean
  environment and tested there with only the `test` dependency group, and the sdist is
  installed into another, which builds it from source, and checked without the tests;
- the publish workflow reruns CI on the tagged commit and uploads the files CI tested,
  never rebuilt.

CI triggers on `pull_request`, Dependabot's included; no workflow uses
`pull_request_target`.

## Rationale and alternatives

- **Testing only the source tree:** misses packaging and dependency-floor errors until
  users install the package.
- **Rebuilding in the publish job:** publishes files no test ran against.
- **`pull_request_target` for Dependabot:** runs the pull request's code with a token
  that can write to the repository.

## Consequences

CI takes longer for packages than for apps, which run their tests once. The `test`
group must hold only what the tests import, since the installed-wheel tests use it
alone.

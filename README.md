# copier-python

A [Copier](https://copier.readthedocs.io/) template for Python packages published to
PyPI and for private Python applications. Projects made from it share one setup for
dependencies, checks, CI and releases, and `copier update` brings later template
changes into each of them.

## Requirements

- [uv](https://docs.astral.sh/uv/), which also runs Copier through `uvx`
- [just](https://github.com/casey/just)
- git, with commit signing configured
- For packages: the [GitHub CLI](https://cli.github.com/) (`gh`), used by the release
  recipes

## Create a project

```bash
uvx copier copy gh:jmfontaine/copier-python my-project
cd my-project
git init -b main
just setup
git add -A
git commit -S -m "That's one small step for mankind, one giant leap for a man"
```

Copier asks a few questions:

| Question | What it decides |
| --- | --- |
| `project_kind` | `package`, published to PyPI, or `app`, never published |
| `cli` | Whether the project installs a command-line entry point |
| `project_name` | The distribution name (lowercase, hyphen-separated) |
| `package_name` | The import name; defaults to `project_name` with underscores |
| `description` | One line, also used as the package docstring |
| `github_owner` | Packages only: the GitHub account that hosts the repository, one of the maintainer's |
| `author_name`, `author_email` | The author in `pyproject.toml` |
| `python_min` | The oldest Python version the project supports |
| `copyright_year` | Packages only: the year in `LICENSE.txt` |

The first commit goes straight onto `main`. Every later change goes through a pull
request.

## What a project contains

- A src layout managed by uv, with `uv.lock` committed
- just recipes for the daily work; `just --list` shows them all
- Formatting, linting, type checking, dependency and spelling checks, all run by
  pre-commit on every commit, by `just qa`, and by CI
- pytest with coverage
- GitHub Actions CI on every pull request and on `main`
- Dependabot updates for the GitHub Actions and the lock file
- Issue forms, a pull request template, and an `AGENTS.md` for coding agents
- For packages: a license, a `CONTRIBUTING.md`, release notes, and a publish workflow
  that releases to PyPI from a version tag on `main`

## Work on a project

```bash
just setup  # Install the dependencies and the git hooks
just qa     # Run every check
just test   # Run the tests
```

The project's `AGENTS.md` describes its commands and conventions. For packages,
`CONTRIBUTING.md` also covers the pull request process and how to release.

## Set up GitHub and PyPI

The template provides the files. The repository settings come from the
[`github-workflow` skill](https://github.com/jmfontaine/agent-skills/blob/main/skills/github-workflow/references/repository-setup.md):
squash merges only, the rulesets, the label set, and Discussions with an "Ideas"
category for public repositories. The one required check is `CI passed`, the summary
job of the CI workflow.

A package needs two more things before its first release, described in its
`CONTRIBUTING.md`: a GitHub environment named `pypi`, and a trusted publisher on PyPI.

## Update a project

On a branch, with your work committed, run:

```bash
uvx copier update --skip-answered
```

Copier merges the template's changes into the project and leaves conflict markers
where both changed the same lines. Resolve them, run `just setup` to refresh `uv.lock`
and the git hooks, run `just qa` and `just test`, and open a pull request.

Copier leaves `README.md`, `cspell.json`, `src/` and `tests/` alone after creating
them: the project owns those. It recreates one only if it was deleted.

## Known limits

- A new library fails `just qa` and its CI lint job until it exports its first public
  function or class: pyright `--verifytypes` scores an empty public API at 0%.

## Develop the template

```bash
just setup  # Install the tools and the git hooks
just qa     # Run this repository's checks
just test   # Render every kind of project and run its checks
```

[AGENTS.md](AGENTS.md) holds the conventions for changing the template, and
[docs/decisions/](docs/decisions/) the reasons behind its main choices.

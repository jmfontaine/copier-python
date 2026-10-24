# AGENTS.md

Guidance for coding agents working in this repository.

## Project

copier-python: a [Copier](https://copier.readthedocs.io) template for Python packages
and applications. [README.md](README.md) is the manual for its users;
[docs/decisions/](docs/decisions/) records why its main choices were made.

## Commands

```bash
just setup              # Install the tools and the git hooks (hooks: main checkout only)
just format             # Format Markdown with rumdl
just lint-fix           # Lint Markdown with rumdl and fix what it can
just qa                 # Every pre-commit hook on tracked files
just spell              # cspell against cspell.json
just test               # Render every variant and run the checks its CI would run
just test <dir>         # The same, keeping the rendered projects in <dir>
```

Before finishing a change, run `just qa && just test`. `just qa` sees only files git
tracks, so `git add` new ones first; `just test` renders from the working tree,
uncommitted changes included.

## Conventions

- Pull requests are squash-merged, so the pull request title is the commit on `main`.
  It follows [Conventional Commits](https://www.conventionalcommits.org/) without a
  scope, `<type>: <description>`, with one of `feat`, `fix`, `perf`, `refactor`,
  `docs`, `test`, `build`, `ci` or `chore`, and `<type>!:` for a breaking change.
  Commits on a branch are free-form but always signed (`git commit -S`)
- Write US English everywhere
- [README.md](README.md) is a manual: how to create, work on and update a project.
  Keep it to what a user needs, without version numbers, tool lists or reasons that
  go stale. A change that alters those steps updates it in the same pull request
- A choice a future contributor could reverse without knowing why gets an ADR in
  [docs/decisions/](docs/decisions/), one file per decision, numbered. Never rewrite
  an accepted ADR: a changed decision gets a new one that supersedes it
- Workarounds that are knowingly less than ideal carry a `KLUDGE:` comment stating
  what is wrong and what removes it
- Run `git` commands directly, never with `git -C`

## Alignment with agent-skills

This template must stay aligned with the skills in
[agent-skills](https://github.com/jmfontaine/agent-skills), so that generated projects
and the skills never drift apart. The relevant ones:

| Skill | What it governs here |
| --- | --- |
| [`github-workflow`](https://github.com/jmfontaine/agent-skills/tree/main/skills/github-workflow) | Issue forms, the pull request template, Dependabot, labels, the Discussions link, the "Deviations from the shared workflow" section; `references/repository-setup.md` is the checklist |
| [`git-branch`](https://github.com/jmfontaine/agent-skills/tree/main/skills/git-branch) | Branch names the release recipes create |
| [`git-commit`](https://github.com/jmfontaine/agent-skills/tree/main/skills/git-commit) | Pull request titles, signed commits, the first-commit message, where cSpell words live |
| [`product-development-system`](https://github.com/jmfontaine/agent-skills/tree/main/skills/product-development-system) | The Architecture section of the generated AGENTS.md, and where `docs/` artifacts go |
| [`uv`](https://github.com/jmfontaine/agent-skills/tree/main/skills/uv) | How the recipes and docs change dependencies |

- Check every change to the template's GitHub files, AGENTS.md, CONTRIBUTING.md,
  justfile or `_message_after_copy` against these skills.
- When a skill changes, update the template, and this repository's own files, in the
  same way.
- A difference without a reason recorded under "Deviations from the shared workflow"
  (here, or in the generated AGENTS.md) is drift: fix it.

## Architecture

### Shape

A Copier template. `copier.yml` holds the questions and the template-wide constants;
`template/` holds the files it renders. The main choices behind what it generates, and
their reasons, are ADRs in [docs/decisions/](docs/decisions/).

### Structure

- `copier.yml`: questions, constants (`python_dev`, `python_max`), and the files
  seeded once (`_skip_if_exists`)
- `template/`: the rendered files; `.jinja` files go through Jinja, and conditional
  file names decide which variants get a file
- `scripts/test-template.sh`: renders each variant and runs its checks
- `pyproject.toml` and `uv.lock`: this repository's own tools (pre-commit, rumdl), not
  part of the template
- `docs/decisions/`: ADRs for the template's main choices

### Testing

`just qa` runs the pre-commit hooks on this repository: file hygiene, `check-yaml`,
actionlint, shellcheck, cspell, and rumdl for Markdown. cspell and rumdl skip
`template/`, whose text the rendered projects check.

`just test` renders a library, a CLI package whose import name differs from its
distribution name, an app and a CLI app. In each one it runs `just qa` and
`just test`; for the packages it also builds, checks and install-tests the
distributions.

### CI

`.github/workflows/ci.yml` runs the pre-commit hooks and `scripts/test-template.sh` on
pushes to `main` and on pull requests. Actions are pinned to commit SHAs
([ADR 0008](docs/decisions/0008-actions-pinned-to-shas.md)); Dependabot keeps them and
`uv.lock` current. It does not see the `.jinja` workflows under `template/`: bump
those by hand.

## Deviations from the shared workflow

- No releases, so no tags and no milestones: `copier update` takes a project to the
  template's latest `main`.

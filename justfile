set quiet := true

# List the available recipes
_list:
    just --list

# Format Markdown
format:
    uv run rumdl fmt

# Check Markdown formatting without modifying files
format-check:
    uv run rumdl fmt --check

# Lint Markdown
lint:
    uv run rumdl check

# Lint Markdown and fix issues
lint-fix:
    uv run rumdl check --fix

# Run pre-commit on all files
pre-commit:
    uv run pre-commit run --all-files

# Install pre-commit hooks (main checkout only)
pre-commit-install:
    #!/usr/bin/env bash
    set -euo pipefail
    # Linked worktrees share the main checkout's .git/hooks: installing from one
    # would replace the hook every checkout uses and point it at this worktree's
    # .venv, which disappears with the worktree.
    common_dir=$(git rev-parse --path-format=absolute --git-common-dir)
    if [ "$(git rev-parse --path-format=absolute --git-dir)" != "$common_dir" ]; then
        echo "Error: this is a linked worktree; it shares the hooks in $common_dir/hooks with every other checkout. Install hooks from the main checkout instead." >&2
        exit 1
    fi
    uv run pre-commit install

# Update pre-commit hooks to latest versions
pre-commit-update:
    uv run pre-commit autoupdate --freeze

# Run all quality assurance checks: every pre-commit hook on all tracked files
qa: pre-commit

# Set local dev environment up (hooks: main checkout only)
setup:
    #!/usr/bin/env bash
    set -euo pipefail
    uv sync
    # Same guard as pre-commit-install: a linked worktree must not replace the
    # hook it shares with every other checkout.
    if [ "$(git rev-parse --path-format=absolute --git-dir)" = "$(git rev-parse --path-format=absolute --git-common-dir)" ]; then
        uv run pre-commit install
    else
        echo "Linked worktree: skipped installing the git hooks, which the main checkout's hooks already cover"
    fi

# Check spelling against cspell.json, the word list VS Code also uses
spell:
    uv run pre-commit run cspell --all-files

# Render every project variant and run its checks (optional output directory)
[positional-arguments]
test *args:
    scripts/test-template.sh "$@"

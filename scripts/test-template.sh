#!/usr/bin/env bash
# Render every project variant and run the checks each generated project runs.
#
# Usage: scripts/test-template.sh [OUTPUT_DIR]
#
# Renders from the working tree, uncommitted changes included. The generated
# projects stay in OUTPUT_DIR (a temporary directory by default) for inspection.
set -euo pipefail

template=$(cd "$(dirname "$0")/.." && pwd)
out=${1:-$(mktemp -d)}
mkdir -p "$out"
# Absolute, since each variant is rendered after a `cd` into the previous one.
out=$(cd "$out" && pwd)

# Generated projects commit nothing here, but pre-commit wants a repository.
export GIT_AUTHOR_NAME=copier-python GIT_AUTHOR_EMAIL=copier-python@invalid
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

render() {
    local name=$1
    shift
    echo "::group::$name"
    # A fresh copy each run: Copier keeps the seeded files of an existing one.
    rm -rf "${out:?}/$name"
    uvx copier copy --quiet --defaults --vcs-ref HEAD \
        --data "project_name=$name" --data "description=The $name test project" \
        "$@" "$template" "$out/$name"
    cd "$out/$name"
    git init --quiet --initial-branch main
}

check() {
    uv sync --all-groups --quiet
    git add --all
    just qa
    just test
}

check_distributions() {
    local package=$1 cli=$2
    rm -rf dist
    uv build --quiet
    uv run --no-project python scripts/check_distributions.py dist
    uvx twine check --strict dist/*
    # The wheel name publish.yml expects for a release of this version.
    test -f "dist/${package//-/_}-$(uv version --short)-py3-none-any.whl"
    local env
    env=$(mktemp -d)
    uv venv --quiet --seed "$env"
    "$env/bin/python" -m pip install --quiet dist/*.whl
    "$env/bin/python" scripts/check_installed_package.py
    if [ "$cli" = true ]; then
        "$env/bin/$package" --version
    fi
}

render lib-pkg
# pyright --verifytypes scores a package that exports nothing at 0% and fails,
# so give the library the public function a first real change would add.
cat >>src/lib_pkg/__init__.py <<'PY'


def greet(name: str) -> str:
    """Return a greeting for name."""
    return f"Hello, {name}!"
PY
sed -i.bak 's/__all__ = \["__version__"\]/__all__ = ["__version__", "greet"]/' src/lib_pkg/__init__.py
rm src/lib_pkg/__init__.py.bak
check
check_distributions lib-pkg false
echo "::endgroup::"

# An import name that differs from the distribution name.
render cli-pkg --data cli=true --data package_name=clipkg
check
check_distributions cli-pkg true
echo "::endgroup::"

render app --data project_kind=app
check
test ! -e LICENSE.txt
test ! -e .github/workflows/publish.yml
echo "::endgroup::"

# Above python_dev, so .python-version has to follow python_min.
render cli-app --data project_kind=app --data cli=true --data python_min=3.15
check
test "$(cat .python-version)" = 3.15
uv run cli-app --version
echo "::endgroup::"

echo "All variants passed; projects are in $out"

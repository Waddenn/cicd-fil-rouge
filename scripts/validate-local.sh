#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p reports/local
for version in 3.11 3.12 3.13; do
  envdir="../.envs/python-$version"
  uv venv --python "$version" "$envdir"
  uv pip install --python "$envdir/bin/python" -r requirements-dev.txt
  "$envdir/bin/python" -m pytest --junitxml="reports/local/pytest-$version.xml" 2>&1 | tee "reports/local/pytest-$version.log"
done
../.envs/python-3.13/bin/ruff check . 2>&1 | tee reports/local/ruff-check.log
../.envs/python-3.13/bin/ruff format --check . 2>&1 | tee reports/local/ruff-format.log

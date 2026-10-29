#!/usr/bin/env bash
# The one check agents and CI run before calling a change done.
set -euo pipefail
cd "$(dirname "$0")/.."

docker compose --profile test run --rm tests sh -c 'uv run ruff check src tests && uv run pytest -q'

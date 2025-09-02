#!/usr/bin/env bash
set -euo pipefail

if [[ ! -x ".venv/bin/python" ]]; then
  echo ".venv not found; creating with virtualenv" >&2
  python3 -m virtualenv .venv
fi

exec .venv/bin/python -m pytest -q --cov=. --cov-report=term-missing


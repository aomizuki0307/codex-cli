param([string]$task = "help")

# 好きな方: "py" か "python"
$py = "py"

switch ($task) {
  "venv" {
    & $py -m venv .venv
    & .\.venv\Scripts\python.exe -m pip install -U pip
    & .\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
  }
  "fmt"  { ruff --fix .; black . }
  "lint" { ruff . }
  "test" { pytest -q }
  "pc"   { pre-commit run -a --show-diff-on-failure }
  default {
    Write-Host "tasks: venv | fmt | lint | test | pc"
  }
}

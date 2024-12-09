.SILENT:
.PHONY: help init update lint test license-report, docs, init-venv
.DEFAULT_GOAL := help

define PRINT_HELP_SCRIPT
import re, sys

for line in sys.stdin:
    match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
    if match:
        target, help = match.groups()
        print(f'{target:20} {help}')

endef
export PRINT_HELP_SCRIPT

update-requirements: ## Update requirements files form setup.py and requirements/requirements-dev.in
	./venv/bin/pip-compile setup.py requirements/constraints.in --extra all \
	--output-file=./requirements.requirements.txt --resolver backtracking --verbose --resolver=backtracking
	./venv/bin/pip-compile ./requirements/requirements-dev.in \
	--output-file=./requirements/requirements-dev.txt --verbose --resolver=backtracking

upgrade-requirements: # Upgrade requirements files from setup.py and requirements/requirements-dev.in
	./venv/bin/pip-compile setup.py requirements/constraints.in --extra all --upgrade \
	--output-file=./requirements/requirements.txt --resolver=backtracking --verbose
	./venv/bin/pip-compile ./requirements/requirements-dev.in \
	--output-file=./requirements/requirements-dev.txt --resolver=backtracking --verbose

reset-venv:  ## Makes installed packages match requirements/
	./venv/bin/pip-sync ./requirements/requirements.txt ./requirements/requirements-dev.txt
	./venv/bin/pip install -e . --no-deps

sync-venv: update-requirements reset-venv  ## Sync venv with requirements

help: ## Show this help
	@python -c "$$PRINT_HELP_SCRIPT" < $(MAKEFILE_LIST)

init-venv:  ## Initialize Virtual Environment
	@python3.12 -m venv venv
	./venv/bin/python3 -m pip install -U pip
	./venv/bin/python3 -m pip install pip-tools

init: init-venv  ## Initialize project for local development environment
	#  This command should only be used for the initial setup. Once setup use `make reset-venv`
	@./venv/bin/python3 -m install -U pip
	@./venv/bin/python3 -m pip install -r requirements/requirements.txt
	@./venv/bin/python3 -m pip install -r requirements/requirements-dev.txt
	@./venv/bin/python3 -m pip install -e . --no-deps

clean:  ## remove build artifacts
	rm -rf build dist venv pip-wheel-metadata htmlcov
	find . -name .tox | xargs rm -rf
	find . -name __pycache__ | xargs rm -rf
	find . -name .pytest_cache | xargs rm -rf
	find . -name *.egg-info | xargs rm -rf
	find . -name setup-py-dev-links | xargs rm -rf

lint:  ## Run Linters
	@./venv/bin/ruff format
	@./venv/bin/ruff check
	@./venv/bin/isort .  --check-only

test: ## Run tests
	@./venv/bin/pytest -vv --durations=10 --cov-fail-under=90 --cov=virtual-lab --cov-report html tests/



# init: ## Initialize Project
# 	@python3.12 -m venv venv
# 	@./venv/bin/python3 -m pip install --upgrade pip
# 	@./venv/bin/python3 -m pip install -U pip setuptools wheel pip-tools
# 	@./venv/bin/python3 -m pip install -r requirements/requirements.txt
# 	@./venv/bin/python3 -m pip install -r requirements/requirements-dev.txt
# 	@./venv/bin/python3 -m pip install -e . --no-deps
# 	@./venv/bin/python3 -m pre_commit install --install-hooks --overwrite




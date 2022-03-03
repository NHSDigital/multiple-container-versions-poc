SHELL=/bin/bash -euo pipefail

install-python:
	poetry install

.git/hooks/pre-commit:
	cp scripts/pre-commit .git/hooks/pre-commit

# required
install: install-python .git/hooks/pre-commit

# required
lint:
	find . -name '*.py' -not -path '**/.venv/*' | xargs poetry run flake8

clean:
	rm -rf build
	rm -rf dist

# required
publish: clean


_dist_include="poetry.lock poetry.toml pyproject.toml Makefile"

# required
release: clean publish build-proxy
	mkdir -p dist
	for f in $(_dist_include); do cp -r $$f dist; done
	cp ecs-proxies-deploy.yml dist/ecs-deploy-sandbox.yml
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-qa-sandbox.yml
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-dev-sandbox.yml

test: docker-test
	echo done


docker-build:
	poetry run docker-compose build

docker-up: docker-build
	poetry run docker-compose up -d


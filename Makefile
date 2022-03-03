SHELL=/bin/bash -euo pipefail

install-python:
	poetry install

.git/hooks/pre-commit:
	cp scripts/pre-commit .git/hooks/pre-commit

# required
install: install-node .git/hooks/pre-commit

# required
lint:
	npm run lint
	find . -name '*.py' -not -path '**/.venv/*' | xargs poetry run flake8

clean:
	rm -rf build
	rm -rf dist

# required
publish: clean
	mkdir -p build
	npm run publish 2> /dev/null


_dist_include="pytest.ini poetry.lock poetry.toml pyproject.toml Makefile"

# required
release: clean publish build-proxy
	mkdir -p dist
	for f in $(_dist_include); do cp -r $$f dist; done
	cp ecs-proxies-deploy.yml dist/ecs-deploy-sandbox.yml
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-qa-sandbox.yml
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-dev-sandbox.yml

test: docker-test
	echo done

smoketest:
#	this target is for end to end smoketests this would be run 'post deploy' to verify an environment is working
	poetry run pytest -v --junitxml=smoketest-report.xml -s -m smoketest


docker-build:
	poetry run docker-compose build

docker-up: docker-build
	poetry run docker-compose up -d


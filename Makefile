bash: build
	docker-compose run -w /code --rm devenv bash

build:
	docker-compose build devenv

lint: build
	docker-compose run -w /code --rm devenv bash ./scripts/lint.py

rebuild:
	docker-compose build --no-cache devenv

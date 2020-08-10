## The Makefile includes instructions on environment setup and lint tests
# Create and activate a virtual environment
# Install dependencies in requirements.txt
# Dockerfile should pass hadolint
# app.py should pass pylint
# (Optional) Build a simple integration test

setup:
	# Create python virtualenv & source it
	# source ~/.devops/bin/activate
	python3 -m venv ~/.devops

install:
	# This should be run from inside a virtualenv
	. ~/.devops/bin/activate && pip install -r requirements.txt

app-build:
	docker build . --tag translator
	docker tag translator kabalasu/translator

db-build:
	docker build ./scripts --tag my_postgres
	docker tag my_postgres kabalasu/my_postgres

upload:
	docker push kabalasu/my_postgres
	docker push kabalasu/translator

db-dev:
	docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=root -e POSTGRES_DB=postgres --name my_postgres my_postgres
	sleep 10
	docker exec -e PGPASSWORD=password -it my_postgres  psql -h 127.0.0.1 -p 5432 --user root --dbname postgres

db:
	docker network create mynet
	docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_USER=root -e POSTGRES_DB=postgres --net mynet --name my_postgres kabalasu/my_postgres
	sleep 10
	docker exec -e PGPASSWORD=password -it my_postgres  psql -h 127.0.0.1 -p 5432 --user root --dbname postgres

db-teardown:
	docker container stop my_postgres
	docker container rm my_postgres
app:
	docker run -it -p 8000:80 --net mynet --name translator translator

app-teardown:
	docker container stop translator
	docker container rm translator

lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	sudo hadolint Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	# This should be run from inside a virtualenv
	. ~/.devops/bin/activate && pylint --disable=R,C,W,E1101 app.py

all: install lint test

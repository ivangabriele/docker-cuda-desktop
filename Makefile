.PHONY: clean kill

bash:
	docker compose run kde /bin/bash

build:
	docker build --build-arg="FROM_TAG=23.09-py3" -f ./kde/Dockerfile -t ivangabriele/cuda-desktop:latest .

clean: kill
	docker compose down -v

kill:
	docker compose kill

push:
	docker push ivangabriele/cuda-desktop:latest

start:
	docker compose up kde

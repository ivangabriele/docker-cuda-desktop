.PHONY: bash build

bash:
	docker compose run desktop /bin/bash

build:
	docker build --build-arg="FROM_TAG=23.09-py3" -t ivangabriele/cuda-desktop:latest .

clean:
	docker compose down -v

push:
	docker push ivangabriele/cuda-desktop:latest

start:
	docker compose up


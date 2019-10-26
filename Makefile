TEMPLATE_NAME ?= janus-webrtc-gateway-docker

build:
	@docker build -t q09029/$(TEMPLATE_NAME) .

build-nocache:
	@docker build --no-cache -t q09029/$(TEMPLATE_NAME) .

build-raspberry:
	@docker buildx build -t q09029/$(TEMPLATE_NAME) --platform linux/arm/v7 .

bash:
	@docker run --rm --net=host --name="janus" -it -t q09029/$(TEMPLATE_NAME) /bin/bash

run:
	@docker run --rm --net=host --name="janus" -it -t q09029/$(TEMPLATE_NAME)

run-mac:
	@docker run --rm -p 80:80 -p 8088:8088 -p 8188:8188 --name="janus" -it -t q09029/$(TEMPLATE_NAME)

run-hide:
	@docker run --rm --net=host --name="janus" -it -t q09029/$(TEMPLATE_NAME) >> /dev/null

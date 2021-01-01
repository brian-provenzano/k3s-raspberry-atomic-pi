# build for ARMv7 (rpi)
IMAGE="warpigg/polaris-arm"
PROJECT="arm"
build:
	@export DOCKER_CLI_EXPERIMENTAL=enabled
	@docker login
	@echo "Create builder"
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@docker buildx rm $(PROJECT)-builder
	@docker buildx create --name $(PROJECT)-builder --use --driver docker-container --driver-opt image=moby/buildkit:master,network=host
	@echo "Start Inspect Bootstrap"
	@docker buildx inspect --bootstrap
	@echo "Docker build"
	@docker buildx build -t $(IMAGE):$(version) --platform linux/arm/v7 --push .
	@echo "Remove builder"
	@docker buildx rm $(PROJECT)-builder
	@echo "Published version $(version)"

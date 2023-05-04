.PHONY: build

LOCAL_PHP_VERSION ?= 8.1

build: all-cli all-cli-dev all-php-fpm all-php-fpm-dev all-nginx all-nginx-dev

all-cli:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:8.1 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:8.0 8.0

all-cli-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.1/dev.Dockerfile \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:8.1-dev 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:8.0-dev 8.0

all-php-fpm:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=fpm \
		-t mutationdigitale/php-fpm:8.1 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=fpm \
		-t mutationdigitale/php-fpm:8.0 8.0

all-php-fpm-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.1/dev.Dockerfile \
		--build-arg PHP_VERSION=8.1 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t mutationdigitale/php-fpm:8.1-dev 8.1
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		-f 8.0/dev.Dockerfile \
		--build-arg PHP_VERSION=8.0 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t mutationdigitale/php-fpm:8.0-dev 8.0

all-nginx:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		-t mutationdigitale/nginx:8.1 nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		-t mutationdigitale/nginx:8.0 nginx


all-nginx-dev:
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.1 \
		--build-arg NGINX_CONF=dev.default.conf \
		-t mutationdigitale/nginx:8.1-dev nginx
	docker buildx build --load --platform linux/amd64 --builder all-platforms \
		--build-arg PHP_VERSION=8.0 \
		--build-arg NGINX_CONF=dev.default.conf \
		-t mutationdigitale/nginx:8.0-dev nginx

setup:
	docker buildx create --name all-platforms --platform linux/amd64,linux/arm64
	docker buildx use all-platforms
	docker buildx inspect --bootstrap

local:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t mutationdigitale/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=php-fpm \
		-t mutationdigitale/php-fpm:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}

	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=cli \
		-t mutationdigitale/cli:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}

	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		-t mutationdigitale/nginx:${LOCAL_PHP_VERSION} nginx
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg NGINX_CONF=dev.default.conf \
		-t mutationdigitale/nginx:${LOCAL_PHP_VERSION}-dev nginx

run:
	docker buildx build --load --platform linux/amd64 \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=fpm \
		-t mutationdigitale/php-fpm:${LOCAL_PHP_VERSION} ${LOCAL_PHP_VERSION}
	docker run --rm -it mutationdigitale/php-fpm:${LOCAL_PHP_VERSION} sh

run-dev:
	docker buildx build --load --platform linux/amd64 \
		-f ${LOCAL_PHP_VERSION}/dev.Dockerfile \
		--build-arg PHP_VERSION=${LOCAL_PHP_VERSION} \
		--build-arg PROJECT_TYPE=php-fpm \
		-t mutationdigitale/php-fpm:${LOCAL_PHP_VERSION}-dev ${LOCAL_PHP_VERSION}
	docker run --rm -it mutationdigitale/php-fpm:${LOCAL_PHP_VERSION}-dev sh

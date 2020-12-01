.PHONY: build

build: all-php-fpm all-nginx

all-php-fpm:
	docker build --build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT=php-fpm \
		-t craftcms/php-fpm:7.4 7.4
all-php-fpm-dev:
	docker build -f dev.Dockerfile \
		--build-arg PHP_VERSION=7.4 \
		--build-arg PROJECT_TYPE=php-fpm \
		-t craftcms/php-fpm:7.4-dev 7.4

all-nginx:
	docker build --build-arg PHP_VERSION=7.4 \
		-t craftcms/nginx:7.4 nginx
all-nginx-dev:
	docker build --build-arg PHP_VERSION=7.4-dev \
		-t craftcms/nginx:7.4 nginx

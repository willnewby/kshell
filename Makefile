default: build push

build:
	docker build . -t willnewby/kshell:with-hey

push:
	docker push willnewby/kshell:with-hey

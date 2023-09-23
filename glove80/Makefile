TAG :=	private/zmk-glove80

all:
	$(MAKE) left
	$(MAKE) right

left right:
	mkdir -p .app output
	docker build --tag $(TAG) .
	docker run --rm -it \
		-v `readlink -f $$SSH_AUTH_SOCK`:/.ssh-agent -e SSH_AUTH_SOCK=/.ssh-agent \
	        -v $(PWD)/.app:/app:z \
	        -v $(PWD)/config:/app/config:z,ro \
		-v $(PWD)/output:/app/output:z \
	        -v $(PWD):/src:z,ro \
	        $(TAG) /src/build.sh $@

clean:
	find . -name \*~ -delete
	sudo rm -rf .app output

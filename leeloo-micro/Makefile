TAG :=	private/zmk-leeloo-micro

both left right:
	docker build --tag $(TAG) .
	mkdir -p .app
	mkdir -p output
	docker run --rm -it \
		-v `readlink -f $$SSH_AUTH_SOCK`:/.ssh-agent -e SSH_AUTH_SOCK=/.ssh-agent \
	        -v $(PWD)/.app:/app:z \
	        -v $(PWD)/config:/app/config:z,ro \
		-v $(PWD)/output:/app/output:z \
	        -v $(PWD):/src:z,ro \
	        $(TAG) /src/build.sh $@

clean:
	find . -name \*~ -delete
	sudo rm -rf .app

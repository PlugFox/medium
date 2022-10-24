docker-build:
	@docker build . -t medium

docker-run:
	@docker run -it --rm -w /app $(PWD)/data:/app/data -p 8080:8080 medium /app/bin/server
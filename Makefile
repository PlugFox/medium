.PHONY: clean get upgrade upgrade-major dependencies outdated codegen fix docker-build docker-run

clean:
	@rm -rf coverage .dart_tool .packages pubspec.lock
	@find . -type d -name '__generated__' -delete
	@find . -type f -name '*.gql.dart' -delete

fix:
	@dart fix --apply

get:
	@timeout 60 dart pub get

upgrade:
	@timeout 60 dart pub upgrade

upgrade-major:
	@timeout 60 dart pub upgrade --major-versions

outdated: get
	timeout 120 dart pub outdated

dependencies: upgrade
#	@timeout 120 dart pub outdated --dependency-overrides --dev-dependencies --prereleases --show-all --transitive
	@timeout 120 dart pub deps

codegen: get
	@dart run build_runner build --delete-conflicting-outputs

docker-build:
	@docker build . -t plugfox/medium:0.0.2

docker-run:
	@docker run -it --rm -w /app -v $(PWD)/data:/app/data -p 8080:8080 plugfox/medium:0.0.2

docker-deploy:
	@docker push plugfox/medium:0.0.2
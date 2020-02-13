SERVICE?=airgo

test: #: Run RSpec. Example usage:  make rspec TEST_FILE=spec/lib/processing/expire_processor_spec.rb
	docker-compose run --rm -e RACK_ENV=test -e CI=true $(SERVICE) bundle exec rspec

rspec: #: Run RSpec. Example usage:  make rspec TEST_FILE=spec/lib/processing/expire_processor_spec.rb
	docker-compose run --rm -e RACK_ENV=test -e CI=true $(SERVICE) bundle exec rspec

down:
	docker-compose down

up:
	docker-compose up -d

bundle: #: Run a bundle install on the container
	docker-compose run --rm $(SERVICE) bundle install --with=development test

bash:
	docker-compose exec $(SERVICE) bash

log:
	docker-compose logs $(SERVICE)

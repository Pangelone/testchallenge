# Book Management API (Test Challenge)

Minimal Rails API for book reservations and optimized reads.

## Requirements
- Ruby 2.7.5
- Bundler

## Setup
```
bundle install
bin/rails db:setup
bin/rails db:seed
```

## Run
```
bin/rails server
```

## Endpoints
- `GET /books`
- `GET /books/:id`
- `POST /books/:id/reserve` (body: `{ "email": "user@example.com" }`)

## Tests
```
bundle exec rspec
```

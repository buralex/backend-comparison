## Development

```bash
cp .env.example .env.local
```

Export environment variables:

```bash
set -o allexport && source .env.local && set +o allexport
```

Start a database for backend

```bash
docker compose -f compose.yml --project-name $PROJECT_NAME up --detach postgres-db
```

```bash
go run main.go
```

# For build and run container locally

```bash
$ docker build  -t go-myapp .
$ docker run --rm -p 8080:8080 -t go-testing go-myapp
```

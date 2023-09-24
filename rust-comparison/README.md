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
cargo run
```

To format code

```bash
cargo fmt
```

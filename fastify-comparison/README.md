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

Install dependencies and start the app:

```bash
npm ci
npm run dev
```

### DB migrations

---

To create an automatically generated `migration`.

```bash
npm run migration-generate src/mainDb/migrations/Initial
```

After that go to `src/mainDb/migrations` folder, and check the content (and fix eslint)

⚠️ Add migration to git

---

To create an empty `migration`.

```bash
npm run migration-create src/mainDb/migrations/NewChanges
```

Run/revert migrations

```bash
npm run migration-run
npm run migration-revert
```

## Deploy image to docker

```bash
cp .env.example .env.prod
```

Export environment variables:

```bash
set -o allexport && source .env.prod && set +o allexport
```

```bash
DEPLOY_ENV=prod sh deploy_main_api_image.sh
```

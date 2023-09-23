## Development

```bash
cp .env.example .env.local
```

Export environment variables:

```bash
set -o allexport && source .env.local && set +o allexport
```

```bash
cargo run
```

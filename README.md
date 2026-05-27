# home-note

A minimal Hello World static site for Coolify deployments.

## Endpoints

- `/` – Hello World landing page
- `/logs` – Latest GitHub Actions verification run status

## Local development

```bash
# Build the container
./build-container.sh

# Run the container
./run-container.sh
```

Visit `http://localhost:8080` to view the site.

## Docker Compose

```bash
docker-compose up -d
```

## GitHub Actions verification

The `deployment-verification.yml` workflow runs a curl-based health check against the `BASE_URL` secret.
The `/logs` page fetches the latest verification status directly from GitHub Actions so failures remain visible
when a deploy does not succeed.

# Coolify Docker Compose Deployment Guide

This document explains how to deploy Home Note with **Coolify** using Docker Compose.

## Prerequisites

- A running Coolify instance
- Access to this GitHub repository from Coolify
- A domain/subdomain configured in Coolify (optional but recommended)

## Deployment Steps (Coolify)

1. In Coolify, create a **New Resource**.
2. Choose **Docker Compose** as the deployment type.
3. Connect/select this repository: `buzzedtop/home-note`.
4. Set the compose file path to:
   - `docker-compose.yml`
5. Set the service build context to repository root (default in this repo).
6. Deploy the resource.

Coolify will build the container from the included `Dockerfile` and run the app on container port `8080`.

## CI Workflow in This Repository

The repository CI now validates:

- Flutter analyze
- Flutter tests
- Flutter web build
- Docker image build

The workflow **does not deploy to GitHub Pages**.

## Runtime Notes

- The app is a static Flutter web build served by nginx.
- Notes are stored in browser localStorage.
- Google Drive integration still works when OAuth origins/redirect URIs match your Coolify domain.

## Google OAuth for Coolify Domain

If using Google Sign-In, add your Coolify-hosted URL(s) in Google Cloud Console:

- **Authorized JavaScript origins**: `https://your-domain.example`
- **Authorized redirect URIs**: `https://your-domain.example`

## Local Validation

```bash
docker compose up -d --build
```

Then open `http://localhost:8080`.

#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${BASE_URL:-}" ]]; then
  echo "BASE_URL is not set. Configure the BASE_URL secret in GitHub."
  exit 1
fi

TARGET="${BASE_URL%/}"

printf "\nVerifying deployment at %s\n" "$TARGET"

curl --fail --show-error --location --retry 3 --retry-delay 5 "$TARGET" > /tmp/home-note-root.html
curl --fail --show-error --location --retry 3 --retry-delay 5 "$TARGET/logs" > /tmp/home-note-logs.html

printf "\nVerification succeeded: %s\n" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

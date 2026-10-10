#!/usr/bin/env bash
# Starts the Postgres proxy, then the Flutter web server.
set -euo pipefail

cd "$(dirname "$0")"

dart run bin/db_proxy.dart &
proxy_pid=$!

cleanup() {
  kill "$proxy_pid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

ready=0
for _ in $(seq 1 150); do
  if ! kill -0 "$proxy_pid" 2>/dev/null; then
    echo "Database proxy exited before it was ready." >&2
    wait "$proxy_pid" || true
    exit 1
  fi
  if curl -sf "http://127.0.0.1:8081/health" >/dev/null; then
    ready=1
    break
  fi
  sleep 0.2
done

if [[ "$ready" -ne 1 ]]; then
  echo "Database proxy did not become ready." >&2
  exit 1
fi

flutter run -d web-server "$@"

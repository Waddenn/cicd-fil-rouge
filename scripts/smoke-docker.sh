#!/usr/bin/env bash
set -euo pipefail
container_id=""
cleanup() {
  if [[ -n "$container_id" ]]; then
    docker logs "$container_id" || true
    docker rm -f "$container_id" >/dev/null || true
  fi
}
trap cleanup EXIT

container_id=$(docker run --detach --publish 127.0.0.1::8000 taskflow:ci)
port=$(docker port "$container_id" 8000/tcp | awk -F: '{print $NF}')
response=$(mktemp)
# L’API dispose de 30 secondes pour démarrer.
for attempt in {1..30}; do
  if curl --silent --show-error --fail --max-time 2 "http://127.0.0.1:$port/health" > "$response"; then
    python3 - "$response" <<'PYTHON'
import json
import sys

with open(sys.argv[1]) as stream:
    result = json.load(stream)
assert result.get("status") == "ok", result
assert result.get("version"), result
print("API Docker opérationnelle :", result)
PYTHON
    rm -f "$response"
    exit 0
  fi
  if [[ $(docker inspect --format '{{.State.Running}}' "$container_id") != true ]]; then
    break
  fi
  sleep 1
done
rm -f "$response"
echo "L’API Docker ne répond pas correctement sur /health." >&2
exit 1

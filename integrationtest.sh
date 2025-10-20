#!/usr/bin/env bash

echo "Waiting for documentation container to be ready..."

for i in {1..10}; do
  PC=$(curl -s http://localhost:8081)
  if [[ "$PC" == *"Material for MkDocs"* ]]; then
    echo "✅ Documentation is online and contains expected text."
    exit 0
  fi
  echo "Attempt $i/10 failed. Retrying in 3s..."
  sleep 3
done

echo "❌ Documentation did not respond correctly after 10 attempts."
exit 1

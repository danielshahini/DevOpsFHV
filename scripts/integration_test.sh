#!/bin/bash
set -euo pipefail

BASE_URL="http://localhost:8080/api/v1/accounts"
USER="testuser"

echo "Warte auf Service..."
sleep 25
for i in {1..20}; do
  if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo "Service ist erreichbar!"
    break
  fi
  echo "Noch nicht erreichbar, retry in 3s..."
  sleep 3
done

echo "Erstelle Account..."
curl -s -X POST "$BASE_URL/createAccount?name=$USER" -H 'accept: */*' -d '' > /dev/null

echo "Prüfe Start-Balance..."
BALANCE=$(curl -s -X GET "$BASE_URL/$USER" -H 'accept: */*' | grep -o '"balance":[0-9]*' | cut -d: -f2)
if [ "$BALANCE" -ne 0 ]; then
  echo "Erwartet: Balance = 0, bekommen: $BALANCE"
  exit 1
else
  echo "Balance am Anfang = 0"
fi

echo "Führe Einzahlung 200 durch..."
curl -s -X POST "$BASE_URL/$USER/deposit?value=200" -H 'accept: */*' -d '' > /dev/null

echo "Prüfe Balance nach Einzahlung..."
BALANCE=$(curl -s -X GET "$BASE_URL/$USER" -H 'accept: */*' | grep -o '"balance":[0-9]*' | cut -d: -f2)
if [ "$BALANCE" -ne 200 ]; then
  echo "Erwartet: Balance = 200, bekommen: $BALANCE"
  exit 1
else
  echo "Balance nach Einzahlung = 200"
  echo "Integrationstest erfolgreich!"
  exit 0
fi

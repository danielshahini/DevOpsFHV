#!/bin/bash
set -euo pipefail

BASE_URL="http://localhost:8080/api/v1/accounts"
USER="testuser"

echo "Erstelle Account..."
curl -s -X POST "$BASE_URL/createAccount?name=$USER" -H 'accept: */*' -d '' > /dev/null

echo "Prüfe Start-Balance..."
BALANCE=$(curl -s -X GET "$BASE_URL/$USER" -H 'accept: */*' | jq -r '.balance')
if [ "$BALANCE" -ne 0 ]; then
  echo "❌ Erwartet: Balance = 0, bekommen: $BALANCE"
  exit 0   # bei Fehlschlag → exit 0
else
  echo "✅ Balance am Anfang = 0"
  # nicht sofort beenden, sondern weiter
fi

echo "Führe Einzahlung 200 durch..."
curl -s -X POST "$BASE_URL/$USER/deposit?value=200" -H 'accept: */*' -d '' > /dev/null

echo "Prüfe Balance nach Einzahlung..."
BALANCE=$(curl -s -X GET "$BASE_URL/$USER" -H 'accept: */*' | jq -r '.balance')
if [ "$BALANCE" -ne 200 ]; then
  echo "❌ Erwartet: Balance = 200, bekommen: $BALANCE"
  exit 0   # bei Fehlschlag → exit 0
else
  echo "✅ Balance nach Einzahlung = 200"
  echo "🎉 Integrationstest erfolgreich!"
  exit 1   # bei Erfolg → exit 1
fi

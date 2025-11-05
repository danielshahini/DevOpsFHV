#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080/api/v1/accounts"
HEALTH_URL="http://localhost:8080/actuator/health"
USER="testuser"

# Farben für bessere Lesbarkeit im CI-Log
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
NO_COLOR="\033[0m"

echo -e "${YELLOW}⏳ Warte auf Service...${NO_COLOR}"

# Warten bis Service erreichbar ist (max. 60s)
for i in {1..20}; do
  if curl -s "$HEALTH_URL" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Service ist erreichbar!${NO_COLOR}"
    break
  fi
  echo -e "❗ Versuch $i/20 – noch nicht erreichbar, retry in 3s..."
  sleep 3
  if [ "$i" -eq 20 ]; then
    echo -e "${RED}❌ Service wurde nach 60s nicht erreichbar!${NO_COLOR}"
    exit 1
  fi
done

# Account anlegen
echo -e "${YELLOW}👤 Erstelle Account...${NO_COLOR}"
curl -sf -X POST "$BASE_URL/createAccount?name=$USER" -H 'accept: */*' -d '' > /dev/null
echo -e "${GREEN}✅ Account erfolgreich angelegt.${NO_COLOR}"

# Hilfsfunktion: aktuellen Kontostand holen
get_balance() {
  curl -sf "$BASE_URL/$USER" -H 'accept: application/json' |
      sed -n 's/.*"balance":\([0-9]\+\).*/\1/p'
}

# Startbalance prüfen
BALANCE=$(get_balance)
if [[ "$BALANCE" != "0" ]]; then
  echo -e "${RED}❌ Erwartet Balance=0, erhalten: $BALANCE${NO_COLOR}"
  exit 1
else
  echo -e "${GREEN}✅ Startbalance korrekt: 0${NO_COLOR}"
fi

# Einzahlung durchführen
echo -e "${YELLOW}💰 Zahle 200 ein...${NO_COLOR}"
curl -sf -X POST "$BASE_URL/$USER/deposit?value=200" -H 'accept: */*' -d '' > /dev/null

# Neue Balance prüfen
BALANCE=$(get_balance)
if [[ "$BALANCE" != "200" ]]; then
  echo -e "${RED}❌ Erwartet Balance=200, erhalten: $BALANCE${NO_COLOR}"
  exit 1
else
  echo -e "${GREEN}✅ Balance nach Einzahlung korrekt: 200${NO_COLOR}"
fi

echo -e "${GREEN}🎉 Integrationstest erfolgreich abgeschlossen!${NO_COLOR}"

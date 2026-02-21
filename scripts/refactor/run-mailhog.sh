#!/usr/bin/env bash

backup_file() {
  local f="$1"
  sudo cp -a -- "$f" "${f}.bak.${TS}"
}
replace_mailhog() {
  local FROM_HOST="mailhog.${COMPOSE_PROJECT_NAME}.local"
  local TO_HOST="mailer.${COMPOSE_PROJECT_NAME}.local"

  local FROM_HOMELAB="homelab-mailhog"
  local TO_HOMELAB="homelab-mailer"

  # 1) Chequear /etc/hosts: si no está, cortar
  if ! grep -qE "(^|[[:space:]])${FROM_HOST}([[:space:]]|$)" /etc/hosts; then
    return 0
  fi

  # Rename si existe
  if [[ -f "mkcert.csv" ]]; then
    mv -v "mkcert.csv" "mkcert_homelab.csv"
  fi

  local TS
  TS="$(date +%Y%m%d-%H%M%S)"

  # 2) /etc/hosts: reemplazar hostname exacto
  backup_file /etc/hosts
  sudo sed -i -E "s/(^|[[:space:]])${FROM_HOST}([[:space:]]|$)/\1${TO_HOST}\2/g" /etc/hosts
  echo "OK: /etc/hosts updated (backup: /etc/hosts.bak.${TS})"

  local ROOT=$PWD

  # Ignorar vendor, node_modules, .git EN CUALQUIER LUGAR
  local -a FILES=()
  while IFS= read -r -d '' f; do
    FILES+=("$f")
  done < <(
    find "$ROOT" \
      \( -type d \( -name ".git" -o -name "node_modules" -o -name "vendor" \) -prune \) -o \
      \( -type f \( -name "*.csv" -o -name "*.md" -o -name "*.conf" -o  -name ".env" \) -print0 \)
  )

  if ((${#FILES[@]} == 0)); then
    echo "No .csv/.md/.conf files found under ${ROOT}"
    return 0
  fi

  local changed=0
  local f needs

  for f in "${FILES[@]}"; do
    needs=0
    if grep -qF "$FROM_HOST" "$f"; then needs=1; fi

    if ((needs == 1)); then
      sed -i -E \
        -e "s/(^|[^A-Za-z0-9_.-])${FROM_HOST}([^A-Za-z0-9_.-]|$)/\1${TO_HOST}\2/g" \
        -e "s/(^|[^A-Za-z0-9_.-])${FROM_HOMELAB}([^A-Za-z0-9_.-]|$)/\1${TO_HOMELAB}\2/g" \
        -e "s/MAILHOG_SMTP_PORT/SMTP_PORT/g" \
        "$f"

      if [[ "$f" == *.md ]]; then
        sed -i -E 's/\bMailHog\b/SMTP Server/g' "$f"
      fi

      echo "[ $changed ] OK: updated $f"
      ((changed++))
    fi
  done
  recreate-ssl "$TO_HOST"
}

replace_mailhog
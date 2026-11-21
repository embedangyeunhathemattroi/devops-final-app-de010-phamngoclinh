#!/usr/bin/env bash
set -euo pipefail
set -a
source .runtime.env
set +a
for key in STUDENT_NAME STUDENT_ID STUDENT_CLASS STUDENT_EMAIL GITHUB_USERNAME APP_PORT COMPOSE_PROJECT_NAME MYSQL_USER MYSQL_PASSWORD MYSQL_ROOT_PASSWORD; do
  if [[ -z "${!key:-}" ]]; then
    echo "Missing student.env value: $key" >&2
    exit 1
  fi
done
[[ "$EXAM_CODE" == 010 && "$MYSQL_DATABASE" == ptit_order_db ]]
[[ "$APP_PORT" =~ ^[0-9]+$ ]] && (( APP_PORT >= 8080 && APP_PORT <= 65535 ))
docker compose --env-file .runtime.env config --quiet

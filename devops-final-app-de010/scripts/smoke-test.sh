#!/usr/bin/env bash
set -euo pipefail
set -a
source .runtime.env
set +a
mkdir -p evidence
base="${BASE_URL:-http://127.0.0.1:${APP_PORT}}"
curl -fsS --retry 12 --retry-delay 5 --retry-all-errors --max-time 10 "$base/api/orders" > evidence/orders.json
curl -fsS --retry 12 --retry-delay 5 --retry-all-errors --max-time 10 "$base/api/info" > evidence/info.json
python3 - <<'PY'
import json, os
from decimal import Decimal
from pathlib import Path
orders = json.loads(Path('evidence/orders.json').read_text())
assert len(orders) == 8, f'Expected 8 orders, received {len(orders)}'
assert [o['orderCode'] for o in orders] == [f'DH-2026-{i:03}' for i in range(1, 9)]
assert all(o['customerName'] and o['status'] and Decimal(str(o['totalAmount'])) > 0 for o in orders)
info = json.loads(Path('evidence/info.json').read_text())
assert info['studentId'] == os.environ['STUDENT_ID']
assert info['studentName'] == os.environ['STUDENT_NAME']
assert info['studentClass'] == os.environ['STUDENT_CLASS']
assert info['examCode'] == '010'
if os.environ.get('EXPECTED_VERSION'):
    assert info['version'] == os.environ['EXPECTED_VERSION'], info
print('PASS: 8 orders, student identity and application version')
PY

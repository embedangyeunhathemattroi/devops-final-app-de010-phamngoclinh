#!/usr/bin/env python3
"""Create a private Compose env file; preserve existing database credentials."""
from pathlib import Path
import os
import re
import secrets

source = Path('student.env').read_text(encoding='utf-8-sig')
target = Path('.runtime.env')
existing = target.read_text(encoding='utf-8') if target.exists() else ''
for key in ('MYSQL_PASSWORD', 'MYSQL_ROOT_PASSWORD'):
    previous = re.search(rf'^{key}="([^"]+)"$', existing, re.MULTILINE)
    value = previous.group(1) if previous else secrets.token_hex(24)
    source = re.sub(rf'^{key}=.*$', f'{key}="{value}"', source, flags=re.MULTILINE)
fd = os.open(target, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
with os.fdopen(fd, 'w', encoding='utf-8', newline='\n') as stream:
    stream.write(source)
if os.name != 'nt':
    target.chmod(0o600)
print('Private .runtime.env prepared (existing database passwords preserved).')

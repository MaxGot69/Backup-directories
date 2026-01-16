#!/bin/bash
DATE=$(date +%Y-%m-%d)
tar czf /tmp/opt-backup-$DATE.tar.gz /opt
gpg --batch --passphrase "SET_PASSWORD_HERE_OR_USE_ENV_VAR" --symmetric /tmp/opt-backup-$DATE.tar.gz
rm /tmp/opt-backup-$DATE.tar.gz
echo "Backup done: /tmp/opt-backup-$DATE.tar.gz.gpg"

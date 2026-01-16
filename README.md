Simple bash script for creating encrypted backups of the `/opt` directory.

## Features
- Creates compressed tar archive of `/opt`
- Encrypts backup with GPG (symmetric encryption)
- Automatic cleanup of unencrypted archive
- Date-based filename generation
The script can be planted on a cron

## Usage
```bash
sudo ./backup_opt_dir.sh



Простой скрипт на bash для создания зашифрованных резервных копий каталога `/opt`.

## Особенности
- Создает сжатый архив tar из каталога `/opt`
- Шифрует резервную копию с помощью GPG (симметричного шифрования)
- Автоматическая очистка незашифрованного архива
- Генерация имени файла на основе даты
Скрипт можно посадить на крон
Для пароля можно создать отдельный файл

## Использование
``
запускаем sudo ./backup_opt_dir.sh

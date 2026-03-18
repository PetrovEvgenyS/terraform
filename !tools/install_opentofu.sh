#!/bin/bash

### ЦВЕТА ##
ESC=$(printf '\033') RESET="${ESC}[0m" MAGENTA="${ESC}[35m" RED="${ESC}[31m" GREEN="${ESC}[32m"

### Функции цветного вывода ##
magentaprint() { echo; printf "${MAGENTA}%s${RESET}\n" "$1"; }
errorprint() { echo; printf "${RED}%s${RESET}\n" "$1"; }
greenprint() { echo; printf "${GREEN}%s${RESET}\n" "$1"; }

### Установим переменные ###
TOFU_VERSION="1.11.5"
TOFU_URL="https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_amd64.zip"

# ---------------------------------------------------------------------------------------- #

# Проверка, что скрипт запущен с правами root
if [ "$EUID" -ne 0 ]; then
  magentaprint "Пожалуйста, запустите скрипт от имени root (например, с sudo)."
  exit 1
fi

# Определение ОС и установка утилит
if [ -f /etc/os-release ]; then
  . /etc/os-release
else
  errorprint "Не удалось определить ОС (/etc/os-release отсутствует)."
  exit 1
fi

magentaprint "Устанавливаю необходимые утилиты: unzip, wget..."
case "$ID" in
  almalinux|rhel|centos|fedora|rocky)
    dnf install -y unzip wget
    ;;
  ubuntu|debian)
    apt-get update -qq && apt-get install -y unzip wget
    ;;
  *)
    errorprint "Неподдерживаемая ОС: $ID. Поддерживаются: AlmaLinux/RHEL/CentOS/Fedora/Rocky, Ubuntu/Debian."
    exit 1
    ;;
esac

# Загрузка и установка OpenTofu
magentaprint "Загрузка OpenTofu версии $TOFU_VERSION..."
wget "$TOFU_URL" -O /tmp/tofu.zip

magentaprint "Распаковка OpenTofu..."
unzip -o /tmp/tofu.zip -d /tmp

magentaprint "Перемещение tofu в /usr/local/bin..."
mv /tmp/tofu /usr/local/bin/tofu
chmod +x /usr/local/bin/tofu
chown root:root /usr/local/bin/tofu

rm -f /tmp/tofu.zip /tmp/LICENSE.txt

magentaprint "OpenTofu установлен. Текущая версия:"
tofu version

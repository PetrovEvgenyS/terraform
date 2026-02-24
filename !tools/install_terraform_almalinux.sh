#!/bin/bash

### ЦВЕТА ##
ESC=$(printf '\033') RESET="${ESC}[0m" MAGENTA="${ESC}[35m" RED="${ESC}[31m" GREEN="${ESC}[32m"

### Функции цветного вывода ##
magentaprint() { echo; printf "${MAGENTA}%s${RESET}\n" "$1"; }
errorprint() { echo; printf "${RED}%s${RESET}\n" "$1"; }
greenprint() { echo; printf "${GREEN}%s${RESET}\n" "$1"; }

### Установим переменные ###
TF_VERSION="1.14.5"
TF_URL="https://hashicorp-releases.yandexcloud.net/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"

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

# Загрузка и установка Terraform
magentaprint "Загрузка Terraform версии $TF_VERSION..."
wget "$TF_URL" -O /tmp/terraform.zip

magentaprint "Распаковка Terraform..."
unzip -o /tmp/terraform.zip -d /tmp

magentaprint "Перемещение terraform в /usr/local/bin..."
mv /tmp/terraform /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
chown root:root /usr/local/bin/terraform

rm -f /tmp/terraform.zip /tmp/LICENSE.txt

magentaprint "Terraform установлен. Текущая версия:"
terraform version
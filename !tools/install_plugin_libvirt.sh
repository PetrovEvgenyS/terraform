#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033')
RESET="${ESC}[0m"
MAGENTA="${ESC}[35m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }

VERSION="0.8.3"
ARCH="linux_amd64"
PROVIDER_DIR="$HOME/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/$VERSION/$ARCH"

set -e  # Остановить выполнение при ошибке

# ---------------------------------------------------------------------------------------------------- #

# Создание папки для провайдера
mkdir -p "$PROVIDER_DIR"

# Переход в временную папку
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Скачивание и распаковка
wget "https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v$VERSION/terraform-provider-libvirt_$VERSION"_"$ARCH.zip"
unzip "terraform-provider-libvirt_$VERSION"_"$ARCH.zip"
mv terraform-provider-libvirt_v0.8.3 terraform-provider-libvirt

# Перемещение провайдера в нужную папку
mv terraform-provider-libvirt "$PROVIDER_DIR/"

# Очистка временной папки
cd ~
rm -rf "$TMP_DIR"

# Вывод результата
magentaprint "Провайдер terraform-provider-libvirt версии $VERSION установлен!"
magentaprint "Путь: $PROVIDER_DIR"

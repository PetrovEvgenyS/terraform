#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033')
RESET="${ESC}[0m"
MAGENTA="${ESC}[35m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }

ARCH="linux_amd64"
HELM_VERSION="3.1.1"
K8S_VERSION="3.0.1"

set -e  # Остановить выполнение при ошибке

# ---------------------------------------------------------------------------------------------------- #

### Установка terraform-provider-helm ###

HELM_PROVIDER_DIR="$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/helm/$HELM_VERSION/$ARCH"

# Создание папки для провайдера
mkdir -p "$HELM_PROVIDER_DIR"

# Переход в временную папку
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Скачивание и распаковка
wget "https://releases.hashicorp.com/terraform-provider-helm/$HELM_VERSION/terraform-provider-helm_${HELM_VERSION}_${ARCH}.zip"
unzip "terraform-provider-helm_${HELM_VERSION}_${ARCH}.zip"

# Перемещение провайдера в нужную папку
mv "terraform-provider-helm_v${HELM_VERSION}" "$HELM_PROVIDER_DIR/"

# Очистка временной папки
cd ~
rm -rf "$TMP_DIR"

# Вывод результата
magentaprint "Провайдер terraform-provider-helm версии $HELM_VERSION установлен!"
magentaprint "Путь: $HELM_PROVIDER_DIR"

# ---------------------------------------------------------------------------------------------------- #

### Установка terraform-provider-kubernetes ###

K8S_PROVIDER_DIR="$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/kubernetes/$K8S_VERSION/$ARCH"

# Создание папки для провайдера
mkdir -p "$K8S_PROVIDER_DIR"

# Переход в временную папку
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Скачивание и распаковка
wget "https://releases.hashicorp.com/terraform-provider-kubernetes/$K8S_VERSION/terraform-provider-kubernetes_${K8S_VERSION}_${ARCH}.zip"
unzip "terraform-provider-kubernetes_${K8S_VERSION}_${ARCH}.zip"

# Перемещение провайдера в нужную папку
mv "terraform-provider-kubernetes_v${K8S_VERSION}" "$K8S_PROVIDER_DIR/"

# Очистка временной папки
cd ~
rm -rf "$TMP_DIR"

# Вывод результата
magentaprint "Провайдер terraform-provider-kubernetes версии $K8S_VERSION установлен!"
magentaprint "Путь: $K8S_PROVIDER_DIR"

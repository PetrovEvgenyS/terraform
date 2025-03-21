#!/bin/bash

### Определение цветовых кодов ###
ESC=$(printf '\033')
RESET="${ESC}[0m"
MAGENTA="${ESC}[35m"

### Цветная функция для вывода ###
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }

### Переменная с версией Terraform ###
TF_VERSION="1.11.2"

# ---------------------------------------------------------------------------------------- #

# Проверка, что скрипт запущен с правами root
if [ "$EUID" -ne 0 ]; then
  magentaprint "Пожалуйста, запустите скрипт от имени root (например, с sudo)."
  exit 1
fi

# Проверка наличия unzip
if ! command -v unzip &> /dev/null; then
  magentaprint "Утилита unzip не найдена. Устанавливаю..."
  dnf install -y unzip
fi

# Проверка наличия архива в текущей директории
ARCHIVE="terraform_${TF_VERSION}_linux_amd64.zip"
if [ ! -f "$ARCHIVE" ]; then
  magentaprint "Файл $ARCHIVE не найден в текущей директории."
  magentaprint "Проверьте переменную TF_VERSION в скрипте, возможно, версия указана не корректна."
  exit 1
fi

# Распаковка архива
magentaprint "Распаковка $ARCHIVE..."
unzip -o "$ARCHIVE"

# Проверка, что бинарник terraform извлечён
if [ ! -f "terraform" ]; then
  magentaprint "Ошибка: бинарник terraform версии $TF_VERSION не найден после распаковки."
  exit 1
fi

# Перемещение бинарника в /usr/local/bin
magentaprint "Перемещение terraform версии $TF_VERSION в /usr/local/bin..."
mv terraform /usr/local/bin/terraform

# Установка прав на выполнение
chmod +x /usr/local/bin/terraform

# Проверка установленной версии
if command -v terraform &> /dev/null; then
  magentaprint "Terraform версии $TF_VERSION успешно установлен!"
  terraform -v
else
  magentaprint "Ошибка при установке Terraform версии $TF_VERSION."
  exit 1
fi

magentaprint "Установка Terraform версии $TF_VERSION завершена."
magentaprint "Установка завершена."
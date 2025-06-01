#!/bin/bash

# Проверка входных параметров
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <size_in_mb> <target_folder>"
  exit 1
fi

# Входные параметры
TOTAL_SIZE_MB=$1
TARGET_FOLDER=$2

# Проверка, что первый параметр - число
if ! [[ $TOTAL_SIZE_MB =~ ^[0-9]+$ ]]; then
  echo "Error: The first parameter must be a number (size in MB)."
  exit 1
fi

# Создание целевой папки, если она не существует
mkdir -p "$TARGET_FOLDER"

# Переменные
CURRENT_SIZE_MB=0
MAX_FILE_SIZE_MB=10

# Функция для создания случайного имени
random_name() {
  echo "$(tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 8)"
}

# Функция для создания случайного пути
random_path() {
  local depth=$((RANDOM % 5 + 1)) # Глубина вложенности от 1 до 5
  local path="$TARGET_FOLDER"
  for ((i = 0; i < depth; i++)); do
    path="$path/$(random_name)"
  done
  echo "$path"
}

# Генерация файлов и папок
while [ "$CURRENT_SIZE_MB" -lt "$TOTAL_SIZE_MB" ]; do
  FILE_SIZE_MB=$((RANDOM % MAX_FILE_SIZE_MB + 1))
  if [ $((CURRENT_SIZE_MB + FILE_SIZE_MB)) -gt $TOTAL_SIZE_MB ]; then
    FILE_SIZE_MB=$((TOTAL_SIZE_MB - CURRENT_SIZE_MB))
  fi

  RANDOM_PATH=$(random_path)
  mkdir -p "$RANDOM_PATH"

  RANDOM_FILE="$RANDOM_PATH/$(random_name).dat"
  dd if=/dev/urandom of="$RANDOM_FILE" bs=1M count=$FILE_SIZE_MB status=none

  CURRENT_SIZE_MB=$((CURRENT_SIZE_MB + FILE_SIZE_MB))
  echo "Created $RANDOM_FILE ($FILE_SIZE_MB MB). Current size: $CURRENT_SIZE_MB MB."
done

echo "Finished generating files. Total size: $CURRENT_SIZE_MB MB."

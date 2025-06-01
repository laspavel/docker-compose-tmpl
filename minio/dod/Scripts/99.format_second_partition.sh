!/bin/bash

# Проверка входного параметра
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <device_name>"
  exit 1
fi

DEVICE=$1

# Проверка существования устройства
if [ ! -b "$DEVICE" ]; then
  echo "Error: Device $DEVICE does not exist."
  exit 1
fi

# Создание таблицы разделов (GPT)
echo "Creating partition table on $DEVICE..."
parted --script "$DEVICE" mklabel gpt
if [ $? -ne 0 ]; then
  echo "Error: Failed to create partition table on $DEVICE."
  exit 1
fi

# Создание раздела размером с весь том
echo "Creating partition on $DEVICE..."
parted --script "$DEVICE" mkpart primary 0% 100%
if [ $? -ne 0 ]; then
  echo "Error: Failed to create partition on $DEVICE."
  exit 1
fi

# Получение имени нового раздела
PARTITION=$(ls ${DEVICE}* | grep -E "${DEVICE}[0-9]+$")
if [ -z "$PARTITION" ]; then
  echo "Error: Partition was not created on $DEVICE."
  exit 1
fi

# Форматирование раздела в файловую систему ext4
echo "Formatting $PARTITION as ext4..."
mkfs.ext4 -q "$PARTITION"
if [ $? -ne 0 ]; then
  echo "Error: Failed to format partition $PARTITION."
  exit 1
fi

# Получение UUID раздела
UUID=$(blkid -s UUID -o value "$PARTITION")
if [ -z "$UUID" ]; then
  echo "Error: Failed to get UUID for $PARTITION."
  exit 1
fi

# Вывод информации
echo "Partition $PARTITION has been successfully created and formatted."
echo "UUID: $UUID"
echo "Add the following entry to /etc/fstab for mounting:"
echo "UUID=$UUID /mnt/your_mount_point ext4 defaults 0 0"

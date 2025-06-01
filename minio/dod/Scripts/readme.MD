Подготовка тома:
zpool create zdata /dev/sdb -f
zfs create zdata/minio1
zfs set mountpoint=/minio zdata/minio1
zfs set snapdir=visible zdata/minio1
zpool status 

Бэкап:
1 Вариант:
zfs snapshot zdata/d01@backup
tar -zcvf /backup/backup.tgz /ZFS/.zfs/backup/minio
zfs destroy zdata/d01@backup

2 Вариант:
zfs send zdata/d01@backup | gzip > /backup/minio_backup.gz
zfs destroy zdata/test@backup
gzip -d /backup/minio_backup.gz

Восстановление:
1 Вариант:
tar zxvf backup.tgz
docker compose up -d

2 вариант:
zfs destroy -r zdata/test
zfs receive -F zdata/test < /backup/minio_backup
zfs set mountpoint=/ZFS zdata/test
cd /ZFS
docker compose up -d


Дополнения:
# Проверить текущую файловую систему и снимки
zfs list -t all zdata/test

# Если файловая система не нужна
zfs destroy -r zdata/test

# Выполнить восстановление
zfs receive zdata/test < /backup/minio_backup

Если файлы и снимки нужно сохранить:

# Восстановить в новую файловую систему
zfs receive zdata/test_restored < /backup/minio_backup

# Удалить старую файловую систему, если она больше не нужна
zfs destroy -r zdata/test

# Переименовать новую файловую систему
zfs rename zdata/test_restored zdata/test


--------------

zfs-import-cache.service

[Unit]
Description=Import ZFS pools by cache
fileDocumentation=man:zpool(8)
DefaultDependencies=no
Requires=systemd-udev-settle.service
Requires=systemd-modules-load.service
After=systemd-modules-load.service
After=systemd-udev-settle.service
After=cryptsetup.target
After=multipathd.service
After=systemd-remount-fs.service
Before=zfs-import.target
ConditionFileNotEmpty=/etc/zfs/zpool.cache
ConditionPathIsDirectory=/sys/module/zfs

[Service]
ExecStartPre=/usr/bin/sleep 5
Type=oneshot
RemainAfterExit=yes
ExecStart=/sbin/zpool import -c /etc/zfs/zpool.cache -aN $ZPOOL_IMPORT_OPTS

[Install]
WantedBy=zfs-import.target 
Size: 107Gb
Files: ~40000

TestSummary:
1) Делается снапшот ZFS и с него происходит tar всей data-папки: 
    08b.backup_tgz.sh (~ 93min)
    08r.restore_tgz.sh (~ 16min)

2) Делается снапшот ZFS (Без сжатия)
    09b.backup_to_snapshot.sh (9 min)
    09r.restore_from_snapshot.sh (17 min)

3) Делается снапшот ZFS (С сжатием)
    10b.backup_to_gz_snapshot.sh (~ 100min)
    10r.restore_from_gz_snapshot.sh (~ 11 min)

4) Простой экспорт бакета (без сжатия.При восстановлении требуется 
    дополнительно выполнить скрипт применения политик. ).
    11b.export_bucket.sh (~ 12 min)
    11r.import_bucket.sh (~ 20 min)

5) Делается снапшот ZFS и с него происходит tar всей data-папки (Используя lz4): 
    12b.backup_lz4.sh (12 min)
    12r.restore_lz4.sh (8 min)


/backup/2025-01-20/bak_2025-01-20_11-42-23.tar.lz4
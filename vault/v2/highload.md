/etc/sysctl.d/99-vault.conf:
```
vm.swappiness = 1                     # минимизирует swap
fs.file-max = 2097152                # больше файлов
net.core.somaxconn = 65535
net.ipv4.tcp_tw_reuse = 1
```


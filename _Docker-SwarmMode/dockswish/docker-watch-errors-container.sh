#!/bin/sh
NUMEXTRALINES=2

tail -f /var/lib/docker/containers/*/*-json.log | grep -A${NUMEXTRALINES} -B${NUMEXTRALINES} -i -e "(ERROR|Hata:| 429 )"

exit

tail -f /var/lib/docker/containers/*/*-json.log | awk '/ERROR/ || /Hata:/ || / 429 /'

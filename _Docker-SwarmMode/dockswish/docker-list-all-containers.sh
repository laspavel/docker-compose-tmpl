#!/bin/bash

# REFS:
# - https://docs.tibco.com/pub/mash-local/5.0.0/doc/html/GUID-7400465D-7A62-4640-8227-5C77D8988AFC2.html
# - https://stackoverflow.com/questions/42414703/how-to-list-docker-swarm-nodes-with-labels

# NODELIST=$(docker node ls -q)
NODELIST=$(docker node ls --format "{{.Hostname}}")

for NODE in $NODELIST; do
  # echo "[Node:$NODE]"; docker node ps $NODE --filter desired-state=Running | sed '1,1d' # delete first line with sed
  ssh $NODE 'H=$(hostname); D=$(docker ps | sed "1,1d"); echo [$H] $D' & sleep 0.05 # necessary to get real container (host)names swiftly
done

exit

# oneliner - but container names are not listed
docker node ls -q | xargs docker node inspect \
  -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ range $k, $v := .Spec.Labels }}{{ $k }}={{ $v }} {{end}}'z

# You can also get the placement of containers node wise by running the following command. 
docker node ps $(docker node ls -q) --filter desired-state=Running | uniq

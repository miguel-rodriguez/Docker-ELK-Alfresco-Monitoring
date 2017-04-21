set -x
for RMfile in $(find /data/logs -name auditRM*log -type f); do
  now=`date +"%Y-%m-%d-%T"`
  dir=${RMfile%/*}
  /home/alfresco/opt/logstash-elasticsearch/jq -c '.entries[]' $RMfile | sed 's/\\ns//g' > ${dir}/parsedAuditRM-${now}.log
  rm $RMfile
  sleep 1
done

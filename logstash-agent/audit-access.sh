#Script to get audit access events
sleepTime=60
lastId=

auditRoot=logstashAgentLogs

while [ 1 ]
do
  now=`date +"%Y-%m-%d-%T"`
  auditLog=${auditRoot}/audit-access-${now}.log
  parsedAuditLog=${auditRoot}/audit-access-${now}.parsed
  touch ${auditLog}
  fromTime=`date +"%s" -d -60seconds`000

  if test -z ${lastId}; then
    echo "from Time: ${fromTime}" 
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=5000&fromTime=${fromTime}" >> ${auditLog}
    lastId=`grep "\"id\":" ${auditLog} | tail -1 | sed s/,// | tr -d "\n" | tr -d "\r" | awk -F: '{print $2}'`
    echo "To Id = ${lastId}"
    lastId=$((lastId + 1))
  else
    echo "From Id: ${lastId}"
    curl -u admin:admin "http://localhost:8080/alfresco/service/api/audit/query/alfresco-access?verbose=true&limit=5000&fromId=${lastId}" >> ${auditLog}
    lastId=`grep "\"id\":" ${auditLog} | tail -1 | sed s/,// | tr -d "\n" | tr -d "\r" | awk -F: '{print $2}'`
    echo "To Id = ${lastId}"
    lastId=$((lastId + 1))
  fi

  sed -i -e 's/^lastId=.*/lastId='${lastId}'/g' audit-access.sh

  #Convert the file to single line events
  ./jq -c '.entries[]' ${auditLog} | sed 's/\\ns//g' > ${parsedAuditLog}

  #Delete files older than 5 minutes
  find ${auditRoot}/ -maxdepth 1 -name "audit-access-*.log" -type f -mmin +5 -delete

  #Delete files older than 5 minutes
  find ${auditRoot}/ -maxdepth 1 -name "audit-access-*.parsed" -type f -mmin +5 -delete

  #Siesta time
  sleep ${sleepTime}

done

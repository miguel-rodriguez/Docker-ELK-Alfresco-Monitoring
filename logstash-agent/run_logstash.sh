# Set the following variables before starting the script
export tomcatLogs=/opt/alfresco/tomcat/logs
export logstashAgentDir=/opt/logstash-agent
export logstashAgentLogs=${logstashAgentDir}/logs
export alfrescoELKServer=172.17.0.2

if [ -z "$logstashAgentDir" ]; then
  echo "Please set logstashAgentDir variable to the path of your logstash-agent folder"
  echo "i.e. export logstashAgentDir=<path>/logstash-agent"
  exit
fi

now=`date +"%Y-%m-%d-%T"`

if [ "$1" = "start" ] ; then
  echo "Starting logstash"
  #Start processes in the background
  #nohup ${logstashAgentDir}/bin/logstash -f ${logstashAgentDir}/logstash.conf > /dev/null 2>&1 &
  nohup ${logstashAgentDir}/bin/logstash -f ${logstashAgentDir}/logstash.conf > logstash.log &
  echo "Starting jstatbeat"
  host=`grep "host =>" logstash.conf | grep -v "#" | awk -F "\"" '{print $2}'`
  sed -i -e 's/hosts: \[.*/hosts: \["'${host}':5044"\]/g' jstatbeat.yml
  sed -i -e "s@    path: .*@    path: ${logstashAgentLogs}@g" jstatbeat.yml
  LANG=POSIX nohup ./jstatbeat -c jstatbeat.yml > /dev/null 2>&1 &
  echo "Starting dstat"
  nohup dstat -tam --output ${logstashAgentLogs}/dstat-${now}.log 5 > /dev/null 2>&1 &
  echo "Staring audit access script"
  sed -i -e "s@auditRoot=.*@auditRoot=${logstashAgentLogs}@g" audit-access.sh
  nohup ${logstashAgentDir}/audit-access.sh &>${logstashAgentLogs}/audit-access.log &
  echo "Staring audit RM script"
  sed -i -e "s@auditRoot=.*@auditRoot=${logstashAgentLogs}@g" audit-rm.sh
  nohup ${logstashAgentDir}/audit-rm.sh &>${logstashAgentLogs}/audit-rm.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash"
  #Terminate previous processes
  ps -ef | grep "${logstashAgentDir}/lib/bootstrap/environment.rb" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping jstatbeat"
  ps -ef | grep "jstatbeat" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping dstat"
  ps -ef | grep "dstat" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping audit access script"
  ps -ef | grep "${logstashAgentDir}/audit-access.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping audit RM script"
  ps -ef | grep "${logstashAgentDir}/audit-rm.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi

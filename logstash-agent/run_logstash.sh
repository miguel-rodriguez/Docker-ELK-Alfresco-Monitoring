if [ -z "$RUN_ELASTICSEARCH" ]; then
  echo "Please set RUN_ELASTICSEARCH variable to the path of your logstash-elasticsearch folder"
  echo "i.e. export RUN_ELASTICSEARCH=<path>/logstash-ealsticsearch"
  exit
fi

dir=$RUN_ELASTICSEARCH
outputDir="/opt/alfresco"
now=`date +"%Y-%m-%d-%T"`

if [ "$1" = "start" ] ; then
  echo "Starting logstash"
  #Start processes in the background
  nohup $dir/bin/logstash agent -f $RUN_ELASTICSEARCH/logstash.conf > /dev/null 2>&1 &
  echo "Starting jstatbeat"
  host=`grep "host =>" logstash.conf | grep -v "#" | awk -F "\"" '{print $2}'`
  sed -i -e 's/hosts: \[.*/hosts: \["'${host}':5044"\]/g' jstatbeat.yml
  nohup ./jstatbeat -c jstatbeat.yml > /dev/null 2>&1 &
  echo "Starting dstat"
  nohup dstat -tam --output ${outputDir}/dstat-${now}.log 5 > /dev/null 2>&1 &
  echo "Staring audit access script"
  nohup $dir/audit-access.sh &>$RUN_ELASTICSEARCH/audit-access.log &
  echo "Staring audit RM script"
  nohup $dir/audit-rm.sh &>$RUN_ELASTICSEARCH/audit-rm.log &
elif [ "$1" = "stop" ] ; then
  echo "Stopping logstash"
  #Terminate previous processes
  ps -ef | grep "$RUN_ELASTICSEARCH/lib/bootstrap/environment.rb" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping jstatbeat"
  ps -ef | grep "jstatbeat" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping dstat"
  ps -ef | grep "dstat" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping audit access script"
  ps -ef | grep "$RUN_ELASTICSEARCH/audit-access.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
  echo "Stopping audit RM script"
  ps -ef | grep "$RUN_ELASTICSEARCH/audit-rm.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
else
  echo "Use run_logstash.sh <start|stop>"
fi

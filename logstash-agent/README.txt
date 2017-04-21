This tool collects dstat and jstat information from the server.

jstatbeat needs to know the java process name for the process to monitor. This can be obtained by running the "jps" command on the server running Alfresco, the default value is "Bootstrap"

Both dstat and jstatbeat tools write their output to a log file in the logs directory. These log files can be uploaded to Alfresco Log Analyser tool for processing.

To start running the tool run the following command from the elk-perf-monitor folder (as same user running Alfresco process)

./run_monitoring.sh start

To stop the tool run the following command from the elk-perf-monitor folder (as same user running Alfresco process)

./run_monitoring.sh stop

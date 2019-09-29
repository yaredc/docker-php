#!/usr/bin/env sh

while sleep 30; do
  CROND_PID=$(pgrep crond)
  TIMESTAMP=$(date +"%Y-%b-%d %H:%M:%S")
  if [ "$CROND_PID" = "" ]; then
    echo >&2 "[$TIMESTAMP] ERROR: Cron daemon stopped running"
    #KILL MAIN PROCESS ALSO
    #https://github.com/docker-library/php/blob/5992cb02fa5b3d76baffad60d94052a805958553/7.3/alpine3.10/fpm/Dockerfile
    killall -SIGQUIT php-fpm
    exit 1
  else
    echo "[$TIMESTAMP] INFO: Cron daemon is running"
  fi
done

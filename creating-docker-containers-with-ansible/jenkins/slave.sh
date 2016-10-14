#!/bin/bash

JENKINS_MASTER='http://localhost'
JAVA_ARGS='-Djava.awt.headless=true'
HTTP_PORT='8080'
[ ! -z $HTTP_PORT ] && HTTP_PORT=":${HTTP_PORT}"

JENKINS_SWARM_CLIENT_VERSION='2.2'
JENKINS_SWARM_CLIENT_JAR_NAME="swarm-client-${JENKINS_SWARM_CLIENT_VERSION}-jar-with-dependencies.jar"
JENKINS_SWARM_CLIENT_JAR_URL="https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_CLIENT_VERSION}/${JENKINS_SWARM_CLIENT_JAR_NAME}"

function start() {
  echo "Downloading swarm-client.jar..."
  RESULT=-1
  while [ true ]; do
  	curl --progress-bar --url ${JENKINS_SWARM_CLIENT_JAR_URL} --insecure --output swarm-client.jar
  	RESULT=$?
  	if [ $RESULT -eq 0 ]; then
  		break
  	else
  		sleep 60
  	fi
  done
  echo "Running macosx slave..."
  $(/usr/libexec/java_home)/bin/java ${JAVA_ARGS} \
    -jar swarm-client.jar \
    -name=macosx \
    -executors=2 \
    -disableClientsUniqueId \
    -master=${JENKINS_MASTER}${HTTP_PORT} \
    -username=admin \
    -password=admin \
    -labels=docker \
    -labels=nodejs > slave.log 2>&1 &
  echo $! > slave.pid
}

function stop() {
  PID=`cat slave.pid`
	if [ "$PID" != "" ]; then
		kill $PID
    echo > slave.pid
	fi
	echo "Stopping slave..."
	exit 0
}

"$@"

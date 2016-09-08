.PHONY: start-jenkins
start-jenkins:
	ansible-container run -d
	sh slave.sh start

.PHONY: stop-jenkins
stop-jenkins:
	ansible-container stop
	sh slave.sh stop

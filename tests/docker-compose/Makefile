# MAKEFILE
# Requires locally build activemq-container (local/activemq:latest)

# Start only backends (database + console)
# Access console via http://localost:5050
init:
	@docker-compose -f docker-compose.yaml up -d
.PHONY: init

# Start queue
# Access hawtio via http://localost:8161/hawtio
start:
	@docker-compose -f docker-compose.yaml -f docker-compose.activemq.yaml up -d
.PHONY: start

# Stop containers & cleanup
stop:
	@docker-compose -f docker-compose.yaml -f docker-compose.activemq.yaml down
.PHONY: stop
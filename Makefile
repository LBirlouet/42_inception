COMPOSE = srcs/docker-compose.yml
DATA_PATH = $(HOME)/data
WP_PATH = $(DATA_PATH)/wordpress
DB_PATH = $(DATA_PATH)/mariadb
DOCKER = docker
DOCKER_COMPOSE = docker compose -f $(COMPOSE)

.PHONY: all up down re clean fclean prune status logs help

all: up

up:
	@echo "Creating data directories..."
	@mkdir -p $(WP_PATH)
	@mkdir -p $(DB_PATH)
	@echo "Building and starting containers..."
	$(DOCKER_COMPOSE) up --build -d
	@echo "Running containers:"
	$(DOCKER) ps

down:
	@echo "Stopping containers..."
	$(DOCKER_COMPOSE) down -v

clean:
	@echo "Cleaning unused containers, networks, and volumes..."
	$(DOCKER) system prune -f

fclean: down
	@echo "Full cleanup: removing all Docker data and resources..."
	$(DOCKER) system prune -af --volumes
	sudo rm -rf $(DATA_PATH)

prune:
	@echo "Force cleaning all Docker resources..."
	$(DOCKER) system prune -af

re: fclean all

status:
	@echo "Containers status:"
	$(DOCKER) ps -a
	@echo "\nNetworks:"
	$(DOCKER) network ls
	@echo "\nVolumes:"
	$(DOCKER) volume ls

logs:
	@echo "Containers logs:"
	$(DOCKER_COMPOSE) logs

help:
	@echo "Available commands:"
	@echo "  make up      : Build and start containers"
	@echo "  make down    : Stop containers"
	@echo "  make clean   : Clean unused Docker resources"
	@echo "  make fclean  : Full cleanup and remove all data"
	@echo "  make re      : Rebuild the project from scratch"
	@echo "  make prune   : Force remove all Docker resources"
	@echo "  make status  : Show containers, networks, and volumes status"
	@echo "  make logs    : Show containers logs"
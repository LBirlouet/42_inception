SRCS_DIR = srcs

COMPOSE_FILE = $(SRCS_DIR)/docker-compose.yml

ENV_FILE = $(SRCS_DIR)/.env

GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
BLUE := \033[0;34m
RESET := \033[0m

all: build up

build:
	@echo "$(BLUE)Montage des images Docker...$(RESET)"
	mkdir -p $(HOME)/data/wordpress
	mkdir -p $(HOME)/data/mariadb
	docker compose -f $(COMPOSE_FILE) build

up:
	@echo "$(GREEN)Démarrage des conteneurs...$(RESET)"
	docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d

down:
	@echo "$(YELLOW)Arrêt des conteneurs...$(RESET)"
	docker compose -f $(COMPOSE_FILE) down -v

clean: 
	@echo "$(RED)Nettoyage des conteneurs, images et volumes...$(RESET)"
	docker compose -f $(COMPOSE_FILE) down --volumes --rmi all --remove-orphans

fclean: down
	@echo "$(RED)Suppression complète des données et ressources Docker...$(RESET)"
	docker system prune -af --volumes
	sudo rm -rf $(HOME)/data

status:
	@echo "$(BLUE)Statut des conteneurs:$(RESET)"
	docker ps -a
	@echo "\n$(BLUE)Réseaux:$(RESET)"
	docker network ls
	@echo "\n$(BLUE)Volumes:$(RESET)"
	docker volume ls

check:
	@echo "$(BLUE)Vérification des services...$(RESET)"
	docker ps | grep -q nginx && echo "$(GREEN)✓ NGINX est en cours d'exécution$(RESET)" || echo "$(RED)✗ NGINX n'est pas en cours d'exécution$(RESET)"
	docker ps | grep -q wordpress && echo "$(GREEN)✓ WordPress est en cours d'exécution$(RESET)" || echo "$(RED)✗ WordPress n'est pas en cours d'exécution$(RESET)"
	docker ps | grep -q mariadb && echo "$(GREEN)✓ MariaDB est en cours d'exécution$(RESET)" || echo "$(RED)✗ MariaDB n'est pas en cours d'exécution$(RESET)"
	curl -s -k -o /dev/null -w "$(GREEN)✓ Site web accessible: %{http_code}$(RESET)\n" https://fvastena.42.fr

help:
	@echo "$(BLUE)════════════════════════ INCEPTION MAKEFILE ════════════════════════$(RESET)"
	@echo "$(BLUE)Commandes disponibles:$(RESET)"
	@echo "  $(YELLOW)make$(RESET)             : Construit et démarre tous les conteneurs"
	@echo "  $(YELLOW)make build$(RESET)       : Crée les dossiers de données et construit les images Docker"
	@echo "  $(YELLOW)make up$(RESET)          : Démarre les conteneurs"
	@echo "  $(YELLOW)make down$(RESET)        : Arrête les conteneurs et supprime les volumes"
	@echo "  $(YELLOW)make clean$(RESET)       : Nettoie les conteneurs, images et volumes"
	@echo "  $(YELLOW)make fclean$(RESET)      : Suppression complète des données et ressources Docker"
	@echo "  $(YELLOW)make status$(RESET)      : Affiche l'état des conteneurs, réseaux et volumes"
	@echo "  $(YELLOW)make check$(RESET)       : Vérifie que les services fonctionnent correctement"
	@echo "  $(YELLOW)make re$(RESET)          : Nettoie et recrée tout (clean + all)"
	@echo "  $(YELLOW)make help$(RESET)        : Affiche cette aide"
	@echo "$(BLUE)═════════════════════════════════════════════════════════════════════$(RESET)"

re: clean all

.PHONY: all build up down clean fclean status check help re
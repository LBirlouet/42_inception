NAME = inception

all: $(NAME)

$(NAME):
    mkdir -p /home/$(USER)/data/wordpress
    mkdir -p /home/$(USER)/data/mariadb
    docker-compose -f srcs/docker-compose.yml up --build -d

clean:
    docker-compose -f srcs/docker-compose.yml down -v

fclean: clean
    docker system prune -af
    sudo rm -rf /home/$(USER)/data/wordpress/*
    sudo rm -rf /home/$(USER)/data/mariadb/*

re: fclean all

.PHONY: all clean fclean re
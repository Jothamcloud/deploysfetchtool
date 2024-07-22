#!/bin/bash

display_help() {
    cat << EOF
Usage: $0 [option] [argument]

Options:
-d, --docker         List all Docker images and containers or detailed info about a specific container
-u, --users          List all users and their last login times or detailed info about a specific user
-n, --nginx          Show all Nginx server names and their ports or detailed config of a specific server
-t, --time           Display system activities within a specified time range
-p, --ports          Show all active ports and services or detailed info about a specific port
-h, --help           Display this help message
EOF
}

show_ports() {
sudo netstat -tuln | awk 'NR>2 {print $4, $1}' | column -t
}

port_details() {
sudo lsof -i :"$1"
}

show_docker() {
docker images
docker ps -a
}

container_details() {
docker inspect "$1"
}

show_nginx() {
sudo nginx -T 2>/dev/null | grep -E "server_name|listen"
}

nginx_details() {
sudo nginx -T 2>/dev/null | awk "/server_name $1/,/}/"
}

show_users() {
lastlog
}

user_details() {
id "$1"
lastlog | grep "$1"
}

time_range() {
journalctl --since="$1" --until="$2"
}

case "$1" in
-p|--ports)
if [ -z "$2" ]; then
show_ports
else
port_details "$2"
fi
;;
-d|--docker)
if [ -z "$2" ]; then
show_docker
else
container_details "$2"
fi
;;
-n|--nginx)
if [ -z "$2" ]; then
show_nginx
else
nginx_details "$2"
fi
;;
-u|--users)
if [ -z "$2" ]; then
show_users
else
user_details "$2"
fi
;;
-t|--time)
if [ -z "$2" ] || [ -z "$3" ]; then
echo "Please provide a valid time range."
exit 1
else
time_range "$2" "$3"
fi
;;
-h|--help)
display_help
;;
*)
echo "Invalid option. Use -h or --help for usage information."
exit 1
;;
esac


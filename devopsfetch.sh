#!/bin/bash

# Display Help
help() {
    echo "Usage: $0 [option] [argument]"
    echo
    echo "Options:"
    echo "-p, --port            Display all active ports and services or detailed information about a specific port"
    echo "-d, --docker          List all Docker images and containers or detailed information about a specific container"
    echo "-n, --nginx           Display all Nginx domains and their ports or detailed configuration information for a specific domain"
    echo "-u, --users           List all users and their last login times or detailed information about a specific user"
    echo "-t, --time            Display activities within a specified time range"
    echo "-h, --help            Display this help message"
}

# Display all active ports and services
active_ports() {
    echo -e "Active Ports and Services:\n"
    sudo netstat -tuln | awk 'NR>2 {print $4, $1}' | column -t | awk '{printf "%-25s %-10s\n", $1, $2}'
}

# Display detailed information about a specific port
port_info() {
    echo -e "Details for Port $1:\n"
    sudo lsof -i :"$1" | awk 'NR==1 {print "COMMAND\tPID\tUSER\tFD\tTYPE\tDEVICE\tSIZE/OFF\tNODE\tNAME"; next} {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}'
}

# List all Docker images and containers
docker_info() {
    echo -e "Docker Images:\n"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"

    echo -e "\nDocker Containers:\n"
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"
}

# Detailed information about a specific container
container_info() {
    echo -e "Details for Container $1:\n"
    docker inspect "$1" --format "table {{.Id}}\t{{.Image}}\t{{.Name}}\t{{.State.Status}}\t{{.NetworkSettings.IPAddress}}"
}

# Display all Nginx domains and their ports
nginx_info() {
    echo -e "Nginx Domains and Ports:\n"
    sudo nginx -T 2>/dev/null | grep -E "server_name|listen" | awk -F ' ' '{printf "%-30s %s\n", $1, $2}'
}

# Detailed configuration information for a specific domain
domain_info() {
    echo -e "Nginx Configuration for Domain $1:\n"
    sudo nginx -T 2>/dev/null | awk "/server_name $1/,/}/" | sed 's/^\s*//'
}

# List all users and their last login times
user_logins() {
    echo -e "User Logins:\n"
    lastlog | awk 'NR==1 {print "Username\tPort\tLast Login"; next} {print $1"\t"$2"\t"$3" "$4" "$5}'
}

# Detailed information about a specific user
user_info() {
    echo -e "Details for User $1:\n"
    id "$1" | awk -F ' ' '{printf "User ID: %-10s\nGroup ID: %-10s\nGroups: %-s\n", $1, $2, $3}'
    echo -e "\nLast Login Info:"
    lastlog | grep "$1" | awk '{print "Last Login: " $3" "$4" "$5}'
}

# Display activities within a specified time range
time_range() {
    echo -e "System Activities from $1 to $2:\n"
    journalctl --since="$1" --until="$2" --output=short-iso | awk '{printf "%-30s %s\n", $1, $2}'
}

# Parse Command-line Arguments
case $1 in
    -p|--port)
        if [ -z "$2" ]; then
            active_ports
        else
            port_info "$2"
        fi
        ;;
    -d|--docker)
        if [ -z "$2" ]; then
            docker_info
        else
            container_info "$2"
        fi
        ;;
    -n|--nginx)
        if [ -z "$2" ]; then
            nginx_info
        else
            domain_info "$2"
        fi
        ;;
    -u|--users)
        if [ -z "$2" ]; then
            user_logins
        else
            user_info "$2"
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
        help
        ;;
    *)
        echo "Invalid option. Use -h or --help for usage information."
        exit 1
        ;;
esac


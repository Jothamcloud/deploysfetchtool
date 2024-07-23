# DevOpsFetch

DevOpsFetch is a powerful tool for retrieving and displaying system information. It helps DevOps teams monitor server activities by collecting data on active ports, user logins, Nginx configurations, Docker images, and container statuses. The tool also includes continuous monitoring and logging capabilities through a systemd service.

## Features

- List active ports and services.
- Retrieve detailed information about specific ports.
- List Docker images and containers.
- Retrieve detailed information about specific Docker containers.
- Display Nginx domains and their ports.
- Retrieve detailed configuration information for specific Nginx domains.
- List users and their last login times.
- Retrieve detailed information about specific users.
- Display activities within a specified time range.
- Continuous monitoring and logging with log rotation.

## Installation

### Prerequisites

Ensure you have the following tools installed on your system:

- git
- bash
- sudo privileges

### Steps

1. Clone the repository:

```bash
git clone https://github.com/yourusername/devopsfetch.git
cd devopsfetch
```

2. Run the setup script:

```bash
./setup_sysinfo.sh
```

This script will:
- Install necessary dependencies.
- Configure a systemd service for continuous monitoring.
- Set up log rotation for the logs.

3. Verify the installation:

```bash
sudo systemctl status sysinfo.service
```

You should see an output indicating that the service is active and running.

## Usage

### List All Active Ports and Services

```bash
devopsfetch -p
```

### Detailed Information About a Specific Port

```bash
devopsfetch -p 80
```

### List All Docker Images and Containers

```bash
devopsfetch -d
```

### Detailed Information About a Specific Docker Container

```bash
devopsfetch -d container_name
```

### List All Nginx Domains and Their Ports

```bash
devopsfetch -n
```

### Detailed Configuration Information for a Specific Nginx Domain

```bash
devopsfetch -n example.com
```

### List All Users and Their Last Login Times

```bash
devopsfetch -u
```

### Detailed Information About a Specific User

```bash
devopsfetch -u username
```

### Display Activities Within a Specified Time Range

```bash
devopsfetch -t "2023-01-01" "2023-12-31"
```

### Display Help Message

```bash
devopsfetch -h
```

## Logging

Logs are stored in /path/to/sysinfo.log and are rotated daily, with the last 14 days' logs being kept. To view the logs:

```bash
cat /path/to/sysinfo.log
```

Or to view the most recent entries in real-time:

```bash
tail -f /path/to/sysinfo.log
```

## Usage Example Screenshots

Here are some screenshots demonstrating DevOpsFetch in action:

### Checking Active Ports
![Active Ports](https://github.com/Jothamcloud/deploysfetchtool/blob/main/Active%20Ports.png)
This screenshot shows DevOpsFetch displaying all active ports on the system.

### Listing Docker Containers
![Docker Containers](https://github.com/Jothamcloud/deploysfetchtool/blob/main/Docker%20Containers%20.png)
Here, DevOpsFetch is listing all Docker containers running on the server.

### Viewing Nginx Configurations
![Nginx Configurations](path/to/nginx_screenshot.png)
This image shows DevOpsFetch retrieving and displaying Nginx configurations.



## Contributing

Feel free to contribute to this project by submitting issues or pull requests. Here are some ways you can help:

- Report bugs or request new features by opening an issue.
- Improve the code by submitting a pull request.
- Enhance the documentation with more examples or detailed explanations.

---


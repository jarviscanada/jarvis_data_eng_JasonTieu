# Linux Cluster Monitoring Agent
## Introduction
This project is a Linux-based cluster Monitoring Agent designed to collect, store, 
and analyze hardware specifications and real-time usage from multiple Linux hosts.
The system helps system administrators and DevOps teams gain visibility into CPU,
memory, disk, and system utilization across a small cluster environment. Each host
runs a lightweight Bash agent that periodically gathers metrics and sends them to a 
centralized PostgreSQL database for storage and querying. 

The project is implemented using Bash scripting for data collection, PostgreSQL 
for data persistence, Docker for database containerization, and cron for task 
scheduling. The design emphasizes automation, portability, and clarity, making it easy to deploy and extend in real-world Linux environments.

## Quick Start
```bash
# Create a PostgreSQL container using Docker
./scripts/psql_docker.sh create postgres password

# Create database tables
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# Insert host hardware into the DB
./scripts/host_info.sh localhost 5432 host_agent postgres password

# Insert hardware usage into the DB
./scripts/host_usage.sh localhost 5432 host_agent postgres password

# Set up a cron job
crontab -e
```
## Implementation
### Architecture
The system follows a simple client-server architecture. Multiple Linux hosts act as
agents that collect hardware and usage data. These agents communicate with a centralized
PostgreSQL database hosted inside a Docker container. Each host periodically pushes
metrics to the database, allowing centralized monitoring and historical analysis.

A cluster diagram illustrating three Linux hosts, monitoring agents, and a PostgreSQL
database is included in the `assets/` directory

## Scripts

#### psql_docker.sh
Manages PostgreSQL Docker container (Create, start, stop)
```bash
./psql_docker.sh create <db_username> <db_password>
./psql_docker.sh start|stop
```

#### host_info.sh
Collects hardware information such as CPU details, memory size, and operating system
data, then inserts it into the database
```bash
./host_info.sh <psql_host> <psql_port> <db_name> <user> <password>
```

#### host_usage.sh
Collects system metrics including memory usage, CPU utilization, Disk I/O, and available
disk space. This script is intended to run periodically.
```bash
./host_usage.sh <psql_host> <psql_port> <db_name> <user> <password>
```

#### crontab
Schedules the `host_usage.sh` script to run automatically at fixed intervals to
enable continuous monitoring

## Database Modeling
### host_info
| Column Name      | Description                             |
|------------------|-----------------------------------------|
| id               | Unique identifier for each host         |
| hostname         | Fully qualified domain name of the host |
| cpu_number       | Number of CPU cores                     |
| cpu_architecture | CPU architecture type                   |
| cpu_model        | CPU model name                          |
| cpu_mhz          | CPU clock speed                         |
| total_mem        | Total memory in MB                      |
| timestamp        | Record creation time                    |

### host_usage
| Column Name    | Description                      |
|----------------|----------------------------------|
| timestamp      | Time when metrics were collected |
| host_id        | Reference to host_info table     |
| memory_free    | Available memory in MB           |
| cpu_idle       | Percentage of idle CPU           |
| cpu_kernel     | Percentage of CPU used by kernel |
| disk_io        | Disk I/O operations              |
| disk_available | Available disk space in MB       |

## Test
The Bash scripts were tested by executing them manually on Linux virtual machines
and verifying successful data insertion using SQL SELECT queries. Database schemas
were validated by running the DDL script in a clean PostgreSQL instance and
confirming table creation. Error cases such as missing arguments and inactive
Docker services were also tested to ensure proper handling.

## Deployment
The project is deployed using GitHub for source control and collaboration. 
PostgreSQL runs inside a Docker container to ensure environment consistency. 
Monitoring scripts are deployed on each Linux host, and cron is used to automate 
periodic data collection without manual intervention.

## Improvements
- Support automatic detection and updates when host hardware changes
- Implement data retention and cleanup policies
- Add alerting for abnormal resource usage patterns
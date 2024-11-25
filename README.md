# Glacier Node Setup Guide
This guide explains how to set up, run, and manage multiple Glacier nodes using the provided scripts.

## Requirements
- A server running Linux (Ubuntu recommended).
- Docker
- Docker Container

## Hardware Requirements
- Fast CPU with 2+ cores
- 4GB+ RAM
- 8+ MBit/sec download Internet service

### 1. Clone Repository
> Clone the Glacier Node setup repository:
```bash
git clone https://github.com/NodeInter/Glacier.git
cd Glacier
```

### 2. Setup Nodes
> Run the setup script to configure the nodes:
```bash
chmod +x setup_nodes.sh
./setup_nodes.sh
```

### 3. Run Nodes
> Use the run_nodes.sh script to start all nodes using PM2:
```bash
chmod +x run_nodes.sh
./run_nodes.sh
```
> Example input:
```
Enter the list of Private Keys (separated by spaces):
privatekey1 privatekey2 privatekey3
```


### 4. Check Node Status
> Use the following docker commands to monitor and manage the nodes:

- List all running nodes:
```
docker ps -a 
```
- Check logs for a specific node:
```
docker logs <container_name>
```

### 5. Additional Options
- Stop a specific node:
```
docker stop <container_name>
```

- Restart all nodes:
```
docker ps -a --filter "name=^glacier-node" --format "{{.Names}}" | while read container_name; do
  echo "Restarting node: $container_name"
  docker restart "$container_name"
done
```

- Stop all nodes:
```
docker ps -a --filter "name=^glacier-node" --format "{{.Names}}" | while read container_name; do
  echo "Stopping node: $container_name"
  docker stop "$container_name"
done

```

- Delete a specific node from:
```
docker rm <container_name>
```

### 6. Updating Binary or Docker-Image
> Update Binary:
```bash
chmod +x update_nodes.sh
./update_nodes.sh
```

### 7. Support
For additional help or updates, visit the [Glacier GitHub Repository.](https://docs.glacier.io/getting-started/glacier-nodes/run-testnet-nodes/linux-cli)

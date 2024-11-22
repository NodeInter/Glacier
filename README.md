# Glacier Node Setup Guide
This guide explains how to set up, run, and manage multiple Glacier nodes using the provided scripts.

## Requirements
- A server running Linux (Ubuntu recommended).
- Node.js (v20 or higher). The script will automatically install it if not available.
- PM2 for process management.

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
sudo ./setup_nodes.sh
```

> Example input:
```
Enter the list of Private Keys (separated by spaces):
privatekey1 privatekey2 privatekey3
```
> Resulting Folder Structure:
```
Glacier/
├── verifier_linux_amd64
├── node0/
│   ├── verifier_linux_amd64
│   └── config.yaml
├── node1/
│   ├── verifier_linux_amd64
│   └── config.yaml
└── node2/
    ├── verifier_linux_amd64
    └── config.yaml
```

### 3. Run Nodes
> Use the run_nodes.sh script to start all nodes using PM2:
```bash
./run_nodes.sh
```

> This script:
- Generates a pm2-glacier.json file with configurations for each node.
- Starts all nodes as separate processes managed by PM2.
- Saves the PM2 setup for persistence across server reboots.

### 4. Check Node Status
> Use the following PM2 commands to monitor and manage the nodes:

- List all running nodes:
```
pm2 list
```
- Check logs for a specific node:
```
pm2 logs glacier-node0
```

### 5. Additional Options
- Stop a specific node:
```
pm2 stop glacier-node0
```

- Restart all nodes:
```
pm2 restart all
```

- Stop all nodes:
```
pm2 stop all
```

- Delete a specific node from PM2:
```
pm2 delete glacier-node0
```

- Ensure nodes restart after reboot:
```
pm2 startup
pm2 save
```

### 6. Updating Binary or Configuration
> Update Binary:
- Replace the existing verifier_linux_amd64 binary in the main Glacier folder.
- Copy the updated binary to all node folders:
```
cp verifier_linux_amd64 node*/verifier_linux_amd64
```

> Update Configuration:
- Modify the relevant config.yaml file inside each node's folder.
- Restart the nodes after updates:
```
pm2 restart all
```

### 7. Folder Cleanup
> If you want to reset the configuration or remove all nodes:
```
rm -rf Glacier
```

### 8. Support
For additional help or updates, visit the [Glacier GitHub Repository.](https://docs.glacier.io/getting-started/glacier-nodes/run-testnet-nodes/linux-cli)

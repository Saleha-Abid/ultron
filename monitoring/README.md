# Guide
This dircetory has,
1. JSON files for grafana dashboards.
2. The docker-compose and prometheus yaml configurations.
3. The config file for node exporter.

## Steps
Make a directory and copy the `docker-compose.yml` and 'prometheus.yml`. Start docker,
```bash
sudo docker-compose up -d
```

Next, make sure you have the updated `slurm.conf` with prometheus enabled.

You must start the node_exporter service. First, download it,
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
```

Copy the node_exporter.service to /etc/systemd/system/node_exporter.service.

**NOTE: REMOVE THE `--collector-drbd` WHEN YOU COPY IT TO COMPUTE NODES**

Start the service,
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
```

Import pre-built dashboards for monitoring.

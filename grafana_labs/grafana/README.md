# Grafana Configuration

This folder contains the configuration for Grafana, including:

- `grafana.ini`: Base configuration file.
- `provisioning/`: Contains datasources, dashboards, and alerting provisioning.

Grafana is exposed internally at `https://grafana.internal:3000` and uses shared TLS certificates for secure access.

The provisioning files enable automatic setup of dashboards and datasources, making deployment repeatable and infrastructure-as-code friendly.

# Alloy Configuration

Grafana Alloy is a lightweight agent that combines metrics, logs, and traces.

- `config.alloy`: Unified configuration file for telemetry collection.

Configured to:
- Export metrics/logs to Loki and Prometheus.
- Use mTLS for secure communication.
- Pull credentials and secrets from a shared cert volume.

Alloy replaces the need for multiple separate agents in some setups and is ideal for simplifying observability pipelines.

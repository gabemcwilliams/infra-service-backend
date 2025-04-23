# Prometheus Configuration

Contains configuration for the Prometheus time-series metrics collector.

- `.yaml`: Main scrape config file.

Key points:
- Scrapes metrics from local services and exporters.
- Configurable alert rules and scrape intervals.
- Uses TLS for secure API and web UI access.

Accessible at `https://prometheus.internal:9030` with read-only UI.

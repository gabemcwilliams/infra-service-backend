# Promtail Configuration

This directory contains configuration for Promtail, the log shipping agent for Loki.

- `.yaml`: Defines scrape configs and pipeline stages.

Promtail watches `/var/log` and ships logs to Loki using HTTPS. It supports client-side TLS with certificates mounted from a shared volume.

Make sure to persist `.yaml` if you want tailing to resume across restarts.

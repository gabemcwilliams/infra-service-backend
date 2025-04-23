# Kafka Service Overview

## Purpose
This Kafka service provides a lightweight, single-node development setup using **KRaft mode**, eliminating the need for ZooKeeper while supporting event streaming pipelines and real-time data ingestion.

## Key Features
- **KRaft Mode (Kafka without ZooKeeper)** for simplified dev experience
- **Configured for Docker Networking** with static IPs and hostname overrides
- **Customizable Broker Settings** such as log retention, rebalance timing, and topic auto-creation
- **Secure Access** through `kafka.example.internal` (optional Nginx proxy layer)

## Configuration Highlights
- Ports: `9092` for Kafka client communication, `9093` for controller quorum
- Listener: `PLAINTEXT` (can be secured via Nginx SSL termination)
- Data persistence: `./data` is mounted to `/var/lib/kafka/data`
- Auto topic creation enabled for development ease

## Internal Networking
- Advertised listener: `kafka.example.internal`
- Static IP: `[REDACTED_IP]`
- Part of external Docker network: `kafka`

## Usage
This service is designed to support local development with tools like MLflow, Prefect, and custom event-driven pipelines.

---

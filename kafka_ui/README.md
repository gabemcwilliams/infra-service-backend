# Kafka-UI Overview

## Purpose
Kafka-UI provides a user-friendly web interface to inspect topics, consumer groups, schemas, and more in your Kafka cluster.

## Key Features
- **Visual Topic Explorer** for messages, partitions, and offsets
- **Consumer Group Monitoring** with real-time lag tracking
- **Topic Creation and Deletion** from the interface
- **Support for Multiple Kafka Clusters**

## Configuration
- Host: `kafka-ui.example.internal`
- Port: `8080` exposed locally
- Connected Kafka Broker: `kafka.example.internal:9092`
- Static IP: `[REDACTED_IP]`

## Environment Variables
- `KAFKA_CLUSTERS_0_NAME=kafka`
- `KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka.example.internal:9092`

## Notes
Kafka-UI is configured to run alongside Kafka in the same Docker network, enabling seamless local testing and observability.

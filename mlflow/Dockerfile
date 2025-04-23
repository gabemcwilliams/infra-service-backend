
#
# Build the image:
#   docker build --pull --no-cache --progress=plain -t docker-registry.example.internal:5000/mlflow_python3.12:latest -f /mnt/data/build/mlflow/Dockerfile /mnt/data/build/mlflow/
#
# Explanation:
#    -t docker-registry.example.internal:5000/mlflow_python3.12:latest → Tags the image with your private registry.
#    -f Dockerfile → Specifies the Dockerfile location.
#    . → The build context (files used during build).
#
# Push the image:
#   docker push docker-registry.example.internal:5000/mlflow_python3.12:latest

# ────────────────────────────────────────────────────────────────────────────

# Use a smaller base image
FROM python:3.12-slim AS base

# ────────────────────────────────────────────────────────────────────────────

# Labels
LABEL maintainer="builds@example.com"
LABEL version="0.6"
LABEL description="Custom MLFlow Server & Worker Image"

# ────────────────────────────────────────────────────────────────────────────

# Set non-interactive mode for apt installs
ENV DEBIAN_FRONTEND=noninteractive

# ────────────────────────────────────────────────────────────────────────────

# Install minimal dependencies (each step is split for better debugging)
RUN apt-get update

RUN apt-get install -y openssh-server

RUN apt-get install -y iputils-ping

RUN apt-get install -y net-tools

RUN apt-get install -y nano

RUN apt-get install -y postgresql-client

RUN apt-get install -y curl


# Clean up apt cache to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# ────────────────────────────────────────────────────────────────────────────

# Set working directory
WORKDIR /mlflow

# ────────────────────────────────────────────────────────────────────────────

# Copy only the needed requirements
.txt.txt
RUN echo "---- REQUIREMENTS CONTENT ----" &&.txt

# ────────────────────────────────────────────────────────────────────────────

# Install Python dependencies **WITHOUT unnecessary ML packages**
.txt

# ────────────────────────────────────────────────────────────────────────────

# Expose required ports
EXPOSE 5000 8080 5432 9000

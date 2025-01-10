# Use the official Chainlink image from Docker Hub
FROM smartcontract/chainlink:1.1.0

# Set environment variables (you can override these later via the `.env` file)
ENV CHAINLINK_PORT=6688
ENV DATABASE_URL=postgresql://chainlink_user:1210@localhost:5432/chainlink_db
ENV ETH_URL=http://localhost:8545
ENV CHAINLINK_API_URL=http://localhost:6688
ENV CHAINLINK_API_SECRET=G1znlTKE4erGrF69PqnoOGsTkwzQiHyFqYiDQ22FDHw=
ENV CUSTOM_ADAPTER_URL=http://localhost:8080/get-streams
ENV ETH_GAS_LIMIT=1000000
ENV ETH_CHAIN_ID=1
ENV CHAINLINK_USERNAME=admin
ENV CHAINLINK_PASSWORD=admin_password
ENV LINK_CONTRACT_ADDRESS=0xBC1a730Dd598ad142cdf5D457C7d6a9eF83a46Fb
ENV CHAINLINK_MAX_CONCURRENT_JOBS=10

# Set working directory
WORKDIR /chainlink

# Copy in your custom external adapter (Flask server)
# You can include your Flask server code in the image
# You need to copy your Flask server files into the container, adjust the path as needed
COPY ./database /flask_server

# Install Python dependencies for the Flask server (external adapter)
RUN apt-get update && apt-get install -y python3-pip python3-dev
RUN pip3 install -r /flask_server/requirements.txt

# Expose the ports for Chainlink node and Flask server
EXPOSE 6688
EXPOSE 8080

# Start both the Chainlink node and the Flask server
# Using the supervisor tool to run both applications simultaneously
CMD ["sh", "-c", "supervisord -c /chainlink/supervisord.conf"]

# Base image
FROM ubuntu:latest

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        gcc \
        git \
        cmake \
        curl

# Option to use a local clone of the repository
ARG USE_LOCAL_REPO
ENV USE_LOCAL_REPO=${USE_LOCAL_REPO}
ENV LOCAL_REPO_PATH=./alpakka_firmware

# Download firmware source code
WORKDIR /alpakka_firmware
RUN if [ "$USE_LOCAL_REPO" = "true" ]; then \
        echo "Using local repository"; \
        mkdir -p /alpakka_firmware && \
        cd /alpakka_firmware && \
        cp -R $LOCAL_REPO_PATH/* . ; \
    else \
        echo "Using remote repository"; \
        git clone https://github.com/inputlabs/alpakka_firmware . ; \
    fi

# Install additional libraries
RUN make install

# Compile the firmware
RUN make

# Define a volume mount to output the alpakka.uf2 file
VOLUME /output

# Default command (equivalent to 'make')
CMD ["make"]

# Define entrypoints for 'rebuild' and 'load' options
ENTRYPOINT ["make"]
CMD ["rebuild"]

ENTRYPOINT ["make"]
CMD ["load"]

# Modern Dockerfile for Hyperion.ng
# Multi-stage build for optimized image size

# Build stage
FROM debian:bookworm-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libqt5core5a \
    libqt5gui5 \
    libqt5network5 \
    libqt5serialport5 \
    libqt5sql5 \
    libqt5sql5-sqlite \
    libqt5widgets5 \
    libusb-1.0-0-dev \
    libcec-dev \
    libavahi-core-dev \
    libavahi-compat-libdnssd-dev \
    libturbojpeg0-dev \
    libssl-dev \
    python3 \
    qtbase5-dev \
    qtbase5-dev-tools \
    libqt5serialport5-dev \
    libqt5sql5-sqlite \
    libqt5svg5-dev \
    libqt5x11extras5-dev \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/hyperion

# Clone Hyperion.ng repository
ARG HYPERION_VERSION=master
RUN git clone --recursive --depth 1 -b ${HYPERION_VERSION} https://github.com/hyperion-project/hyperion.ng.git /opt/hyperion

# Create build directory and build Hyperion
RUN mkdir -p /opt/hyperion/build && \
    cd /opt/hyperion/build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DPLATFORM=linux \
          -DENABLE_EFFECTENGINE=ON \
          -DENABLE_FLATBUF_SERVER=ON \
          -DENABLE_PROTOBUF_SERVER=ON \
          -DENABLE_BOBLIGHT_SERVER=ON \
          -DENABLE_FORWARDER=ON \
          -DENABLE_X11=OFF \
          -DENABLE_XCB=OFF \
          -DENABLE_DISPMANX=OFF \
          -DENABLE_FB=ON \
          -DENABLE_AUDIO=OFF \
          -DENABLE_V4L2=ON \
          -DENABLE_CEC=ON \
          -DENABLE_AVAHI=ON \
          -DENABLE_MDNS=ON \
          .. && \
    make -j$(nproc) && \
    make install DESTDIR=/opt/hyperion-install

# Runtime stage
FROM debian:bookworm-slim

LABEL maintainer="Hyperion.ng Docker"
LABEL description="Hyperion.ng - Open Source Ambient Lighting"
LABEL version="latest"

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    libqt5core5a \
    libqt5gui5 \
    libqt5network5 \
    libqt5serialport5 \
    libqt5sql5 \
    libqt5sql5-sqlite \
    libqt5widgets5 \
    libusb-1.0-0 \
    libcec6 \
    libavahi-client3 \
    libavahi-core7 \
    libavahi-common3 \
    libturbojpeg0 \
    libssl3 \
    python3 \
    python3-minimal \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy built Hyperion from builder stage
COPY --from=builder /opt/hyperion-install/usr/local /usr/local

# Create hyperion user and group
RUN groupadd -r hyperion && \
    useradd -r -g hyperion -d /opt/hyperion -s /bin/bash hyperion && \
    mkdir -p /opt/hyperion /opt/hyperion/config && \
    chown -R hyperion:hyperion /opt/hyperion

# Set working directory
WORKDIR /opt/hyperion

# Expose ports
# 8090: Web UI
# 19444: JSON server
# 19445: Protobuf server
# 19400: Flatbuffer server
# 2100: Boblight server
EXPOSE 8090 19444 19445 19400 2100

# Set environment variables
ENV HYPERION_HTTP_PORT=8090 \
    HYPERION_JSON_PORT=19444

# Volume for configuration
VOLUME ["/opt/hyperion/config"]

# Switch to non-root user
USER hyperion

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD hyperiond --test || exit 1

# Entry point
ENTRYPOINT ["hyperiond"]

# Default command - configuration file location
CMD ["--userdata", "/opt/hyperion/config"]

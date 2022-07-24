# Pull base image
FROM python:3.7.6-stretch

# Install dependencies
RUN apt-get update && apt-get install -y \
    vim \
    gcc \
    build-essential \
    libglib2.0-dev \
    bluez \
    libbluetooth-dev \
    libffi-dev \
    libusb-dev \
    libdbus-1-dev \
    libglib2.0-dev \
    libudev-dev \
    libical-dev \
    libreadline-dev \
    libboost-python-dev \
    git \
    ca-certificates \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install pygatt
RUN pip3 install pynacl
RUN pip3 install crc16
RUN pip3 install pybluez
RUN pip3 install pexpect
RUN apt-get update && apt-get install -y wget

RUN mkdir /tmp/bluez
RUN wget --no-check-certificate http://www.kernel.org/pub/linux/bluetooth/bluez-5.54.tar.xz -O /tmp/bluez/bluez-5.54.tar.xz
WORKDIR /tmp/bluez
RUN tar xvf bluez-5.54.tar.xz 
WORKDIR /tmp/bluez/bluez-5.54
RUN ./configure --disable-systemd
RUN make
RUN make install

# fix library problem for python3 & libboost
#RUN mv /usr/lib/arm-linux-gnueabihf/libboost_python-py27.so.1.55.0 /usr/lib/arm-linux-gnueabihf/libboost_python-py27.so.1.55.0-old
#RUN ln -s /usr/lib/arm-linux-gnueabihf/libboost_python-py34.so.1.55.0 /usr/lib/arm-linux-gnueabihf/libboost_python-py27.so.1.55.0

COPY gatttool-docker.py /usr/local/lib/python3.7/dist-packages/pygatt/backends/gatttool/gatttool.py
COPY gatttool-docker.py /usr/local/lib/python3.7/site-packages/pygatt/backends/gatttool/gatttool.py

RUN pip install flask retry

ENV FLASK_APP server.py
ENV FLASK_RUN_PORT 5000
ENV FLASK_DEBUG 1

COPY . /opt/nuki

WORKDIR /opt/nuki 

CMD ["flask", "run", "-h", "0.0.0.0"]

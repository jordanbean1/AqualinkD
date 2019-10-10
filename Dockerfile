FROM ubuntu:19.10

WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    systemd \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir software
WORKDIR /usr/src/app/software
RUN git clone https://github.com/jordanbean1/AqualinkD.git
WORKDIR /usr/src/app/software/AqualinkD
RUN make clean
RUN make
RUN make install

CMD ["aqualinkd", "-d", "-c", "/etc/aqualinkd.conf"]
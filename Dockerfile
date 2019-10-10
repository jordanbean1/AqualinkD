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
#COPY release/aqualinkd.conf .
RUN make clean
RUN make
RUN make install

RUN sed -i 's/display_warnings_in_web=false/display_warnings_in_web=true/' /etc/aqualinkd.conf
RUN sed -i 's/#mqtt_address = localhost:1883/mqtt_address = mqtt:\/\/192.168.1.114:1883/' /etc/aqualinkd.conf

RUN sed -i 's/#mqtt_aq_topic = aqualinkd/mqtt_aq_topic = aqualinkd/' /etc/aqualinkd.conf
#RUN sed -i 's/#log_file=\/var\/log\/aqualinkd.log/log_file=\/var\/log\/aqualinkd.log/' /etc/aqualinkd.conf

EXPOSE 80
#RUN echo $(cat /etc/aqualinkd.conf)

CMD ["aqualinkd", "-d", "-c", "/etc/aqualinkd.conf"]
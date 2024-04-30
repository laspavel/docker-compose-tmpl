FROM selenoid/vnc_chrome:91.0
RUN mkdir /usr/local/share/ca-certificates/extra
#COPY ./ca1.crt /usr/local/share/ca-certificates/extra
#COPY ./ca2.crt /usr/local/share/ca-certificates/extra
#COPY ./ca3.crt /usr/local/share/ca-certificates/extra
RUN chmod 644 /usr/local/share/ca-certificates/extra/*.crt
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
RUN update-ca-certificates

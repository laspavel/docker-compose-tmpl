FROM aerokube/selenoid-ui:1.10.3
RUN apk update && apk add ca-certificates && rm -rm /var/cache/apk/* && mkdir /usr/local/share/ca-certificates/extra
#COPY ./ca1.crt /usr/local/share/ca-certificates/extra
#COPY ./ca2.crt /usr/local/share/ca-certificates/extra
#COPY ./ca3.crt /usr/local/share/ca-certificates/extra
RUN chmod 644 /usr/local/share/ca-certificates/extra/*.crt
RUN update-ca-certificates

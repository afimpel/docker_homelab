FROM alpine:latest
RUN apk update && apk upgrade && apk add --no-cache goaccess goaccess-lang goaccess-doc
RUN mkdir -p /usr/share/nginx/html

COPY get-release /usr/local/bin/get-release
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/get-release
RUN get-release

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["-o", "/usr/share/nginx/html/report.html", \
     "--real-time-html", \
     "--port=443", \
     "--log-format=COMBINED", \
     "--date-format=%d/%b/%Y", \
     "--time-format=%H:%M:%S"]
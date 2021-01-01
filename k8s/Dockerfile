# a test debug pod
FROM nginx:latest

RUN apt-get update \
    && apt-get install -y traceroute curl dnsutils netcat-openbsd jq nmap wget inetutils-ping \ 
                          net-tools \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

STOPSIGNAL SIGTERM

#HEALTHCHECK --interval=10s --timeout=2s CMD curl -f http://localhost || exit 1

CMD ["nginx", "-g", "daemon off;"]


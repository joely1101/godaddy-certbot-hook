#/bin/bash
docker run -idt --rm --name certbot -v $PWD:/cert --net host --entrypoint=/bin/sh certbot/certbot
docker exec -it certbot sh -c "apk add bash curl;/cert/certbot-dns.sh certonly $1"
docker stop certbot

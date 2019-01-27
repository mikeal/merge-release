FROM debian:stretch
FROM node:10

RUN "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:./node_modules/.bin"
RUN "apt-get update && apt-get install -y git"

LABEL version="1.0.0"
LABEL repository="http://github.com/mikeal/merge-release"
LABEL homepage="http://github.com/merge-release"
LABEL maintainer="Mikeal Rogers <mikeal.rogers@gmail.com>"

LABEL com.github.actions.name="Automated releases for npm packages."
LABEL com.github.actions.description="Release npm package based on commit metadata."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"
COPY LICENSE README.md /

COPY "entrypoint.sh" "/entrypoint.sh"
COPY cli.js /cli.js
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]


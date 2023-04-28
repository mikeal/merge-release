FROM node:18-slim

LABEL version="1.0.0"
LABEL repository="http://github.com/mikeal/merge-release"
LABEL homepage="http://github.com/merge-release"
LABEL maintainer="Mikeal Rogers <mikeal.rogers@gmail.com>"

LABEL com.github.actions.name="Automated releases for npm packages."
LABEL com.github.actions.description="Release npm package based on commit metadata."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"

RUN apt-get update && apt-get -y --no-install-recommends install git jq findutils curl ca-certificates && rm -rf /var/lib/apt/lists/*

COPY . .

# Install dependencies here
RUN cd src && npm i

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]

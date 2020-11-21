FROM golang:1.15-alpine

# add label
LABEL "com.github.actions.name"="gocheck"
LABEL "com.github.actions.description"="GitHub Action for golang code check"
LABEL "com.github.actions.repository"="https://github.com/nanato12/gocheck"
LABEL "com.github.actions.homepage"="https://github.com/nanato12/gocheck"
LABEL "com.github.actions.maintainer"="nanato12"

# need packages
RUN apk update
RUN apk add gcc musl-dev git

# go package
RUN go get -u golang.org/x/tools/cmd/goimports
RUN go get -u golang.org/x/lint/golint

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

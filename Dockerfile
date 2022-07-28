# build stage
FROM golang:1.18-alpine@sha256:af22f4a8328063faee4b28da1b1bbccccb6f3ccaa0a07006f9d3aa2da43d18c2 as build

RUN apk add --no-cache git build-base

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY . ./

RUN go test
RUN go build

# runtime stage
FROM golang:1.18-alpine@sha256:af22f4a8328063faee4b28da1b1bbccccb6f3ccaa0a07006f9d3aa2da43d18c2

LABEL com.docker.skill.api.version="container/v2"
COPY skill.yaml /
COPY datalog /datalog

WORKDIR /skill
COPY --from=build /app/go-sample-skill .

ENTRYPOINT ["/skill/go-sample-skill"]

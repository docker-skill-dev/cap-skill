# build stage
FROM golang:1.18-alpine@sha256:5b58b2e5963db4cc97d5c5d2580744713303e8ddc979ff89d939c559502ec263 as build

RUN apk add --no-cache git build-base

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY . ./

RUN go test
RUN go build

# runtime stage
FROM golang:1.18-alpine@sha256:5b58b2e5963db4cc97d5c5d2580744713303e8ddc979ff89d939c559502ec263

LABEL com.docker.skill.api.version="container/v2"
COPY skill.yaml /
COPY datalog /datalog

WORKDIR /skill
COPY --from=build /app/go-sample-skill .

ENTRYPOINT ["/skill/go-sample-skill"]

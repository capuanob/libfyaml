# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y clang build-essential autoconf automake libtool git make libltdl-dev pkg-config

## Add source code to the build stage.
WORKDIR /
RUN git clone https://github.com/capuanob/libfyaml.git
WORKDIR /libfyaml
RUN git checkout mayhem

## Build
RUN ./bootstrap.sh
RUN ./configure CC=clang CFLAGS="-fsanitize=fuzzer-no-link" LDFLAGS="-fsanitize=fuzzer-no-link"
RUN make -j$(nproc)

# Package Stage
RUN mkdir /corpus
FROM --platform=linux/amd64 ubuntu:20.04
COPY --from=builder /libfyaml/build/fuzz/fyaml-fuzzer /
COPY --from=builder /libfyaml/fuzz/corpus /corpus

## Set up fuzzing!
ENTRYPOINT []
CMD /fyaml-fuzzer /corpus -close_fd_mask=2

FROM node:buster-slim as builder
WORKDIR /workspace

RUN apt-get update -q && \
    apt-get install -qy build-essential git python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY package*.json /workspace/
RUN npm install && \
    apt-get remove -qy build-essential git python && \
    apt autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

FROM node:buster-slim
WORKDIR /workspace

RUN apt-get update -q && \
    apt-get install -qy libjemalloc2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /workspace .

ENV NODE_OPTIONS=--max_old_space_size=4096
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

COPY . /workspace/
EXPOSE 3002
CMD ["npm", "start"]

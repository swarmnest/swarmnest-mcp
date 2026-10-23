# stdio build of the Swarmnest MCP server (for registries that run servers in containers)
FROM node:20-alpine
WORKDIR /app
COPY package.json ./
COPY bin ./bin
COPY src ./src
ENTRYPOINT ["node", "bin/stdio.js"]

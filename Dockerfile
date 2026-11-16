FROM node:18

WORKDIR /app

# Install FFmpeg for transcoding
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Install dependencies (include devDeps so we can compile TypeScript)
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install

# Only copy the worker — not web-client/
COPY src ./src
COPY shared ./shared

# Compile TS → JS and run the compiled server (Cloud Run sets PORT)
RUN npm run build

ENV NODE_ENV=production
EXPOSE 8080

CMD ["npm", "run", "serve"]

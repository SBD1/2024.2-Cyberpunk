FROM node:18

WORKDIR /app

COPY package*.json ./
COPY src ./src
COPY ddl ./ddl

RUN npm install

CMD ["node", "src/index.js"]

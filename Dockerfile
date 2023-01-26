FROM node:16.5.0-slim
WORKDIR /build
COPY . .
RUN npm install
CMD ["npm","start"]
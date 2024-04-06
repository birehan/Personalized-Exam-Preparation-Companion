FROM node:16.14.2
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . ./

EXPOSE 4000

ENV HOST=0.0.0.0
ENV PORT=4000

RUN npm run build

CMD [ "npm", "start" ]
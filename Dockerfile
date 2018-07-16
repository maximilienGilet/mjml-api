FROM node:alpine

WORKING_DIR /home/node/app
ENV NODE_ENV production

EXPOSE 3000

COPY ./ /home/node/app/

USER node

ARG BASE_IMAGE=node:18.16.0-slim

################# Step 1 #################
FROM $BASE_IMAGE As builder-step
WORKDIR /home/node/app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

################# Step 2 #################
FROM $BASE_IMAGE as production-step

RUN apt-get update && apt-get install -y curl
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /home/node/app
COPY --chown=node:node --from=builder-step /home/node/app/dist ./dist
COPY --chown=node:node package*.json ./
COPY --chown=node:node tsconfig.json ./
RUN npm pkg delete scripts.prepare # Disable husky
RUN npm ci --omit=dev && npm cache clean --force

USER node

CMD ["node", "dist/index.js"]
FROM node:5.10.1

COPY package.json /src/package.json
RUN cd /src \
    && npm install --production
COPY app.js /src

EXPOSE 80 443
CMD ["node", "/src/app.js"]

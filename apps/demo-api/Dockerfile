FROM cgr.dev/chainguard/node@sha256:955b52dd59f8a73419fe1931e13a9b9eb822e7e5fda21ca754688b55753ea6ca AS runtime

WORKDIR /app
ENV NODE_ENV=production
ENV PORT=8080

COPY package.json ./
COPY src ./src

EXPOSE 8080

CMD ["src/server.js"]

FROM node:22

WORKDIR /app

# Bake the MongoDB driver into the agent's container so a script in /app can
# `require("mongodb")` / `import { MongoClient } from "mongodb"` with no install.
RUN npm init -y >/dev/null 2>&1 \
    && npm install mongodb@6 >/dev/null 2>&1

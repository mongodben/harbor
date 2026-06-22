#!/bin/bash
set -euo pipefail

# Reference solution: aggregate app.orders with the mongodb driver and write the
# sorted totals to /app/item_totals.json. .mjs so the ESM `import` works; the
# driver resolves from /app/node_modules (baked into the image).
cat > /app/compute.mjs <<'JS'
import { MongoClient } from "mongodb";
import { writeFileSync } from "node:fs";

const client = new MongoClient("mongodb://mongo:27017");
await client.connect();
try {
  const orders = client.db("app").collection("orders");
  const aggregated = await orders
    .aggregate([
      { $group: { _id: "$item", total: { $sum: "$qty" } } },
      { $sort: { _id: 1 } },
    ])
    .toArray();
  const result = aggregated.map((row) => ({ item: row._id, total: row.total }));
  writeFileSync("/app/item_totals.json", JSON.stringify(result, null, 2));
} finally {
  await client.close();
}
JS

node /app/compute.mjs

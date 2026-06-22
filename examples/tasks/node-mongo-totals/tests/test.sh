#!/bin/bash
# Binary reward. Runs in shared mode inside the agent's Node container, so it
# reads /app/item_totals.json directly and scores with node (always present).
# The expected totals are derived from the fixed seed in
# environment/mongo/seed/01-seed.js, so no DB query is needed here.
set -uo pipefail

node - <<'JS'
const fs = require("fs");

const REWARD_PATH = "/logs/verifier/reward.txt";
const OUTPUT_PATH = "/app/item_totals.json";

function fail(message) {
  console.error("FAIL: " + message);
  fs.writeFileSync(REWARD_PATH, "0");
  process.exit(1);
}

// Expected aggregation of the seed (apple: 3+4, banana: 5+1, cherry: 2),
// sorted by item ascending.
const expected = [
  { item: "apple", total: 7 },
  { item: "banana", total: 6 },
  { item: "cherry", total: 2 },
];

let raw;
try {
  raw = fs.readFileSync(OUTPUT_PATH, "utf8");
} catch {
  fail(`${OUTPUT_PATH} was not created`);
}

let data;
try {
  data = JSON.parse(raw);
} catch {
  fail(`${OUTPUT_PATH} is not valid JSON`);
}

if (!Array.isArray(data)) {
  fail("expected a JSON array");
}

// Normalize to {item, total} sorted by item so document order/extra keys
// in the agent's output don't matter; types must still match (number total).
const normalized = data
  .map((row) => ({ item: row && row.item, total: row && row.total }))
  .sort((a, b) => String(a.item).localeCompare(String(b.item)));

if (JSON.stringify(normalized) !== JSON.stringify(expected)) {
  fail("item totals do not match expected. got: " + JSON.stringify(normalized));
}

console.log("PASS: item totals correct");
fs.writeFileSync(REWARD_PATH, "1");
JS

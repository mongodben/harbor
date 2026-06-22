// Runs via mongosh on first startup. Multiple orders per item so that the
// per-item totals are a real aggregation (apple: 3+4=7, banana: 5+1=6, cherry: 2).
db = db.getSiblingDB("app");
db.orders.insertMany([
  { item: "apple", qty: 3 },
  { item: "banana", qty: 5 },
  { item: "cherry", qty: 2 },
  { item: "apple", qty: 4 },
  { item: "banana", qty: 1 },
]);
print("seeded app.orders with " + db.orders.countDocuments() + " documents");

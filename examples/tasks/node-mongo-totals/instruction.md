A MongoDB instance is running at `mongodb://mongo:27017`. Its `app` database has an `orders` collection already populated with documents of the form:

```json
{ "item": "apple", "qty": 3 }
```

A single item may appear in multiple order documents.

Write and run a Node.js program that:

1. Connects to `mongodb://mongo:27017` and reads every document in `app.orders`.
2. Computes, for each distinct `item`, the total `qty` summed across all of its orders.
3. Writes the result to `/app/item_totals.json`.

The output file must be a JSON **array**, sorted by `item` in ascending order, where each element is an object with exactly two fields:

```json
[
  { "item": "apple", "total": 7 },
  { "item": "banana", "total": 6 }
]
```

`total` must be a JSON number. The `mongodb` driver is already installed in `/app`, so `require("mongodb")` (or an ESM `import`) works from a script placed there.

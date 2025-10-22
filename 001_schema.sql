PRAGMA foreign_keys = ON;

-- 1) Core master data
CREATE TABLE stores (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  sku TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  category TEXT
);

-- 2) Store-specific product location (planogram)
-- One product can have at most one defined shelf location per store
CREATE TABLE planogram_locations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  aisle INTEGER NOT NULL,
  bay   INTEGER NOT NULL,
  shelf INTEGER NOT NULL,
  facing INTEGER NOT NULL DEFAULT 1,
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(store_id, product_id),
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 3) Inventory snapshots (time series)
CREATE TABLE inventory_snapshots (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  shelf_qty INTEGER NOT NULL CHECK(shelf_qty >= 0),
  backroom_qty INTEGER NOT NULL CHECK(backroom_qty >= 0),
  ts TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX_store_product_ts INTEGER,
  UNIQUE(id) -- no-op, clarifies PK uniqueness
);

-- 4) Operational alerts (e.g., low_stock, misplaced)
CREATE TABLE alerts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  type TEXT NOT NULL CHECK(type IN ('low_stock','misplaced','phantom','stockout')),
  severity TEXT NOT NULL CHECK(severity IN ('Low','Med','High')),
  status TEXT NOT NULL CHECK(status IN ('Open','Assigned','Resolved')) DEFAULT 'Open',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  resolved_at TEXT,
  resolved_by INTEGER, -- FK to users.id when you add staff resolution
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 5) Shelf audits (manual counts + evidence)
CREATE TABLE audits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  store_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  counted_qty INTEGER NOT NULL CHECK(counted_qty >= 0),
  photo_url TEXT,
  created_by INTEGER, -- FK to users.id
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 6) Users (staff/admin). Keep minimal for demo.
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  role  TEXT NOT NULL CHECK(role IN ('admin','staff'))
);

-- 7) Many-to-many: users assigned to multiple stores (and vice versa)
CREATE TABLE user_store_assignments (
  user_id INTEGER NOT NULL,
  store_id INTEGER NOT NULL,
  PRIMARY KEY (user_id, store_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE
);

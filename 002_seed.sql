-- Stores
INSERT INTO stores (name) VALUES
  ('Brookvale Superstore'),
  ('City Centre MiniMart');

-- Products
INSERT INTO products (sku, name, category) VALUES
  ('12345','Parboiled Rice 1kg','Grains'),
  ('23456','Baked Beans 410g','Canned'),
  ('34567','Sunflower Oil 2L','Oils');

-- Planogram locations (one per product per store)
INSERT INTO planogram_locations (store_id, product_id, aisle, bay, shelf, facing) VALUES
  (1, 1, 7, 3, 2, 2),
  (1, 2, 5, 2, 1, 3),
  (1, 3, 9, 4, 3, 2),
  (2, 1, 3, 1, 2, 1);

-- Inventory snapshots (simulate a “now” reading)
INSERT INTO inventory_snapshots (store_id, product_id, shelf_qty, backroom_qty) VALUES
  (1, 1, 6, 20),
  (1, 2, 1, 8),
  (1, 3, 0, 5),
  (2, 1, 2, 4);

-- Alerts (low stock, misplaced)
INSERT INTO alerts (store_id, product_id, type, severity, status) VALUES
  (1, 2, 'low_stock','High','Open'),
  (1, 3, 'stockout','Med','Open');

-- Users and store assignments
INSERT INTO users (email, role) VALUES
  ('alice@retailnav.io','admin'),
  ('sam@retailnav.io','staff');

INSERT INTO user_store_assignments (user_id, store_id) VALUES
  (1, 1), (1, 2), -- Admin across both stores
  (2, 1);        -- Staff assigned to Store 1 only

-- Audits (manual counts)
INSERT INTO audits (store_id, product_id, counted_qty, photo_url, created_by) VALUES
  (1, 2, 0, 'https://example.com/photos/beans-empty.jpg', 2);

-- ============================================================================
-- Truxify migration: add referential integrity for critical business entities
-- ============================================================================
-- This migration is idempotent. It only adds the foreign keys if they do not
-- already exist, so it can be run safely on existing databases.

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'driver_details_user_id_fkey'
  ) THEN
    ALTER TABLE driver_details
      ADD CONSTRAINT driver_details_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'customer_stats_user_id_fkey'
  ) THEN
    ALTER TABLE customer_stats
      ADD CONSTRAINT customer_stats_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'trucks_driver_id_fkey'
  ) THEN
    ALTER TABLE trucks
      ADD CONSTRAINT trucks_driver_id_fkey
      FOREIGN KEY (driver_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'orders_customer_id_fkey'
  ) THEN
    ALTER TABLE orders
      ADD CONSTRAINT orders_customer_id_fkey
      FOREIGN KEY (customer_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'orders_driver_id_fkey'
  ) THEN
    ALTER TABLE orders
      ADD CONSTRAINT orders_driver_id_fkey
      FOREIGN KEY (driver_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE SET NULL;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'load_offers_customer_id_fkey'
  ) THEN
    ALTER TABLE load_offers
      ADD CONSTRAINT load_offers_customer_id_fkey
      FOREIGN KEY (customer_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'load_bids_load_id_fkey'
  ) THEN
    ALTER TABLE load_bids
      ADD CONSTRAINT load_bids_load_id_fkey
      FOREIGN KEY (load_id) REFERENCES load_offers(id)
      ON UPDATE CASCADE ON DELETE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'load_bids_driver_id_fkey'
  ) THEN
    ALTER TABLE load_bids
      ADD CONSTRAINT load_bids_driver_id_fkey
      FOREIGN KEY (driver_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ratings_customer_id_fkey'
  ) THEN
    ALTER TABLE ratings
      ADD CONSTRAINT ratings_customer_id_fkey
      FOREIGN KEY (customer_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ratings_driver_id_fkey'
  ) THEN
    ALTER TABLE ratings
      ADD CONSTRAINT ratings_driver_id_fkey
      FOREIGN KEY (driver_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ratings_order_display_id_fkey'
  ) THEN
    ALTER TABLE ratings
      ADD CONSTRAINT ratings_order_display_id_fkey
      FOREIGN KEY (order_display_id) REFERENCES orders(order_display_id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'wallet_transactions_driver_id_fkey'
  ) THEN
    ALTER TABLE wallet_transactions
      ADD CONSTRAINT wallet_transactions_driver_id_fkey
      FOREIGN KEY (driver_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'wallet_transactions_order_display_id_fkey'
  ) THEN
    ALTER TABLE wallet_transactions
      ADD CONSTRAINT wallet_transactions_order_display_id_fkey
      FOREIGN KEY (order_display_id) REFERENCES orders(order_display_id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'wallet_transactions_trip_display_id_fkey'
  ) THEN
    ALTER TABLE wallet_transactions
      ADD CONSTRAINT wallet_transactions_trip_display_id_fkey
      FOREIGN KEY (trip_display_id) REFERENCES trips(trip_display_id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'notifications_user_id_fkey'
  ) THEN
    ALTER TABLE notifications
      ADD CONSTRAINT notifications_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'support_tickets_user_id_fkey'
  ) THEN
    ALTER TABLE support_tickets
      ADD CONSTRAINT support_tickets_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES profiles(id)
      ON UPDATE CASCADE ON DELETE RESTRICT;
  END IF;
END
$$;

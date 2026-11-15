-- Local Ride Booking and Fare Ledger: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."rider" (
  "rider_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_rider" PRIMARY KEY ("rider_id")
);
CREATE TABLE portfolio."vehicle" (
  "vehicle_id" bigint NOT NULL,
  "plate" text NOT NULL,
  "make" text NOT NULL,
  "model" text NOT NULL,
  CONSTRAINT "pk_vehicle" PRIMARY KEY ("vehicle_id"),
  CONSTRAINT "uq_vehicle_0" UNIQUE ("plate")
);
CREATE TABLE portfolio."driver" (
  "driver_id" bigint NOT NULL,
  "vehicle_id" bigint NOT NULL,
  "display_name" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_driver" PRIMARY KEY ("driver_id")
);
CREATE TABLE portfolio."ride" (
  "ride_id" bigint NOT NULL,
  "rider_id" bigint NOT NULL,
  "driver_id" bigint NOT NULL,
  "booking_reference" text NOT NULL,
  "started_at" timestamptz NOT NULL,
  "fare" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_ride" PRIMARY KEY ("ride_id"),
  CONSTRAINT "uq_ride_0" UNIQUE ("booking_reference")
);
ALTER TABLE portfolio."driver" ADD CONSTRAINT "fk_driver_0" FOREIGN KEY ("vehicle_id") REFERENCES portfolio."vehicle" ("vehicle_id");
ALTER TABLE portfolio."ride" ADD CONSTRAINT "fk_ride_0" FOREIGN KEY ("rider_id") REFERENCES portfolio."rider" ("rider_id");
ALTER TABLE portfolio."ride" ADD CONSTRAINT "fk_ride_1" FOREIGN KEY ("driver_id") REFERENCES portfolio."driver" ("driver_id");
ALTER TABLE portfolio."ride" ADD CONSTRAINT "ride_fare_nonnegative" CHECK ("fare" >= 0);
COMMIT;

-- Fictional sample records for Local Ride Booking and Fare Ledger.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."rider" ("rider_id", "display_name", "created_at") VALUES (1001, 'Avery Chen', '2026-10-01T09:15:00Z');
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model") VALUES (2001, 'RIDE-204', 'Toyota', 'Corolla');
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active") VALUES (3001, 2001, 'Jordan Lee', TRUE);
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare") VALUES (4001, 1001, 3001, 'BK-2026-1001', '2026-10-15T08:30:00-04:00', 18.75);
COMMIT;

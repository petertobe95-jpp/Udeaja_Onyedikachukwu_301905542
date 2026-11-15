-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. rider pk test. Expected: pk_rider, SQLSTATE 23505.
INSERT INTO portfolio."rider" ("rider_id", "display_name", "created_at")
VALUES (1001, 'Morgan Reed', '2026-10-20T10:00:00Z');

-- 2. rider id null test. Expected: rider_id, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "display_name", "created_at")
VALUES (NULL, 'Taylor Park', '2026-10-20T10:05:00Z');

-- 3. rider name null test. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "display_name", "created_at")
VALUES (5001, NULL, '2026-10-20T10:10:00Z');

-- 4. rider created null test. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."rider" ("rider_id", "display_name", "created_at")
VALUES (5002, 'Sam Rivera', NULL);

-- 5. vehicle pk test. Expected: pk_vehicle, SQLSTATE 23505.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (2001, 'RIDE-305', 'Honda', 'Civic');

-- 6. vehicle unique test. Expected: uq_vehicle_0, SQLSTATE 23505.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (5003, 'RIDE-204', 'Honda', 'Civic');

-- 7. vehicle id null test. Expected: vehicle_id, SQLSTATE 23502.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (NULL, 'RIDE-506', 'Ford', 'Focus');

-- 8. vehicle plate null test. Expected: plate, SQLSTATE 23502.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (5004, NULL, 'Ford', 'Focus');

-- 9. vehicle make null test. Expected: make, SQLSTATE 23502.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (5005, 'RIDE-507', NULL, 'Focus');

-- 10. vehicle model null test. Expected: model, SQLSTATE 23502.
INSERT INTO portfolio."vehicle" ("vehicle_id", "plate", "make", "model")
VALUES (5006, 'RIDE-508', 'Ford', NULL);

-- 11. driver pk test. Expected: pk_driver, SQLSTATE 23505.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (3001, 2001, 'Casey Quinn', TRUE);

-- 12. driver fk test. Expected: fk_driver_0, SQLSTATE 23503.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (5007, 2999, 'Robin Gray', TRUE);

-- 13. driver id null test. Expected: driver_id, SQLSTATE 23502.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (NULL, 2001, 'Dana Bell', TRUE);

-- 14. driver vehicle null test. Expected: vehicle_id, SQLSTATE 23502.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (5008, NULL, 'Dana Bell', TRUE);

-- 15. driver name null test. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (5009, 2001, NULL, TRUE);

-- 16. driver active null test. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."driver" ("driver_id", "vehicle_id", "display_name", "active")
VALUES (5010, 2001, 'Alex Kim', NULL);

-- 17. ride pk test. Expected: pk_ride, SQLSTATE 23505.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (4001, 1001, 3001, 'BK-2026-9001', '2026-10-20T11:00:00Z', 12.5);

-- 18. ride unique test. Expected: uq_ride_0, SQLSTATE 23505.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5011, 1001, 3001, 'BK-2026-1001', '2026-10-20T11:10:00Z', 12.5);

-- 19. ride rider fk test. Expected: fk_ride_0, SQLSTATE 23503.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5012, 1999, 3001, 'BK-2026-5012', '2026-10-20T11:15:00Z', 12.5);

-- 20. ride driver fk test. Expected: fk_ride_1, SQLSTATE 23503.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5013, 1001, 3999, 'BK-2026-5013', '2026-10-20T11:20:00Z', 12.5);

-- 21. ride id null test. Expected: ride_id, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (NULL, 1001, 3001, 'BK-2026-5014', '2026-10-20T11:25:00Z', 12.5);

-- 22. ride rider null test. Expected: rider_id, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5015, NULL, 3001, 'BK-2026-5015', '2026-10-20T11:30:00Z', 12.5);

-- 23. ride driver null test. Expected: driver_id, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5016, 1001, NULL, 'BK-2026-5016', '2026-10-20T11:35:00Z', 12.5);

-- 24. ride reference null test. Expected: booking_reference, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5017, 1001, 3001, NULL, '2026-10-20T11:40:00Z', 12.5);

-- 25. ride started null test. Expected: started_at, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5018, 1001, 3001, 'BK-2026-5018', NULL, 12.5);

-- 26. ride fare null test. Expected: fare, SQLSTATE 23502.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5019, 1001, 3001, 'BK-2026-5019', '2026-10-20T11:45:00Z', NULL);

-- 27. ride check test. Expected: ride_fare_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."ride" ("ride_id", "rider_id", "driver_id", "booking_reference", "started_at", "fare")
VALUES (5020, 1001, 3001, 'BK-2026-5020', '2026-10-20T11:50:00Z', -1);

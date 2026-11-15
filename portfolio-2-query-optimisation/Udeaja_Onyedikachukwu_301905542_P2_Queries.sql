-- Show related ride, driver, vehicle records (up to 20).
SELECT t0."ride_id" AS "ride_ride_id",
       t0."booking_reference" AS "ride_booking_reference",
       t1."driver_id" AS "driver_driver_id",
       t1."display_name" AS "driver_display_name",
       t2."vehicle_id" AS "vehicle_vehicle_id",
       t2."plate" AS "vehicle_plate"
FROM portfolio."ride" t0
JOIN portfolio."driver" t1 ON t0."driver_id" = t1."driver_id"
JOIN portfolio."vehicle" t2 ON t1."vehicle_id" = t2."vehicle_id"
ORDER BY t0."ride_id", t1."driver_id", t2."vehicle_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."ride_id" AS "ride_ride_id",
       t0."booking_reference" AS "ride_booking_reference",
       t1."driver_id" AS "driver_driver_id",
       t1."display_name" AS "driver_display_name",
       t2."vehicle_id" AS "vehicle_vehicle_id",
       t2."plate" AS "vehicle_plate"
FROM portfolio."ride" t0
JOIN portfolio."driver" t1 ON t0."driver_id" = t1."driver_id"
JOIN portfolio."vehicle" t2 ON t1."vehicle_id" = t2."vehicle_id"
ORDER BY t0."ride_id", t1."driver_id", t2."vehicle_id"
LIMIT 20;

-- Find ride records where started_at matches "2026-10-15T08:30:00-04:00" (up to 20).
SELECT * FROM portfolio."ride"
WHERE "started_at" IS NOT DISTINCT FROM '2026-10-15T08:30:00-04:00'
ORDER BY "ride_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."ride"
WHERE "started_at" IS NOT DISTINCT FROM '2026-10-15T08:30:00-04:00'
ORDER BY "ride_id"
LIMIT 20;

-- Count ride records for each rider_id (up to 20 groups).
SELECT "rider_id", count(*) AS record_count
FROM portfolio."ride"
GROUP BY "rider_id"
ORDER BY record_count DESC, "rider_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "rider_id", count(*) AS record_count
FROM portfolio."ride"
GROUP BY "rider_id"
ORDER BY record_count DESC, "rider_id" NULLS LAST
LIMIT 20;

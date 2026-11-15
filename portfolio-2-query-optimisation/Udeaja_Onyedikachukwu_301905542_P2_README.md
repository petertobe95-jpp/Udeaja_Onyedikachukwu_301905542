# Local Ride Booking and Fare Ledger — SQL queries

## 1. Show related ride, driver, vehicle records (up to 20).

```sql
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
```

| ride_ride_id | ride_booking_reference | driver_driver_id | driver_display_name | vehicle_vehicle_id | vehicle_plate |
| --- | --- | --- | --- | --- | --- |
| 4001 | BK-2026-1001 | 3001 | Jordan Lee | 2001 | RIDE-204 |

## 2. Find ride records where started_at matches "2026-10-15T08:30:00-04:00" (up to 20).

```sql
SELECT * FROM portfolio."ride"
WHERE "started_at" IS NOT DISTINCT FROM '2026-10-15T08:30:00-04:00'
ORDER BY "ride_id"
LIMIT 20;
```

| ride_id | rider_id | driver_id | booking_reference | started_at | fare |
| --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 3001 | BK-2026-1001 | 2026-10-15T12:30:00+00:00 | 18.75 |

## 3. Count ride records for each rider_id (up to 20 groups).

```sql
SELECT "rider_id", count(*) AS record_count
FROM portfolio."ride"
GROUP BY "rider_id"
ORDER BY record_count DESC, "rider_id" NULLS LAST
LIMIT 20;
```

| rider_id | record_count |
| --- | --- |
| 1001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.995 | 2.265, 0.993, 0.995 | Sort → Seq Scan | 112 |
| After index | 0.215 | 0.215, 0.25, 0.183 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.995 ms to 0.215 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.22..2.222 rows=20 loops=1)
  Seq Scan on ride (actual time=0.131..2.162 rows=20 loops=1)
Planning Time: 0.506 ms
Execution Time: 2.265 ms
```

### Before index, run 2

```text
Sort (actual time=0.964..0.965 rows=20 loops=1)
  Seq Scan on ride (actual time=0.014..0.931 rows=20 loops=1)
Planning Time: 0.328 ms
Execution Time: 0.993 ms
```

### Before index, run 3

```text
Sort (actual time=0.964..0.965 rows=20 loops=1)
  Seq Scan on ride (actual time=0.015..0.929 rows=20 loops=1)
Planning Time: 0.354 ms
Execution Time: 0.995 ms
```

### After index, run 1

```text
Sort (actual time=0.158..0.159 rows=20 loops=1)
  Bitmap Heap Scan on ride (actual time=0.057..0.122 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.04..0.041 rows=20 loops=1)
Planning Time: 0.517 ms
Execution Time: 0.215 ms
```

### After index, run 2

```text
Sort (actual time=0.151..0.153 rows=20 loops=1)
  Bitmap Heap Scan on ride (actual time=0.046..0.114 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.029..0.029 rows=20 loops=1)
Planning Time: 0.519 ms
Execution Time: 0.25 ms
```

### After index, run 3

```text
Sort (actual time=0.125..0.126 rows=20 loops=1)
  Bitmap Heap Scan on ride (actual time=0.029..0.088 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.017..0.017 rows=20 loops=1)
Planning Time: 0.553 ms
Execution Time: 0.183 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Udeaja_Onyedikachukwu_301905542_P2_Queries.sql, then Udeaja_Onyedikachukwu_301905542_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Udeaja_Onyedikachukwu_301905542_P2_QueryResults.png) · [Index comparison](screenshots/Udeaja_Onyedikachukwu_301905542_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


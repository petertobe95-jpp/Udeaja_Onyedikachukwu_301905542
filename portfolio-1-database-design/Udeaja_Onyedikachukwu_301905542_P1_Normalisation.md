# Local Ride Booking and Fare Ledger — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| rider_id | ride records (list) |
| --- | --- |
| 1001 | [4001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| ride.ride_id | ride.rider_id | ride.driver_id | ride.booking_reference | rider.rider_id | rider.display_name | driver.driver_id | driver.vehicle_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 3001 | BK-2026-1001 | 1001 | Avery Chen | 3001 | 2001 |

Key: ride_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## ride_example

| ride.ride_id | ride.rider_id | ride.driver_id | ride.booking_reference | rider.rider_id | rider.display_name | driver.driver_id | driver.vehicle_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 3001 | BK-2026-1001 | 1001 | Avery Chen | 3001 | 2001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## rider

| rider_id | display_name | created_at |
| --- | --- | --- |
| 1001 | Avery Chen | 2026-10-01T09:15:00+00:00 |

## vehicle

| vehicle_id | plate | make | model |
| --- | --- | --- | --- |
| 2001 | RIDE-204 | Toyota | Corolla |

## driver

| driver_id | vehicle_id | display_name | active |
| --- | --- | --- | --- |
| 3001 | 2001 | Jordan Lee | true |

## ride

| ride_id | rider_id | driver_id | booking_reference | started_at | fare |
| --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 3001 | BK-2026-1001 | 2026-10-15T12:30:00+00:00 | 18.75 |

## Dependencies

- rider: (rider_id) → display_name, created_at
- vehicle: (vehicle_id) → plate, make, model
- driver: (driver_id) → vehicle_id, display_name, active
- ride: (ride_id) → rider_id, driver_id, booking_reference, started_at, fare

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.

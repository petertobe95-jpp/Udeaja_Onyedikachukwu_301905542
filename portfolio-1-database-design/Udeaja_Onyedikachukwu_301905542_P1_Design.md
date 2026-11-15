# Local Ride Booking and Fare Ledger — database design

My case study records rider, vehicle, driver, ride.

## Users

- Riders booking trips and viewing their ride details.
- Dispatch staff assigning drivers and reviewing fare summaries.

## Main operations

- Create a rider and that rider's ride in one atomic transaction.
- Query daily ride counts and fare totals grouped by driver.
- Benchmark a date-range ride query using 20,000 synthetic ride rows, comparing otherwise identical runs with and without a B-tree index on started_at; verify equivalent results.

## Entities

| Entity | Information stored |
| --- | --- |
| rider | Stores a person who books rides. |
| vehicle | Stores a vehicle available for ride assignments. |
| driver | Stores a driver and the vehicle assigned to that driver. |
| ride | Records a rider's booking, assigned driver, start time, and fare. |

## rider

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| rider_id | BIGINT | PK | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |


## vehicle

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| vehicle_id | BIGINT | PK | Yes |
| plate | TEXT | Unique | Yes |
| make | TEXT |  | Yes |
| model | TEXT |  | Yes |
- Unique key: (plate).

## driver

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| driver_id | BIGINT | PK | Yes |
| vehicle_id | BIGINT | FK | Yes |
| display_name | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |
- vehicle_id → vehicle.vehicle_id

## ride

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| ride_id | BIGINT | PK | Yes |
| rider_id | BIGINT | FK | Yes |
| driver_id | BIGINT | FK | Yes |
| booking_reference | TEXT | Unique | Yes |
| started_at | TIMESTAMPTZ |  | Yes |
| fare | NUMERIC(18,2) |  | Yes |
- rider_id → rider.rider_id
- driver_id → driver.driver_id
- Unique key: (booking_reference).

## Relationships and business rules

- Every vehicle plate must be unique.
- Each driver must reference an existing vehicle.
- Each ride must reference an existing rider.
- Each ride must reference an existing driver.
- A ride fare must be zero or greater.
- A booking reference can identify only one ride, including during concurrent booking attempts.

## Assumptions

- Each entity uses a UUID primary key from a shared namespace, so key values are globally unique across tables.
- All listed entity fields are required; fare is recorded in one consistent currency, with no currency conversion modeled.
- A booking reference uniquely identifies a booking request, including when concurrent submissions occur.
- A ride's started_at timestamp determines its calendar day for daily reporting.
- Ride events embed snapshots of the ride, rider, driver, and vehicle as known when each event is recorded.


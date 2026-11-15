# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection ride_events for ride_created and ride_completed events. These are fictional event examples based on ride, rider, driver, vehicle.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related rider, driver, vehicle details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "ride_created",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "ride",
        "key": {
            "ride_id": 4001
        },
        "snapshot": {
            "ride_id": 4001,
            "rider_id": 1001,
            "driver_id": 3001,
            "booking_reference": "BK-2026-1001",
            "started_at": "2026-10-15T08:30:00-04:00",
            "fare": 18.75
        }
    },
    "embedded": {
        "rider": [
            {
                "key": {
                    "rider_id": 1001
                },
                "snapshot": {
                    "rider_id": 1001,
                    "display_name": "Avery Chen",
                    "created_at": "2026-10-01T09:15:00Z"
                },
                "via": [
                    "ride.rider_id → rider"
                ]
            }
        ],
        "driver": [
            {
                "key": {
                    "driver_id": 3001
                },
                "snapshot": {
                    "driver_id": 3001,
                    "vehicle_id": 2001,
                    "display_name": "Jordan Lee",
                    "active": true
                },
                "via": [
                    "ride.driver_id → driver"
                ]
            }
        ],
        "vehicle": [
            {
                "key": {
                    "vehicle_id": 2001
                },
                "snapshot": {
                    "vehicle_id": 2001,
                    "plate": "RIDE-204",
                    "make": "Toyota",
                    "model": "Corolla"
                },
                "via": [
                    "ride.driver_id → driver.vehicle_id → vehicle"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("ride_events").find({"eventType":"ride_created"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ride_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ride_id": 4001
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("ride_events").find({"source.key.ride_id":4001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ride_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ride_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "ride_completed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "ride_id": 4001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("ride_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ride_created",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ride_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "ride_completed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "ride_id": 4001
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("ride_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| ride_completed | 1 |
| ride_created | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Udeaja_Onyedikachukwu_301905542_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Udeaja_Onyedikachukwu_301905542_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)


// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("ride_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("ride_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "ride_created",
                    "ride_completed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "ride"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "ride_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("ride_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ride_completed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "ride",
                    "key": {
                        "ride_id": 4001
                    },
                    "field": "fare",
                    "value": 18.75
                },
                {
                    "entity": "ride",
                    "key": {
                        "ride_id": 4001
                    },
                    "field": "started_at",
                    "value": "2026-10-15T08:30:00-04:00"
                }
            ]
        }
    }
]));
  await db.getCollection("ride_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("ride_events").find({"eventType":"ride_created"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("ride_events").find({"source.key.ride_id":4001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("ride_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("ride_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("ride_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("ride_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("ride_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });

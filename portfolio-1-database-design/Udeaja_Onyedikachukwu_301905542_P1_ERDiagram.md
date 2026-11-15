# Local Ride Booking and Fare Ledger — ER diagram

```mermaid
erDiagram
    direction LR
    rider {
        bigint rider_id PK
        text display_name
        timestamptz created_at
    }
    vehicle {
        bigint vehicle_id PK
        text plate UK
        text make
        text model
    }
    driver {
        bigint driver_id PK
        bigint vehicle_id FK
        text display_name
        boolean active
    }
    ride {
        bigint ride_id PK
        bigint rider_id FK
        bigint driver_id FK
        text booking_reference UK
        timestamptz started_at
        numeric fare
    }
    vehicle ||--o{ driver : "vehicle_id"
    rider ||--o{ ride : "rider_id"
    driver ||--o{ ride : "driver_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Udeaja_Onyedikachukwu_301905542_ERDiagram.png)

-- tables

CREATE TABLE history (
    event_uri VARCHAR PRIMARY KEY,
    event_type VARCHAR NOT NULL,
    username VARCHAR NOT NULL,
    resource_uri VARCHAR NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL
);

-- users and permissions

CREATE USER camel WITH PASSWORD 'camel';

GRANT SELECT, INSERT ON history TO camel;

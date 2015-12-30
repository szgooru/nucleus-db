-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/Create_Auth_Tables.sql

-- Information about api consumer
CREATE TABLE auth_client (
    client_id varchar(36) NOT NULL,
    name varchar(256) NOT NULL,
    url varchar(2000),
    client_key varchar(64) NOT NULL,
    description varchar(5000),
    contact_email varchar(256),
    access_token_validity int NOT NULL,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    grant_types jsonb NOT NULL,
    referer_domains jsonb,
    PRIMARY KEY (client_id)
);

-- Created index on client_key
CREATE INDEX auth_client_client_id_idx ON auth_client (client_key);

-- Information about google drive connect
CREATE TABLE google_drive_connect (
    user_id varchar(36) NOT NULL,
    connected_email_id varchar(256) NOT NULL,
    refresh_token varchar(2000) NOT NULL,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (user_id)
);


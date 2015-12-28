-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V6__Create_User_Tables.sql

CREATE TYPE user_identity_type AS ENUM ('google', 'wsfed','saml', 'credential');
CREATE TYPE user_identity_status AS ENUM ('active', 'deactived', 'deleted');
CREATE TYPE user_gender AS ENUM ('male', 'female','other', 'not_wise_to_share');
CREATE TYPE user_category AS ENUM ('Teacher', 'Student', 'Parent', 'Other');

-- Information about user
CREATE TABLE "user" (
    user_id varchar(36) NOT NULL,
    firstname varchar(100),
    lastname varchar(100),
    parent_user_id varchar(36) NOT NULL,
    user_category user_category NOT NULL,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified_by varchar(36) NOT NULL,
    last_login timestamp,
    birth_date timestamp,
    grade jsonb,
    thumbnail_path varchar(1000),
    gender user_gender  NULL,
    about_me varchar(5000),
    school_id varchar(36),
    school_district_id varchar(36),
    email varchar(256),
    country_id bigserial,
    state_id bigserial,
    PRIMARY KEY (user_id),
    UNIQUE (email)
);


-- Index based on user country to list users for a given country
CREATE INDEX user_country_id_idx ON "user" (country_id);

-- Created index on parent_user_id
CREATE INDEX user_parent_user_id_idx ON "user" (parent_user_id);

-- Index based on user school district to list users for a given school district
CREATE INDEX user_school_district_id_idx ON "user" (school_district_id);

-- Index based on user school to list users for a given school
CREATE INDEX user_school_id_idx ON "user" (school_id);

-- Index based on user state to list users for a given state
CREATE INDEX user_state_id_idx ON "user" (state_id);

-- Index based on user category to list users for a given category
CREATE INDEX user_category_id_idx ON "user" (user_category);

-- Inverted index on grade for a given user
CREATE INDEX user_grade_gin ON "user"  USING gin (grade jsonb_path_ops);

-- Information about user identity
CREATE TABLE user_identity (
    identity_id bigserial NOT NULL,
    user_id varchar(36) NOT NULL,
    username varchar(32) NOT NULL,
    reference_id varchar(100),
    email_id varchar(256),
    password varchar(64),
    client_id varchar(36) NOT NULL,
    login_type user_identity_type NOT NULL,
    provision_type user_identity_type NOT NULL,
    email_confirm_status boolean NOT NULL DEFAULT FALSE,
    status user_identity_status NOT NULL,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (identity_id),
    UNIQUE(email_id),
    UNIQUE(reference_id),
    UNIQUE(username)
);

-- Created index on email_confirm_status
CREATE INDEX user_identity_email_confirm_status_idx ON user_identity (email_confirm_status);

-- Created index on password
CREATE INDEX user_identity_password_idx ON user_identity (password);

-- Index based on user identity status to list user identities for a given status
CREATE INDEX user_identity_status_idx ON user_identity (status);

-- Index based on user identity client id to list user identities for a given client id
CREATE INDEX user_identity_client_id_idx ON user_identity (client_id);

-- Index based on  user identity user id to list user identities for a given user id
CREATE INDEX user_identity_user_id_idx ON user_identity (user_id);

-- Information about user permission
CREATE TABLE user_permission (
    user_id varchar(36) NOT NULL,
    permission jsonb,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (user_id)
);

-- Information about user preference
CREATE TABLE user_preference (
    user_id varchar(36) NOT NULL,
    standard_preference jsonb NOT NULL,
    profile_visiblity boolean NOT NULL DEFAULT FALSE,
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (user_id)
);


-- Information about country
CREATE TABLE country (
    country_id bigserial NOT NULL,
    name varchar(2000) NOT NULL,
    code varchar(1000) NOT NULL,
    creator_id varchar(36),
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (country_id)
);

-- Index based on  country creator id to list countries for a given creator id
CREATE INDEX country_creator_id_idx ON country (creator_id);

-- Information about state
CREATE TABLE state (
    state_id bigint NOT NULL,
    country_id bigint NOT NULL,
    name varchar(2000) NOT NULL,
    code varchar(1000) NOT NULL,
    creator_id varchar(36),
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (state_id, country_id)
);

-- Index based on  state creator id to list states for a given creator id
CREATE INDEX state_creator_id_idx ON state (creator_id);

-- Information about school
CREATE TABLE school (
    school_id varchar(36) NOT NULL,
    school_district_id varchar(36)  NULL,
    name varchar(2000) NOT NULL,
    code varchar(1000) NOT NULL,
    creator_id varchar(36),
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (school_id)
);

-- Index based on  school creator id to list schools for a given creator id
CREATE INDEX school_creator_id_idx ON school (creator_id);

-- Index based on  school district  id to list schools for a given school district id
CREATE INDEX school_district_id_idx ON school (school_district_id);

-- Information about school district
CREATE TABLE school_district (
    school_district_id varchar(36) NOT NULL,
    name varchar(2000) NOT NULL,
    code varchar(1000) NOT NULL,
    creator_id varchar(36),
    created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
    PRIMARY KEY (school_district_id)
);

-- Index based on  school district creator id to list schools for a given creator id
CREATE INDEX school_district_creator_id_idx ON school_district (creator_id);

-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V5__Create_Class_Tables.sql


-- Information about user created class 
CREATE TABLE class (
 class_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 title varchar(5000) NOT NULL,
 description varchar(5000),
 greeting varchar(5000),
 grade varchar(5000) NOT NULL,
 sharing class_sharing NOT NULL,
 cover_image varchar(2000), 
 code varchar(36) NOT NULL,
 min_score smallint NOT NULL,
 end_time timestamp,
 course_id varchar(36),
 is_deleted boolean NOT NULL DEFAULT FALSE,
 collaborator JSONB,
 is_archived boolean NOT NULL DEFAULT FALSE,
 UNIQUE (code),
 PRIMARY KEY (class_id)
);

-- Inverted index on collaborator for a given class 
CREATE INDEX class_collaborator_gin ON course 
 USING gin (collaborator jsonb_path_ops);

-- Create index on creator id so we can show list of classes owned by the user
CREATE INDEX class_creator_id_idx ON 
 class (creator_id);

-- Create index on course id 
-- TBD - this may not be needed, but adding it for now
CREATE INDEX class_course_id_idx ON 
 class (course_id);


-- Information about members belonging to a class with invited, joined or pending
--status 
CREATE TABLE class_member (
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 class_id varchar(36) NOT NULL,
 user_id varchar(36) NOT NULL, 
 status class_member_status NOT NULL, 
 PRIMARY KEY (class_id, user_id) 
);

-- Index based on class id to list members for a given class
CREATE INDEX class_member_class_id_idx ON 
 class_member (class_id);


-- Index based on user id to list classess joined by a given user
CREATE INDEX class_member_user_id_idx ON 
 class_member (user_id);


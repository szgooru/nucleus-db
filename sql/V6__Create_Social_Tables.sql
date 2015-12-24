

-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V6__Create_Social_Tables.sql


--Stores information on the given user's "follower/following" network
CREATE TABLE user_network (
 user_id varchar(36) NOT NULL,
 follow_on_user_id varchar(36) NOT NULL, 
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY(user_id, follow_on_user_id)
); 



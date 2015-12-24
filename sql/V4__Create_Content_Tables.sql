
-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V4__Create_Content_Tables.sql

-- Information about resource ingested offline / created by the user
CREATE TABLE resource (
 id varchar(36) NOT NULL, 
 title varchar(5000) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),  
 creator_id varchar(36) NOT NULL,
 publish_date timestamp,
 description varchar(20000), 
 format resource_format NOT NULL, 
 thumbnail varchar(2000),
 url varchar(2000), 
 is_copyright_owner boolean NOT NULL DEFAULT FALSE,
 copyright_owner JSONB,  
 metadata JSONB,
 taxonomy JSONB,
 is_frame_breaker boolean DEFAULT FALSE,
 is_broken boolean DEFAULT FALSE,
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id),
 UNIQUE (url)
);

-- Index on owner to improve query performance of queries that provides list of 
--resources for a given user
CREATE INDEX resource_creator_id_idx ON 
 resource (creator_id);

-- Index on last modified to improve query performance of queries that 
--provides list of top N resources modified    
CREATE INDEX resource_modified_idx ON 
 resource (modified);

CREATE INDEX resource_title_idx ON 
 resource (title);


-- Information about question ingested offline / created by the user
CREATE TABLE question (
 id varchar(36) NOT NULL,
 short_title varchar(5000) NOT NULL,
 title varchar(20000) NOT NULL, 
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36) NOT NULL, 
 original_question_id varchar(36), 
 publish_date timestamp,
 format question_format NOT NULL,
 type question_type NOT NULL,
 explanation varchar(5000),
 hint JSONB NOT NULL,
 detail JSONB,
 answer JSONB NOT NULL,
 url varchar(2000),
 narration varchar(5000),
 metadata JSONB,
 taxonomy JSONB,
 depth_of_knowledge JSONB,
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
);

-- Index on owner to improve query performance of queries that provides lists of 
--resources for a given user.  

CREATE INDEX question_original_creator_id_idx ON 
 question (original_creator_id);

CREATE INDEX question_creator_id_idx ON 
 question (creator_id);

-- Index on last modified to improve query performance of queries that 
--provides list of top N questions modified   
CREATE INDEX question_modified_idx ON 
 question (modified);

CREATE INDEX question_short_title_idx ON 
 question (short_title);

-- Container for resources and/or questions with metadata information
CREATE TABLE collection (
 id varchar(36) NOT NULL, 
 title varchar(5000) NOT NULL, 
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36) NOT NULL,
 original_collection_id varchar(36),
 publish_date timestamp,
 thumbnail varchar(2000) NOT NULL,
 learning_objective varchar(20000) NOT NULL, 
 audience JSONB, 
 collaborator JSONB,
 metadata JSONB, 
 taxonomy JSONB, 
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
); 

CREATE INDEX collection_original_creator_id_idx ON 
 collection (original_creator_id);

CREATE INDEX collection_creator_id_idx ON 
 collection (creator_id);

-- Index on last modified to improve query performance of queries that 
--provides list of top N collections modified   
CREATE INDEX collection_modified_idx ON 
 collection (modified);

-- Create inverted index on collaborators JSONB doc, so we can search for a given user if 
--she is collaborating on a particular collection and it needs to be shown in 
--her workspace.
CREATE INDEX collection_collaborator_gin ON collection 
 USING gin (collaborator jsonb_path_ops);

CREATE INDEX collection_title_idx ON 
 collection (title);

-- Container for a sequenced set of resources or questions belonging to a collection 
CREATE TABLE collection_item (
 id varchar(36) NOT NULL, 
 collection_id varchar(36) NOT NULL, 
 resource_id varchar(36), 
 question_id varchar(36),
 sequence_id smallint NOT NULL, 
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 creator_id varchar(36) NOT NULL,
 narration varchar(5000), 
 metadata JSONB,
 taxonomy JSONB, 
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
 );

-- Index on collection id as we will be querying this table based on collection_id
CREATE INDEX collection_item_collection_id_idx ON 
 collection_item (collection_id);

-- Index on resource id 
CREATE INDEX collection_item_resource_id_idx ON 
 collection_item (resource_id);

-- Index on collection id and resource id combination for improving peformance of AND queries
CREATE INDEX collection_item_collection_id_resource_id_idx ON 
 collection_item (collection_id, resource_id);

-- Index on question id 
CREATE INDEX collection_item_question_id_idx ON 
 collection_item (question_id);

-- Index on collection id and question id combination for improving performance of AND queries 
CREATE INDEX collection_item_collection_id_question_id_idx ON 
 collection_item (collection_id, question_id);

-- Container for a questions with metadata and settings information 
CREATE TABLE assessment (
 id varchar(36) NOT NULL, 
 title varchar(5000) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36) NOT NULL, 
 original_assessment_id varchar(36),
 publish_date timestamp, 
 type assessment_type NOT NULL,
 url varchar(2000), 
 thumbnail varchar(2000), 
 learning_objective varchar(20000) NOT NULL, 
 audience JSONB, 
 collaborator JSONB, 
 metadata JSONB,
 taxonomy JSONB, 
 login_required boolean, 
 settings JSONB,
 graded_by grading_type NOT NULL,
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
);

-- Index on owner to improve query performance of queries that lists of assessments 
--for a given user.  
CREATE INDEX assessment_original_creator_id_idx ON 
 assessment (original_creator_id);

CREATE INDEX assessment_creator_id_idx ON 
 assessment (creator_id);

-- Index on last modified to improve query performance of queries that 
--provides list of top N collections modified   
CREATE INDEX assessment_modified_idx ON 
 assessment (modified);

-- Create inverted index on collaborators JSONB doc, so we can search for a given user if 
--she is collaborating on a particular assessment and it needs to be shown in 
--her workspace.
CREATE INDEX assessment_collaborator_gin ON assessment 
 USING gin (collaborator jsonb_path_ops);

CREATE INDEX assessment_title_idx ON 
 assessment (title);

-- Container for a sequenced set of questions belonging to an assessment 
CREATE TABLE assessment_item (
 id varchar(36) NOT NULL, 
 assessment_id varchar(36) NOT NULL,
 question_id varchar(36) NOT NULL,
 sequence_id smallint NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
);

-- Index on assessment id as we will be querying this table based on that key
CREATE INDEX assessment_item_assessment_id_idx ON 
 assessment_item (assessment_id);

-- Index on question id 
CREATE INDEX assessment_item_question_id_idx ON 
 assessment_item (question_id);

-- Index on assessment id and question id combination for improving peformance of AND queries
CREATE INDEX assessment_item_assessment_id_question_id_idx ON 
 assessment_item (assessment_id, question_id);

-- Information for the user course with metadata 
CREATE TABLE course (
 id varchar(36) NOT NULL,
 title varchar(5000) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36) NOT NULL, 
 original_course_id varchar(36),
 publish_date timestamp, 
 thumbnail varchar(2000), 
 audience JSONB,
 metadata JSONB,
 taxonomy JSONB,
 collaborator JSONB,
 class_list JSONB,
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
);

-- Index on course owner to show list of course belonging to a user

CREATE INDEX course_original_creator_id_idx ON 
 course (original_creator_id);

CREATE INDEX course_creator_id_idx ON 
 course (creator_id);

-- Index on last modified to improve query performance of queries that 
--provides list of top N courses modified last   
CREATE INDEX course_modified_idx ON 
 course (modified);

-- Create an inverted index on classes that this course is associated with. 
CREATE INDEX course_class_list_gin ON course 
 USING gin (class_list jsonb_path_ops);

-- Create an inverted index on collaborators on this course. 
CREATE INDEX course_collaborator_gin ON course 
 USING gin (collaborator jsonb_path_ops);

CREATE INDEX course_title_idx ON 
 course (title);

-- Container for user created course and unit information with metadata
CREATE TABLE course_unit(
 course_id varchar(36) NOT NULL,
 unit_id varchar(36) NOT NULL,
 title varchar(5000) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL, 
 original_creator_id varchar(36) NOT NULL, 
 original_unit_id varchar(36),
 big_ideas varchar(20000) NOT NULL,
 essential_questions varchar(20000) NOT NULL,
 metadata JSONB,
 taxonomy JSONB,
 sequence_id smallint NOT NULL,
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (course_id, unit_id)
);

-- Create index on course id to allow improved querying perf based on supplied course id
CREATE INDEX course_unit_course_id_idx ON 
 course_unit (course_id);

-- Container for user created course, unit and lesson information with metadata
CREATE TABLE course_unit_lesson(
 course_id varchar(36) NOT NULL,
 unit_id varchar(36) NOT NULL,
 lesson_id varchar(36) NOT NULL,
 title varchar(5000) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL, 
 original_creator_id varchar(36) NOT NULL, 
 original_lesson_id varchar(36),
 metadata JSONB,
 taxonomy JSONB,
 sequence_id smallint NOT NULL,
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (course_id, unit_id, lesson_id)
);

-- Create index on course id to allow improved querying perf based on supplied course id
CREATE INDEX course_unit_lesson_course_id_idx ON 
 course_unit_lesson (course_id);

-- Create index on course id to allow improved querying perf based on supplied course id and unit id
CREATE INDEX course_unit_lesson_course_id_unit_id_idx ON 
 course_unit_lesson (course_id, unit_id);

-- Container for user created course, unit and lesson and collection/assessment information with metadata
CREATE TABLE course_unit_lesson_collection_assessment (
 id varchar(36) NOT NULL, 
 course_id varchar(36) NOT NULL, 
 unit_id varchar(36) NOT NULL,
 lesson_id varchar(36) NOT NULL,
 collection_id varchar(36),
 assessment_id varchar(36),
 sequence_id smallint NOT NULL,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (id)
);
-- Create index on course, unit, lesson id to allow improved querying perf 
CREATE INDEX course_unit_lesson_collection_assessment_cul_id_idx ON 
 course_unit_lesson_collection_assessment (course_id, unit_id, lesson_id);

-- Create index on collection id to allow improved perf while joining based on collection_id 
CREATE INDEX course_unit_lesson_collection_assessment_collection_id_idx ON 
 course_unit_lesson_collection_assessment (collection_id);

-- Create index on assessment id to allow improved perf while joining based on assessment_id
CREATE INDEX course_unit_lesson_collection_assessment_assessment_id_idx ON 
 course_unit_lesson_collection_assessment (assessment_id);


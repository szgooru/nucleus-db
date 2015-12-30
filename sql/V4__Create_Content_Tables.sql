
-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V4__Create_Content_Tables.sql

-- Content format types
CREATE TYPE content_format AS ENUM ('resource', 'question');

-- Content format subtypes 
CREATE TYPE content_subformat AS ENUM ('video', 'webpage', 'interactive', 'image', 
 'text', 'audio', 'multiple_choice', 'multiple_answer', 
 'true_false', 'fill_in_the_blank', 'open_ended', 'hot_text_reorder', 
 'hot_text_highlight',  'hot_spot_image', 'hot_spot_text', 'external');

-- Content container types
CREATE TYPE content_container_type AS ENUM ('collection', 'assessment');

-- Grading type for assessments
CREATE TYPE grading_type AS ENUM ('system', 'teacher');

-- Location of the assessment -- legacy support
CREATE TYPE assessment_location AS ENUM ('internal', 'external');


-- Orientation of the content 
CREATE TYPE orientation AS ENUM ('teacher', 'student');


-- Information about content ingested offline / created by the user
CREATE TABLE content (
 content_id varchar(36) NOT NULL,
 title varchar(20000) NOT NULL,
 url varchar(2000),
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),  
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36) NOT NULL,
 original_content_id varchar(36),
 publish_date timestamp,
 short_title varchar(5000),
 narration varchar(5000),
 description varchar(20000), 
 content_format content_format NOT NULL,
 content_subformat content_subformat NOT NULL,
 answer JSONB,
 metadata JSONB,
 taxonomy JSONB,
 depth_of_knowledge JSONB,
 hint_explanation_detail varchar(20000),
 thumbnail varchar(2000),
 course_id varchar(36),
 unit_id varchar(36),
 lesson_id varchar(36),
 collection_id varchar(36),
 sequence_id smallint,
 is_copyright_owner boolean,
 copyright_owner JSONB,  
 visible_on_profile boolean NOT NULL DEFAULT FALSE,
 is_frame_breaker boolean DEFAULT FALSE,
 is_broken boolean DEFAULT FALSE,
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (content_id)
);

CREATE INDEX content_creator_id_idx ON 
 content (creator_id);

CREATE INDEX content_format_idx ON 
 content (content_format);
 
-- Index for filtering requirements on profile
CREATE INDEX content_title_idx ON 
 content (title);

-- Index for filtering requirements on profile
CREATE INDEX content_taxonomy_gin ON content
 USING gin (taxonomy jsonb_path_ops);

CREATE INDEX content_collection_id_idx ON 
 content (collection_id); 
 
CREATE INDEX content_course_id_unit_id_lesson_id_collection_id_idx ON 
 content (course_id, unit_id, lesson_id, collection_id);

-- Container for resources and/or questions or just questions with metadata information
CREATE TABLE collection (
 collection_id varchar(36) NOT NULL, 
 title varchar(5000) NOT NULL, 
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 accessed timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 creator_id varchar(36) NOT NULL,
 original_creator_id varchar(36),
 original_collection_id varchar(36),
 publish_date timestamp,
 content_container_type content_container_type NOT NULL,
 thumbnail varchar(2000),
 learning_objective varchar(20000), 
 audience JSONB, 
 collaborator JSONB,
 metadata JSONB, 
 taxonomy JSONB, 
 assessment_location assessment_location,
 orientation orientation NOT NULL DEFAULT 'student', 
 url varchar(2000), 
 login_required boolean, 
 setting JSONB,
 grading_type grading_type,
 visible_on_profile boolean NOT NULL DEFAULT FALSE,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (collection_id)
); 

CREATE INDEX collection_original_creator_id_idx ON 
 collection (original_creator_id);

CREATE INDEX collection_creator_id_idx ON 
 collection (creator_id);

-- Create inverted index on collaborators JSONB doc, so we can search for a given user if 
--she is collaborating on a particular collection and it needs to be shown in 
--her workspace.
CREATE INDEX collection_collaborator_gin ON collection 
 USING gin (collaborator jsonb_path_ops);

CREATE INDEX collection_title_idx ON 
 collection (title);

CREATE INDEX collection_content_container_type_idx ON 
 collection (content_container_type);
 
-- Information for the user course with metadata 
CREATE TABLE course (
 course_id varchar(36) NOT NULL,
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
 PRIMARY KEY (course_id)
);

CREATE INDEX course_original_creator_id_idx ON 
 course (original_creator_id);

CREATE INDEX course_creator_id_idx ON 
 course (creator_id);

-- Create an index on classes that this course is associated with. 
CREATE INDEX course_class_list_gin ON course 
 USING gin (class_list jsonb_path_ops);

-- Create an index on collaborators on this course. 
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

CREATE INDEX course_unit_lesson_course_id_idx ON 
 course_unit_lesson (course_id);

CREATE INDEX course_unit_lesson_course_id_unit_id_idx ON 
 course_unit_lesson (course_id, unit_id);

-- Container for user created course, unit and lesson and collection/assessment information with metadata
CREATE TABLE course_unit_lesson_collection (
 course_id varchar(36) NOT NULL, 
 unit_id varchar(36) NOT NULL,
 lesson_id varchar(36) NOT NULL,
 collection_id varchar(36) NOT NULL,
 sequence_id smallint NOT NULL,  
 is_deleted boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY (course_id, unit_id, lesson_id, collection_id)
);

CREATE INDEX course_unit_lesson_collection_cul_id_idx ON 
 course_unit_lesson_collection (course_id, unit_id, lesson_id);

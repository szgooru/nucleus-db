
-- You can run this command using the newly created nucleus user:
-- psql -U nucleus -f <path to>/V3__Create_Lookup_Tables.sql

-- Supported resource format 
CREATE TYPE resource_format AS ENUM ('video', 'webpage', 'interactive', 'image', 'text', 'audio');

-- Supported question format
CREATE TYPE question_format AS ENUM ('multiple_choice', 'multiple_answer', 
'true_false', 'fill_in_the_blank', 'open_ended', 'hot_text_reorder', 
'hot_text_highlight',  'hot_spot_image', 'hot_spot_text');

-- Supported sharing types 
CREATE TYPE sharing_type AS ENUM ('private', 'shared', 'public');

-- Supported class member status
CREATE TYPE class_member_status AS ENUM ('invited', 'pending', 'joined');

-- Supported classification type 
CREATE TYPE subject_classification_type AS ENUM ('K-12', 'Higher Education', 'Professional Learning');

-- Supported class visibility  
CREATE TYPE class_visibility AS ENUM ('open', 'restricted');

-- Type of assessment 
CREATE TYPE assessment_type AS ENUM ('internal', 'external');

-- Type of question 
CREATE TYPE question_type AS ENUM ('internal', 'external');


-- This enum lists out reference types supported in Gooru that the content is 
-- tagged to
-- Educational use: Information about whether the content is an article, book, 
-- game and so on
-- Moments of learning: Information about whether the content is meant for 
-- extending understanding, preparing the learning etc.
-- Depth of knowledge: Information about whether the question's depth of 
-- knowledge quotient whether it is intended for recall, strategic thinking etc.
-- Reading level: Information about whether the content intended to be 
-- consumed for a specific grade level
-- Audience: Information about whether the content is meant for all students, 
-- specific students etc. 
-- Advertisement level: Information about whether the content has some or more advertisements
-- Hazard level: Information about whether the content has flashing hazard, sound hazard etc.
-- Media feature: Information about whether the content has audio description, annotations etc. 
-- 21st Century skills: Content mapping to 21st century skills as defined by P21
CREATE TYPE metadata_reference_type AS ENUM ('educational_use', 'moments_of_learning', 
 'depth_of_knowledge', 'reading_level', 'audience', 'advertisement_level', 
 'hazard_level', 'media_feature');


-- Generic lookup for metadata_reference_type values
CREATE TABLE metadata_reference (
 id serial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 type metadata_reference_type NOT NULL,
 name varchar(2000) NOT NULL,
 sequence_id smallint NOT NULL,
 PRIMARY KEY(id)
); 



-- Stores the 21st century skill values
-- Values are bucketed based on keys and then may be attributed to 1 or more models
-- Model names are Hewlett Deeper Learning Model, Conley Four Keys, P21 Framework 
--and National Research Center for Life and Work
-- Key classification could be any of Key Cognitive Skills and Strategies, 
--Key Content Knowledge and Key Learning Skills and Techniques 
 
CREATE TABLE twenty_one_century_skill (
 id serial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
 key_classification varchar(2000) NOT NULL,
 value varchar(2000) NOT NULL, 
 sequence_id smallint NOT NULL,
 model0 varchar(2000),
 model1 varchar(2000),
 model2 varchar(2000),
 model3 varchar(2000),
 PRIMARY KEY(id)
); 

-- Generic table to store standards & learning target information
CREATE TABLE code (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL, 
 label varchar(5000) NOT NULL,
 parent_id bigint, 
 depth smallint, 
 root_node_id bigint,
 sequence_id smallint,
 --standard_framework_code_id varchar(2000) NOT NULL, -- flat reference or direct mapping to parent
 PRIMARY KEY(id)
);

-- Index on parent_id to enhance query performance
CREATE INDEX code_parent_id_idx ON 
 code (parent_id);

-- Index on root_node_id to enhance query performance
CREATE INDEX code_root_node_id_idx ON 
 code (root_node_id);

-- Index on code to enhance query performance
CREATE INDEX code_code_idx ON 
 code (code);

-- Taxonomy subject information 
CREATE TABLE taxonomy_subject (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000), 
 label varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 classification subject_classification_type NOT NULL,
 gooru_subject_id bigint NOT NULL,
 standard_framework_code_id bigint NOT NULL,  
 PRIMARY KEY(id)
);

-- Index on gooru_subject_id to enhance query performance
CREATE INDEX taxonomy_subject_gooru_subject_id_idx ON 
 taxonomy_subject (gooru_subject_id);

-- Index on standard_framework_code_id to enhance query performance
CREATE INDEX taxonomy_subject_standard_framework_code_id_idx ON 
 taxonomy_subject (standard_framework_code_id);

-- Taxonomy course information 
CREATE TABLE taxonomy_course (
 id bigserial NOT NULL,
 subject_id serial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 label varchar(2000) NOT NULL, 
 description varchar(5000), 
 grades varchar(2000),
 sequence_id smallint NOT NULL, 
 gooru_course_id bigint NOT NULL,
 standard_framework_code_id bigint NOT NULL,
 PRIMARY KEY(id)
);

-- Index on subject_id to enhance query performance
CREATE INDEX taxonomy_course_subject_id_idx ON 
 taxonomy_course (subject_id);

-- Index on gooru_course_id to enhance query performance
CREATE INDEX taxonomy_course_gooru_course_id_idx ON 
 taxonomy_course (gooru_course_id);

-- Index on standard_framework_code_id to enhance query performance
CREATE INDEX taxonomy_course_standard_framework_code_id_idx ON 
 taxonomy_course (standard_framework_code_id);


-- Taxonomy domain information 
CREATE TABLE taxonomy_domain (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 label varchar(2000) NOT NULL,
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 gooru_domain_id bigint NOT NULL,
 standard_framework_code_id bigint NOT NULL, 
 PRIMARY KEY(id)
);

-- Index on gooru_domain_id to enhance query performance
CREATE INDEX taxonomy_domain_gooru_domain_id_idx ON 
 taxonomy_domain (gooru_domain_id);

-- Index on standard_framework_code_id to enhance query performance
CREATE INDEX taxonomy_domain_standard_framework_code_id_idx ON 
 taxonomy_domain (standard_framework_code_id);

-- Mapping between taxonomy course and domain 
CREATE TABLE taxonomy_subdomain (
 id bigserial NOT NULL,
 course_id serial NOT NULL,
 domain_id serial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 name varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 gooru_subdomain_id bigint NOT NULL,
 standard_framework_code_id bigint NOT NULL,
 PRIMARY KEY(id)
);

-- Index on course_id, domain_id to enhance query performance
CREATE INDEX taxonomy_subdomain_course_id_domain_id_idx ON 
 taxonomy_subdomain (course_id, domain_id);

-- Index on course_id, domain_id to enhance query performance
CREATE INDEX taxonomy_subdomain_subdomain_id_idx ON 
 taxonomy_subdomain (gooru_subdomain_id);

-- Index on standard_framework_code_id to enhance query performance
CREATE INDEX taxonomy_subdomain_standard_framework_code_id_idx ON 
 taxonomy_subdomain (standard_framework_code_id);

-- Subdomain and standard mapping
CREATE TABLE subdomain_code (
 subdomain_id bigint NOT NULL,
 code_id bigint NOT NULL,
 PRIMARY KEY(subdomain_id, code_id)
);

-- GUT Standard mapping across frameworks
CREATE TABLE standard_mapping (
 id bigserial NOT NULL,
 gooru_subject varchar(2000) NOT NULL, -- should this be subject_id instead?  
 gooru_standard varchar(2000) NOT NULL, -- this has to be the gooru standard code for fast lookup
 ccss_standard varchar(2000) NOT NULL,
 cass_standard varchar(2000) NOT NULL,
 ngss_standard varchar(2000) NOT NULL,
 teks_standard varchar(2000) NOT NULL,
 c3_standard varchar(2000) NOT NULL,
 PRIMARY KEY(id)
);

-- Index on Gooru standard to enhance query performance
CREATE INDEX standard_mapping_gooru_subject_gooru_standard_idx ON 
 standard_mapping (gooru_subject, gooru_standard);

-- GUT Learning target mapping across frameworks
CREATE TABLE learning_target_mapping (
 id bigserial NOT NULL,
 gooru_subject varchar(2000) NOT NULL, 
 gooru_learning_target varchar(2000) NOT NULL,
 ccss_learning_target varchar(2000) NOT NULL,
 cass_learning_target varchar(2000) NOT NULL,
 ngss_learning_target varchar(2000) NOT NULL,
 teks_learning_target varchar(2000) NOT NULL,
 c3_learning_target varchar(2000) NOT NULL,
 PRIMARY KEY(id)
);

-- Index on Gooru standard to enhance query performance
CREATE INDEX learning_target_mapping_gooru_subject_gooru_learning_target_idx ON 
 learning_target_mapping (gooru_subject, gooru_learning_target);


---- Generic table to store learning target information
--CREATE TABLE learning_target (
 --id bigserial NOT NULL,
 --creator_id varchar(36) NOT NULL,
 --created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 --modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 --standard_id bigint NOT NULL,
 --code varchar(2000) NOT NULL,
 --display_code varchar(2000) NOT NULL, 
 --label varchar(5000) NOT NULL,
 --parent_id bigint, 
 --sequence_id smallint,
 --standard_framework_code varchar(2000) NOT NULL,
 --PRIMARY KEY(id)
--);

---- Index on standard_id to enhance query performance
--CREATE INDEX learning_target_standard_id_idx ON 
 --learning_target (standard_id);

---- Index on parent_id to enhance query performance
--CREATE INDEX learning_target_parent_id_idx ON 
 --learning_target (parent_id);

---- Index on root_node_id to enhance query performance
--CREATE INDEX learning_target_root_node_id_idx ON 
 --learning_target (root_node_id);

---- Index on learning target to enhance query performance
--CREATE INDEX learning_target_learning_target_idx ON 
 --learning_target (learning_target);




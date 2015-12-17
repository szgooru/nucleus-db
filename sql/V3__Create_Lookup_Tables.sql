
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
 label varchar(2000) NOT NULL,
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
 label varchar(2000) NOT NULL, 
 sequence_id smallint NOT NULL,
 model0 varchar(2000),
 model1 varchar(2000),
 model2 varchar(2000),
 model3 varchar(2000),
 PRIMARY KEY(id)
); 

-- Taxonomy subject information 
CREATE TABLE taxonomy_subject (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000), 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 classification subject_classification_type NOT NULL,
 taxonomy_default_subject_id bigint NOT NULL,
 standards_framework_code varchar(2000) NOT NULL,
 standards_framework_name varchar(2000) NOT NULL,  
 PRIMARY KEY(id)
);

-- Index on taxonomy_default_subject_id to enhance query performance
CREATE INDEX taxonomy_subject_taxonomy_default_subject_id_idx ON 
 taxonomy_subject (taxonomy_default_subject_id);

-- Index on standards_framework_code to enhance query performance
CREATE INDEX taxonomy_subject_standards_framework_code_idx ON 
 taxonomy_subject (standards_framework_code);

-- Taxonomy course information 
CREATE TABLE taxonomy_course (
 id bigserial NOT NULL,
 taxonomy_subject_id bigint NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 grades varchar(2000),
 sequence_id smallint NOT NULL, 
 taxonomy_default_course_id bigint NOT NULL,
 standards_framework_code varchar(2000) NOT NULL,
 PRIMARY KEY(id)
);

-- Index on subject_id to enhance query performance
CREATE INDEX taxonomy_course_taxonomy_subject_id_idx ON 
 taxonomy_course (taxonomy_subject_id);

-- Index on taxonomy_default_course_id to enhance query performance
CREATE INDEX taxonomy_course_taxonomy_default_course_id_idx ON 
 taxonomy_course (taxonomy_default_course_id);

-- Index on standards_framework_code to enhance query performance
CREATE INDEX taxonomy_course_standards_framework_code_idx ON 
 taxonomy_course (standards_framework_code);

-- Taxonomy domain information 
CREATE TABLE taxonomy_domain (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL,
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 taxonomy_default_domain_id bigint NOT NULL,
 standards_framework_code varchar(2000) NOT NULL, 
 PRIMARY KEY(id)
);

-- Index on gooru_domain_id to enhance query performance
CREATE INDEX taxonomy_domain_taxonomy_default_domain_id_idx ON 
 taxonomy_domain (taxonomy_default_domain_id);

-- Index on standards_framework_code to enhance query performance
CREATE INDEX taxonomy_domain_standards_framework_code_idx ON 
 taxonomy_domain (standards_framework_code);

-- Mapping between taxonomy course and domain 
CREATE TABLE taxonomy_subdomain (
 id bigserial NOT NULL,
 taxonomy_course_id bigint NOT NULL,
 taxonomy_domain_id bigint NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 taxonomy_default_subdomain_id bigint NOT NULL,
 standards_framework_code varchar(2000) NOT NULL, 
 PRIMARY KEY(id)
);

-- Index on course_id, domain_id to enhance query performance
CREATE INDEX taxonomy_subdomain_course_id_domain_id_idx ON 
 taxonomy_subdomain (taxonomy_course_id, taxonomy_domain_id);

-- Index on taxonomy_default_subdomain_id to enhance query performance
CREATE INDEX taxonomy_subdomain_subdomain_id_idx ON 
 taxonomy_subdomain (taxonomy_default_subdomain_id);

-- Index on standards_framework_code to enhance query performance
CREATE INDEX taxonomy_subdomain_standards_framework_code_idx ON 
 taxonomy_subdomain (standards_framework_code);

-- Generic table to store standards & learning target information
CREATE TABLE taxonomy_code (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL, 
 description varchar(5000) NOT NULL,
 depth smallint, 
 parent_id bigint, 
 root_node_id bigint,
 sequence_id smallint,
 standards_framework_code varchar(2000) NOT NULL, 
 PRIMARY KEY(id)
);

-- Index on parent_id to enhance query performance
CREATE INDEX taxonomy_code_parent_id_idx ON 
 taxonomy_code (parent_id);

-- Index on root_node_id to enhance query performance
CREATE INDEX taxonomy_code_root_node_id_idx ON 
 taxonomy_code (root_node_id);

-- Index on code to enhance query performance
CREATE INDEX taxonomy_code_code_idx ON 
 taxonomy_code (code);

-- Index on code to enhance query performance
CREATE INDEX taxonomy_standards_framework_code_idx ON 
 taxonomy_code (standards_framework_code);

-- Subdomain and standard mapping
CREATE TABLE taxonomy_subdomain_code (
 taxonomy_subdomain_id bigint NOT NULL,
 taxonomy_code_id bigint NOT NULL,
 PRIMARY KEY(taxonomy_subdomain_id, taxonomy_code_id)
);

-- GUT Standard mapping across frameworks
CREATE TABLE taxonomy_standard_map (
 id bigserial NOT NULL,
 taxonomy_default_subject_code varchar(2000) NOT NULL, -- should we use id instead?  
 taxonomy_default_standard_code varchar(2000) NOT NULL,
 ccss_standard_display_code varchar(2000) NOT NULL,
 cass_standard_display_code varchar(2000) NOT NULL,
 ngss_standard_display_code varchar(2000) NOT NULL,
 teks_standard_display_code varchar(2000) NOT NULL,
 c3_standard_display_code varchar(2000) NOT NULL,
 PRIMARY KEY(id)
);

-- Index on Gooru standard to enhance query performance
CREATE INDEX taxonomy_standard_map_standard_subject_code_idx ON 
 taxonomy_standard_map (taxonomy_default_standard_code, taxonomy_default_subject_code);

-- GUT Learning target mapping across frameworks
CREATE TABLE taxonomy_learning_target_map (
 id bigserial NOT NULL,
 taxonomy_default_subject_code varchar(2000) NOT NULL, 
 taxonomy_default_learning_target_code varchar(2000) NOT NULL,
 ccss_learning_target_display_code varchar(2000) NOT NULL,
 cass_learning_target_display_code varchar(2000) NOT NULL,
 ngss_learning_target_display_code varchar(2000) NOT NULL,
 teks_learning_target_display_code varchar(2000) NOT NULL,
 c3_learning_target_display_code varchar(2000) NOT NULL,
 PRIMARY KEY(id)
);

-- Index on Gooru standard to enhance query performance
CREATE INDEX taxonomy_learning_target_map_subject_learning_target_code_idx ON 
 taxonomy_learning_target_map (taxonomy_default_learning_target_code, taxonomy_default_subject_code);

-- Generic table to store standards & learning target information 
-- NOT mapped to Gooru Taxonomy
CREATE TABLE code (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL, 
 description varchar(5000) NOT NULL,
 depth smallint, 
 parent_id bigint, 
 root_node_id bigint,
 sequence_id smallint,
 standards_framework_code varchar(2000) NOT NULL, 
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

-- Index on code to enhance query performance
CREATE INDEX code_standards_framework_code_idx ON 
 code (standards_framework_code);


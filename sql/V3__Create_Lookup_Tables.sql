
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
CREATE TYPE class_sharing AS ENUM ('open', 'restricted');

-- Type of assessment 
CREATE TYPE assessment_type AS ENUM ('internal', 'external');

-- Type of question 
CREATE TYPE question_type AS ENUM ('internal', 'external');

-- Supported code types 
CREATE TYPE code_type AS ENUM ('standard_level_0', 'standard_level_1', 'standard_level_2', 'learning_target_group', 'learning_target');


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
 hewlett_deep_learning_model varchar(2000),
 conley_four_keys_model varchar(2000),
 p21_framework_model varchar(2000),
 national_research_center_model varchar(2000),
 PRIMARY KEY(id)
);

-- Store standards framework table code and name 
CREATE TABLE standard_framework (
 code varchar(36) NOT NULL, 
 display_code varchar(2000) NOT NULL,
 PRIMARY KEY(code)
);

-- Gooru default subject information 
CREATE TABLE default_subject (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 classification subject_classification_type NOT NULL,
 has_taxonomy_representation boolean NOT NULL DEFAULT FALSE,
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code),
 is_default_preference boolean NOT NULL DEFAULT FALSE,
 UNIQUE (code),
 PRIMARY KEY(id)
);

-- Taxonomy subject information 
CREATE TABLE taxonomy_subject (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 classification subject_classification_type NOT NULL,
 default_subject_id bigint NOT NULL REFERENCES default_subject (id),
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code),
 UNIQUE (code, standard_framework_code),
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_subject_default_subject_id_idx ON 
 taxonomy_subject (default_subject_id);

CREATE INDEX taxonomy_subject_standard_framework_code_idx ON 
 taxonomy_subject (standard_framework_code);

-- Gooru taxonomy default course information 
CREATE TABLE default_course (
 id bigserial NOT NULL,
 default_subject_id bigint NOT NULL REFERENCES default_subject (id),
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 grades varchar(2000),
 sequence_id smallint NOT NULL, 
 has_taxonomy_representation boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY(id)
);

CREATE INDEX default_course_default_subject_id_idx ON 
 default_course (default_subject_id);

-- Taxonomy course information 
CREATE TABLE taxonomy_course (
 id bigserial NOT NULL,
 taxonomy_subject_id bigint NOT NULL REFERENCES taxonomy_subject (id),
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 description varchar(5000), 
 grades varchar(2000),
 sequence_id smallint NOT NULL, 
 default_course_id bigint NOT NULL REFERENCES default_course (id),
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code),
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_course_taxonomy_subject_id_idx ON 
 taxonomy_course (taxonomy_subject_id);

-- Gooru default domain information 
CREATE TABLE default_domain (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL,
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 has_taxonomy_representation boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY(id)
);

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
 default_domain_id bigint NOT NULL REFERENCES default_domain (id),
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code), 
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_domain_default_domain_id_idx ON 
 taxonomy_domain (default_domain_id);

-- Mapping between default course and domain 
CREATE TABLE default_subdomain (
 id bigserial NOT NULL,
 default_course_id bigint NOT NULL REFERENCES default_course (id),
 default_domain_id bigint NOT NULL REFERENCES default_domain (id),
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 domain_display_code varchar(2000) NOT NULL,
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 has_taxonomy_representation boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY(id)
);

CREATE INDEX default_subdomain_course_id_domain_id_idx ON 
 default_subdomain (default_course_id, default_domain_id);

-- Mapping between taxonomy course and domain 
CREATE TABLE taxonomy_subdomain (
 id bigserial NOT NULL,
 taxonomy_course_id bigint NOT NULL REFERENCES taxonomy_course (id),
 taxonomy_domain_id bigint NOT NULL REFERENCES taxonomy_domain (id),
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL, 
 display_code varchar(2000) NOT NULL, 
 domain_display_code varchar(2000) NOT NULL,
 description varchar(5000), 
 sequence_id smallint NOT NULL, 
 default_subdomain_id bigint NOT NULL REFERENCES default_subdomain (id),
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code), 
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_subdomain_course_id_domain_id_idx ON 
 taxonomy_subdomain (taxonomy_course_id, taxonomy_domain_id);

-- Generic table to store gooru default standards & learning target information
CREATE TABLE default_code (
 id bigserial NOT NULL,
 creator_id varchar(36) NOT NULL,
 created timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 modified timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'), 
 code varchar(2000) NOT NULL,
 display_code varchar(2000) NOT NULL, 
 description varchar(5000) NOT NULL,
 depth smallint, 
 parent_default_code_id bigint, 
 root_default_code_id bigint,
 sequence_id smallint NOT NULL,
 type code_type NOT NULL,
 has_taxonomy_representation boolean NOT NULL DEFAULT FALSE,
 UNIQUE (code),
 PRIMARY KEY(id)
);

CREATE INDEX default_code_parent_default_code_id_idx ON 
 default_code (parent_default_code_id);

CREATE INDEX default_code_root_default_code_id_idx ON 
 default_code (root_default_code_id);

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
 parent_taxonomy_code_id bigint, 
 root_taxonomy_code_id bigint,
 sequence_id smallint NOT NULL,
 default_code_id bigint NOT NULL REFERENCES default_code (id), 
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code), 
 type code_type NOT NULL,
 is_selectable boolean NOT NULL DEFAULT FALSE, 
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_code_parent_taxonomy_code_id_idx ON 
 taxonomy_code (parent_taxonomy_code_id);

CREATE INDEX taxonomy_code_root_taxonomy_code_id_idx ON 
 taxonomy_code (root_taxonomy_code_id);

CREATE INDEX taxonomy_code_code_idx ON 
 taxonomy_code (code);

CREATE INDEX taxonomy_standard_framework_code_idx ON 
 taxonomy_code (standard_framework_code);

-- Default subdomain and standard mapping
CREATE TABLE default_subdomain_code (
 default_subdomain_id bigint NOT NULL,
 default_code_id bigint NOT NULL,
 PRIMARY KEY(default_subdomain_id, default_code_id)
);

-- Subdomain and standard mapping
CREATE TABLE taxonomy_subdomain_code (
 taxonomy_subdomain_id bigint NOT NULL,
 taxonomy_code_id bigint NOT NULL,
 PRIMARY KEY(taxonomy_subdomain_id, taxonomy_code_id)
);


-- GUT Standard mapping across frameworks
CREATE TABLE taxonomy_standard_map (
 id bigserial NOT NULL,
 default_subject_code varchar(2000) NOT NULL REFERENCES default_subject (code),   
 default_standard_code varchar(2000) NOT NULL REFERENCES default_code (code),
 ccss_standard_display_code varchar(2000),
 cass_standard_display_code varchar(2000),
 ngss_standard_display_code varchar(2000),
 teks_standard_display_code varchar(2000),
 c3_standard_display_code varchar(2000),
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_standard_map_standard_subject_code_idx ON 
 taxonomy_standard_map (default_standard_code, default_subject_code);

-- GUT Learning target mapping across frameworks
CREATE TABLE taxonomy_learning_target_map (
 id bigserial NOT NULL,
 default_subject_code varchar(2000) NOT NULL REFERENCES default_subject (code), 
 default_learning_target_code varchar(2000) NOT NULL REFERENCES default_code (code),
 ccss_learning_target_display_code varchar(2000),
 cass_learning_target_display_code varchar(2000),
 ngss_learning_target_display_code varchar(2000),
 teks_learning_target_display_code varchar(2000),
 c3_learning_target_display_code varchar(2000),
 PRIMARY KEY(id)
);

CREATE INDEX taxonomy_learning_target_map_subject_learning_target_code_idx ON 
 taxonomy_learning_target_map (default_learning_target_code, default_subject_code);

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
 parent_code_id bigint, 
 root_code_id bigint,
 sequence_id smallint NOT NULL,
 standard_framework_code varchar(36) NOT NULL REFERENCES standard_framework (code), 
 type code_type NOT NULL,
 is_selectable boolean NOT NULL DEFAULT FALSE,
 PRIMARY KEY(id)
);

CREATE INDEX code_parent_code_id_idx ON 
 code (parent_code_id);

CREATE INDEX code_root_code_id_idx ON 
 code (root_code_id);

CREATE INDEX code_code_idx ON 
 code (code);

CREATE INDEX code_standard_framework_code_idx ON 
 code (standard_framework_code);


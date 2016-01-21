--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

-- COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: class_member_status_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE class_member_status_type AS ENUM (
    'invited',
    'pending',
    'joined'
);


ALTER TYPE class_member_status_type OWNER TO nucleus;

--
-- Name: class_sharing_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE class_sharing_type AS ENUM (
    'open',
    'restricted'
);


ALTER TYPE class_sharing_type OWNER TO nucleus;

--
-- Name: code_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE code_type AS ENUM (
    'standard_level_0',
    'standard_level_1',
    'standard_level_2',
    'learning_target_group',
    'learning_target'
);


ALTER TYPE code_type OWNER TO nucleus;

--
-- Name: content_container_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE content_container_type AS ENUM (
    'collection',
    'assessment',
    'assessment-external'
);


ALTER TYPE content_container_type OWNER TO nucleus;

--
-- Name: content_format_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE content_format_type AS ENUM (
    'resource',
    'question'
);


ALTER TYPE content_format_type OWNER TO nucleus;

--
-- Name: content_subformat_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE content_subformat_type AS ENUM (
    'video_resource',
    'webpage_resource',
    'interactive_resource',
    'image_resource',
    'text_resource',
    'audio_resource',
    'multiple_choice_question',
    'multiple_answer_question',
    'true_false_question',
    'fill_in_the_blank_question',
    'open_ended_question',
    'hot_text_reorder_question',
    'hot_text_highlight_question',
    'hot_spot_image_question',
    'hot_spot_text_question',
    'external_question'
);


ALTER TYPE content_subformat_type OWNER TO nucleus;

--
-- Name: grading_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE grading_type AS ENUM (
    'system',
    'teacher'
);


ALTER TYPE grading_type OWNER TO nucleus;

--
-- Name: metadata_reference_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE metadata_reference_type AS ENUM (
    'educational_use',
    'moments_of_learning',
    'depth_of_knowledge',
    'reading_level',
    'audience',
    'advertisement_level',
    'hazard_level',
    'media_feature',
    'grade'
);


ALTER TYPE metadata_reference_type OWNER TO nucleus;

--
-- Name: orientation_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE orientation_type AS ENUM (
    'teacher',
    'student'
);


ALTER TYPE orientation_type OWNER TO nucleus;

--
-- Name: subject_classification_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE subject_classification_type AS ENUM (
    'k_12',
    'higher_education',
    'professional_learning'
);


ALTER TYPE subject_classification_type OWNER TO nucleus;

--
-- Name: user_category_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE user_category_type AS ENUM (
    'teacher',
    'student',
    'parent',
    'other'
);


ALTER TYPE user_category_type OWNER TO nucleus;

--
-- Name: user_gender_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE user_gender_type AS ENUM (
    'male',
    'female',
    'other',
    'not_wise_to_share'
);


ALTER TYPE user_gender_type OWNER TO nucleus;

--
-- Name: user_identity_status_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE user_identity_status_type AS ENUM (
    'active',
    'deactived',
    'deleted'
);


ALTER TYPE user_identity_status_type OWNER TO nucleus;

--
-- Name: user_identity_type; Type: TYPE; Schema: public; Owner: nucleus
--

CREATE TYPE user_identity_login_type AS ENUM (
    'google',
    'wsfed',
    'saml',
    'credential'
);


ALTER TYPE user_identity_login_type OWNER TO nucleus;


CREATE TYPE user_identity_provision_type AS ENUM (
    'google',
    'wsfed',
    'saml',
    'registered'
);


ALTER TYPE user_identity_provision_type OWNER TO nucleus;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_client; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE auth_client (
    client_id character varying(36) NOT NULL,
    name character varying(256) NOT NULL,
    url character varying(2000),
    client_key character varying(64) NOT NULL,
    description character varying(5000),
    contact_email character varying(256),
    access_token_validity integer NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    grant_types jsonb NOT NULL,
    referer_domains jsonb,
    cdn_urls jsonb NOT NULL
);


ALTER TABLE auth_client OWNER TO nucleus;

--
-- Name: class; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE class (
    id character varying(36) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36) NOT NULL,
    modifier_id character varying(36) NOT NULL,
    title character varying(5000) NOT NULL,
    description character varying(5000),
    greeting character varying(5000),
    grade character varying(5000) NOT NULL,
    class_sharing class_sharing_type NOT NULL,
    cover_image character varying(2000),
    code character varying(36) NOT NULL,
    min_score smallint NOT NULL,
    end_time timestamp without time zone,
    course_id character varying(36),
    is_deleted boolean DEFAULT false NOT NULL,
    collaborator jsonb,
    is_archived boolean DEFAULT false NOT NULL
);


ALTER TABLE class OWNER TO nucleus;

--
-- Name: class_member; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE class_member (
    class_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    class_member_status class_member_status_type NOT NULL
);


ALTER TABLE class_member OWNER TO nucleus;

--
-- Name: code; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE code (
    id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000) NOT NULL,
    parent_code_id bigint,
    root_code_id bigint,
    sequence_id smallint NOT NULL,
    standard_framework_code character varying(36) NOT NULL,
    type code_type NOT NULL,
    is_selectable boolean DEFAULT false NOT NULL
);


ALTER TABLE code OWNER TO nucleus;

--
-- Name: code_code_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE code_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE code_code_id_seq OWNER TO nucleus;

--
-- Name: code_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE code_code_id_seq OWNED BY code.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE collection (
    id character varying(36) NOT NULL,
    title character varying(5000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    owner_id character varying(36) NOT NULL,
    creator_id character varying(36) NOT NULL,
    modifier_id character varying(36) NOT NULL,
    original_creator_id character varying(36),
    original_collection_id character varying(36),
    publish_date timestamp without time zone,
    format content_container_type NOT NULL,
    thumbnail character varying(2000),
    learning_objective character varying(20000),
    audience jsonb,
    collaborator jsonb,
    metadata jsonb,
    taxonomy jsonb,
    orientation orientation_type DEFAULT 'student'::orientation_type NOT NULL,
    url character varying(2000),
    login_required boolean,
    setting jsonb,
    grading grading_type,
    visible_on_profile boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE collection OWNER TO nucleus;

--
-- Name: content; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE content (
    id character varying(36) NOT NULL,
    title character varying(20000) NOT NULL,
    url character varying(2000),
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36) NOT NULL,
    original_creator_id character varying(36) NOT NULL,
    original_content_id character varying(36),
    publish_date timestamp without time zone,
    short_title character varying(5000),
    narration character varying(5000),
    description character varying(20000),
    content_format content_format_type NOT NULL,
    content_subformat content_subformat_type NOT NULL,
    answer jsonb,
    metadata jsonb,
    taxonomy jsonb,
    depth_of_knowledge jsonb,
    hint_explanation_detail jsonb,
    thumbnail character varying(2000),
    course_id character varying(36),
    unit_id character varying(36),
    lesson_id character varying(36),
    collection_id character varying(36),
    sequence_id smallint,
    is_copyright_owner boolean,
    copyright_owner jsonb,
    info jsonb,
    visible_on_profile boolean DEFAULT false NOT NULL,
    display_guide jsonb,
    accessibility jsonb,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE content OWNER TO nucleus;

--
-- Name: country; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE country (
    id bigint NOT NULL,
    name character varying(2000) NOT NULL,
    code character varying(1000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36)
);


ALTER TABLE country OWNER TO nucleus;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE country_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE country_country_id_seq OWNER TO nucleus;

--
-- Name: country_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE country_country_id_seq OWNED BY country.id;


--
-- Name: course; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE course (
    id character varying(36) NOT NULL,
    title character varying(5000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    owner_id character varying(36) NOT NULL,
    creator_id character varying(36) NOT NULL,
    modifier_id character varying(36) NOT NULL,
    original_creator_id character varying(36) NOT NULL,
    original_course_id character varying(36),
    publish_date timestamp without time zone,
    thumbnail character varying(2000),
    audience jsonb,
    metadata jsonb,
    taxonomy jsonb,
    collaborator jsonb,
    class_list jsonb,
    visible_on_profile boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE course OWNER TO nucleus;

--
-- Name: course_unit; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE course_unit (
    course_id character varying(36) NOT NULL,
    unit_id character varying(36) NOT NULL,
    title character varying(5000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    owner_id character varying(36) NOT NULL,
    creator_id character varying(36) NOT NULL,
    modifier_id character varying(36) NOT NULL,
    original_creator_id character varying(36) NOT NULL,
    original_unit_id character varying(36),
    big_ideas character varying(20000) NOT NULL,
    essential_questions character varying(20000) NOT NULL,
    metadata jsonb,
    taxonomy jsonb,
    sequence_id smallint NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE course_unit OWNER TO nucleus;

--
-- Name: course_unit_lesson; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE course_unit_lesson (
    course_id character varying(36) NOT NULL,
    unit_id character varying(36) NOT NULL,
    lesson_id character varying(36) NOT NULL,
    title character varying(5000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    owner_id character varying(36) NOT NULL,
    creator_id character varying(36) NOT NULL,
    modifier_id character varying(36) NOT NULL,
    original_creator_id character varying(36) NOT NULL,
    original_lesson_id character varying(36),
    metadata jsonb,
    taxonomy jsonb,
    sequence_id smallint NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE course_unit_lesson OWNER TO nucleus;

--
-- Name: course_unit_lesson_collection; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE course_unit_lesson_collection (
    course_id character varying(36) NOT NULL,
    unit_id character varying(36) NOT NULL,
    lesson_id character varying(36) NOT NULL,
    collection_id character varying(36) NOT NULL,
    sequence_id smallint NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE course_unit_lesson_collection OWNER TO nucleus;

--
-- Name: default_code; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_code (
    default_code_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000) NOT NULL,
    parent_default_code_id bigint,
    root_default_code_id bigint,
    sequence_id smallint NOT NULL,
    code_classification code_type NOT NULL,
    has_taxonomy_representation boolean DEFAULT false NOT NULL
);


ALTER TABLE default_code OWNER TO nucleus;

--
-- Name: default_code_default_code_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE default_code_default_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_code_default_code_id_seq OWNER TO nucleus;

--
-- Name: default_code_default_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE default_code_default_code_id_seq OWNED BY default_code.default_code_id;


--
-- Name: default_course; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_course (
    default_course_id bigint NOT NULL,
    default_subject_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    grades character varying(2000),
    sequence_id smallint NOT NULL,
    has_taxonomy_representation boolean DEFAULT false NOT NULL
);


ALTER TABLE default_course OWNER TO nucleus;

--
-- Name: default_course_default_course_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE default_course_default_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_course_default_course_id_seq OWNER TO nucleus;

--
-- Name: default_course_default_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE default_course_default_course_id_seq OWNED BY default_course.default_course_id;


--
-- Name: default_domain; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_domain (
    default_domain_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    has_taxonomy_representation boolean DEFAULT false NOT NULL
);


ALTER TABLE default_domain OWNER TO nucleus;

--
-- Name: default_domain_default_domain_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE default_domain_default_domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_domain_default_domain_id_seq OWNER TO nucleus;

--
-- Name: default_domain_default_domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE default_domain_default_domain_id_seq OWNED BY default_domain.default_domain_id;


--
-- Name: default_subdomain; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_subdomain (
    default_subdomain_id bigint NOT NULL,
    default_course_id bigint NOT NULL,
    default_domain_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    domain_display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    has_taxonomy_representation boolean DEFAULT false NOT NULL
);


ALTER TABLE default_subdomain OWNER TO nucleus;

--
-- Name: default_subdomain_code; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_subdomain_code (
    default_subdomain_id bigint NOT NULL,
    default_code_id bigint NOT NULL
);


ALTER TABLE default_subdomain_code OWNER TO nucleus;

--
-- Name: default_subdomain_default_subdomain_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE default_subdomain_default_subdomain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_subdomain_default_subdomain_id_seq OWNER TO nucleus;

--
-- Name: default_subdomain_default_subdomain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE default_subdomain_default_subdomain_id_seq OWNED BY default_subdomain.default_subdomain_id;


--
-- Name: default_subject; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE default_subject (
    default_subject_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    subject_classification subject_classification_type NOT NULL,
    has_taxonomy_representation boolean DEFAULT false NOT NULL,
    default_standard_framework_code character varying(36),
    is_default_preference boolean DEFAULT false NOT NULL
);


ALTER TABLE default_subject OWNER TO nucleus;

--
-- Name: default_subject_default_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE default_subject_default_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE default_subject_default_subject_id_seq OWNER TO nucleus;

--
-- Name: default_subject_default_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE default_subject_default_subject_id_seq OWNED BY default_subject.default_subject_id;


--
-- Name: google_drive_connect; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE google_drive_connect (
    user_id character varying(36) NOT NULL,
    connected_email_id character varying(256) NOT NULL,
    refresh_token character varying(2000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);


ALTER TABLE google_drive_connect OWNER TO nucleus;

--
-- Name: metadata_reference; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE metadata_reference (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    format metadata_reference_type NOT NULL,
    label character varying(2000) NOT NULL,
    sequence_id smallint NOT NULL
);


ALTER TABLE metadata_reference OWNER TO nucleus;

--
-- Name: metadata_reference_metadata_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE metadata_reference_metadata_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE metadata_reference_metadata_reference_id_seq OWNER TO nucleus;

--
-- Name: metadata_reference_metadata_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE metadata_reference_metadata_reference_id_seq OWNED BY metadata_reference.id;


--
-- Name: school; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE school (
    id character varying(36) NOT NULL,
    school_district_id character varying(36),
    name character varying(2000) NOT NULL,
    code character varying(1000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36)
);


ALTER TABLE school OWNER TO nucleus;

--
-- Name: school_district; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE school_district (
    id character varying(36) NOT NULL,
    name character varying(2000) NOT NULL,
    code character varying(1000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36)
);


ALTER TABLE school_district OWNER TO nucleus;

--
-- Name: standard_framework; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE standard_framework (
    id character varying(36) NOT NULL,
    display_code character varying(2000) NOT NULL
);


ALTER TABLE standard_framework OWNER TO nucleus;

--
-- Name: state; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE state (
    id bigserial NOT NULL,
    country_id bigint  NULL,
    name character varying(2000) NOT NULL,
    code character varying(1000) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    creator_id character varying(36)
);


ALTER TABLE state OWNER TO nucleus;

--
-- Name: taxonomy_code; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_code (
    id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000) NOT NULL,
    parent_taxonomy_code_id bigint,
    root_taxonomy_code_id bigint,
    sequence_id smallint NOT NULL,
    default_code_id bigint NOT NULL,
    standard_framework_code character varying(36) NOT NULL,
    format code_type NOT NULL,
    is_selectable boolean DEFAULT false NOT NULL
);


ALTER TABLE taxonomy_code OWNER TO nucleus;

--
-- Name: taxonomy_code_taxonomy_code_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE taxonomy_code_taxonomy_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy_code_taxonomy_code_id_seq OWNER TO nucleus;

--
-- Name: taxonomy_code_taxonomy_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE taxonomy_code_taxonomy_code_id_seq OWNED BY taxonomy_code.id;


--
-- Name: taxonomy_course; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_course (
    taxonomy_course_id bigint NOT NULL,
    taxonomy_subject_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    grades character varying(2000),
    sequence_id smallint NOT NULL,
    default_course_id bigint NOT NULL,
    standard_framework_code character varying(36) NOT NULL
);


ALTER TABLE taxonomy_course OWNER TO nucleus;

--
-- Name: taxonomy_course_taxonomy_course_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE taxonomy_course_taxonomy_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy_course_taxonomy_course_id_seq OWNER TO nucleus;

--
-- Name: taxonomy_course_taxonomy_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE taxonomy_course_taxonomy_course_id_seq OWNED BY taxonomy_course.taxonomy_course_id;


--
-- Name: taxonomy_domain; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_domain (
    taxonomy_domain_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    default_domain_id bigint NOT NULL,
    standard_framework_code character varying(36) NOT NULL
);


ALTER TABLE taxonomy_domain OWNER TO nucleus;

--
-- Name: taxonomy_domain_taxonomy_domain_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE taxonomy_domain_taxonomy_domain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy_domain_taxonomy_domain_id_seq OWNER TO nucleus;

--
-- Name: taxonomy_domain_taxonomy_domain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE taxonomy_domain_taxonomy_domain_id_seq OWNED BY taxonomy_domain.taxonomy_domain_id;


--
-- Name: taxonomy_learning_target_map; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_learning_target_map (
    default_learning_target_code character varying(2000) NOT NULL,
    default_subject_code character varying(2000) NOT NULL,
    ccss_learning_target_display_code character varying(2000),
    cass_learning_target_display_code character varying(2000),
    ngss_learning_target_display_code character varying(2000),
    teks_learning_target_display_code character varying(2000),
    c3_learning_target_display_code character varying(2000)
);


ALTER TABLE taxonomy_learning_target_map OWNER TO nucleus;

--
-- Name: taxonomy_standard_map; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_standard_map (
    default_standard_code character varying(2000) NOT NULL,
    default_subject_code character varying(2000) NOT NULL,
    ccss_standard_display_code character varying(2000),
    cass_standard_display_code character varying(2000),
    ngss_standard_display_code character varying(2000),
    teks_standard_display_code character varying(2000),
    c3_standard_display_code character varying(2000)
);


ALTER TABLE taxonomy_standard_map OWNER TO nucleus;

--
-- Name: taxonomy_subdomain; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_subdomain (
    taxonomy_subdomain_id bigint NOT NULL,
    taxonomy_course_id bigint NOT NULL,
    taxonomy_domain_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    domain_display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    default_subdomain_id bigint NOT NULL,
    standard_framework_code character varying(36) NOT NULL
);


ALTER TABLE taxonomy_subdomain OWNER TO nucleus;

--
-- Name: taxonomy_subdomain_code; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_subdomain_code (
    taxonomy_subdomain_id bigint NOT NULL,
    taxonomy_code_id bigint NOT NULL
);


ALTER TABLE taxonomy_subdomain_code OWNER TO nucleus;

--
-- Name: taxonomy_subdomain_taxonomy_subdomain_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE taxonomy_subdomain_taxonomy_subdomain_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy_subdomain_taxonomy_subdomain_id_seq OWNER TO nucleus;

--
-- Name: taxonomy_subdomain_taxonomy_subdomain_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE taxonomy_subdomain_taxonomy_subdomain_id_seq OWNED BY taxonomy_subdomain.taxonomy_subdomain_id;


--
-- Name: taxonomy_subject; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE taxonomy_subject (
    taxonomy_subject_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    code character varying(2000) NOT NULL,
    display_code character varying(2000) NOT NULL,
    description character varying(5000),
    sequence_id smallint NOT NULL,
    subject_classification subject_classification_type NOT NULL,
    default_subject_id bigint NOT NULL,
    standard_framework_code character varying(36) NOT NULL
);


ALTER TABLE taxonomy_subject OWNER TO nucleus;

--
-- Name: taxonomy_subject_taxonomy_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE taxonomy_subject_taxonomy_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy_subject_taxonomy_subject_id_seq OWNER TO nucleus;

--
-- Name: taxonomy_subject_taxonomy_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE taxonomy_subject_taxonomy_subject_id_seq OWNED BY taxonomy_subject.taxonomy_subject_id;


--
-- Name: twenty_one_century_skill; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE twenty_one_century_skill (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    key_classification character varying(2000) NOT NULL,
    label character varying(2000) NOT NULL,
    sequence_id smallint NOT NULL,
    hewlett_deep_learning_model boolean DEFAULT false NOT NULL,
    conley_four_keys_model boolean DEFAULT false NOT NULL,
    p21_framework_model boolean DEFAULT false NOT NULL,
    national_research_center_model boolean DEFAULT false NOT NULL
);


ALTER TABLE twenty_one_century_skill OWNER TO nucleus;

--
-- Name: twenty_one_century_skill_twenty_one_century_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE twenty_one_century_skill_twenty_one_century_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE twenty_one_century_skill_twenty_one_century_skill_id_seq OWNER TO nucleus;

--
-- Name: twenty_one_century_skill_twenty_one_century_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE twenty_one_century_skill_twenty_one_century_skill_id_seq OWNED BY twenty_one_century_skill.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE user_demographic (
    id character varying(36) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    parent_user_id character varying(36),
    user_category user_category_type  NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    last_login timestamp without time zone,
    birth_date timestamp without time zone,
    grade jsonb,
    course jsonb,
    thumbnail_path character varying(1000),
    gender user_gender_type,
    about_me character varying(5000),
    school_id character varying(36),
    school_district_id character varying(36),
    email_id character varying(256),
    country_id bigint,
    state_id bigint
);


ALTER TABLE user_demographic OWNER TO nucleus;

--
-- Name: user_identity; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE user_identity (
    id bigint NOT NULL,
    user_id character varying(36) NOT NULL,
    username character varying(32) NOT NULL,
    reference_id character varying(100),
    email_id character varying(256),
    password character varying(64),
    client_id character varying(36) NOT NULL,
    login_type user_identity_login_type NOT NULL,
    provision_type user_identity_provision_type NOT NULL,
    email_confirm_status boolean DEFAULT false NOT NULL,
    status user_identity_status_type NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);


ALTER TABLE user_identity OWNER TO nucleus;

--
-- Name: user_identity_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE user_identity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_identity_id_seq OWNER TO nucleus;

--
-- Name: user_identity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE user_identity_id_seq OWNED BY user_identity.id;


--
-- Name: user_network; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE user_network (
    user_id character varying(36) NOT NULL,
    follow_on_user_id character varying(36) NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE user_network OWNER TO nucleus;

--
-- Name: user_permission; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE user_permission (
    user_id character varying(36) NOT NULL,
    permission jsonb,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);


ALTER TABLE user_permission OWNER TO nucleus;

--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE TABLE user_preference (
    user_id character varying(36) NOT NULL,
    standard_preference jsonb NOT NULL,
    profile_visiblity boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    updated_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);


ALTER TABLE user_preference OWNER TO nucleus;

--
-- Name: code_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY code ALTER COLUMN id SET DEFAULT nextval('code_code_id_seq'::regclass);


--
-- Name: country_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY country ALTER COLUMN id SET DEFAULT nextval('country_country_id_seq'::regclass);


--
-- Name: default_code_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_code ALTER COLUMN default_code_id SET DEFAULT nextval('default_code_default_code_id_seq'::regclass);


--
-- Name: default_course_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_course ALTER COLUMN default_course_id SET DEFAULT nextval('default_course_default_course_id_seq'::regclass);


--
-- Name: default_domain_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_domain ALTER COLUMN default_domain_id SET DEFAULT nextval('default_domain_default_domain_id_seq'::regclass);


--
-- Name: default_subdomain_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_subdomain ALTER COLUMN default_subdomain_id SET DEFAULT nextval('default_subdomain_default_subdomain_id_seq'::regclass);


--
-- Name: default_subject_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_subject ALTER COLUMN default_subject_id SET DEFAULT nextval('default_subject_default_subject_id_seq'::regclass);


--
-- Name: metadata_reference_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY metadata_reference ALTER COLUMN id SET DEFAULT nextval('metadata_reference_metadata_reference_id_seq'::regclass);


--
-- Name: taxonomy_code_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_code ALTER COLUMN id SET DEFAULT nextval('taxonomy_code_taxonomy_code_id_seq'::regclass);


--
-- Name: taxonomy_course_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_course ALTER COLUMN taxonomy_course_id SET DEFAULT nextval('taxonomy_course_taxonomy_course_id_seq'::regclass);


--
-- Name: taxonomy_domain_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_domain ALTER COLUMN taxonomy_domain_id SET DEFAULT nextval('taxonomy_domain_taxonomy_domain_id_seq'::regclass);


--
-- Name: taxonomy_subdomain_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subdomain ALTER COLUMN taxonomy_subdomain_id SET DEFAULT nextval('taxonomy_subdomain_taxonomy_subdomain_id_seq'::regclass);


--
-- Name: taxonomy_subject_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subject ALTER COLUMN taxonomy_subject_id SET DEFAULT nextval('taxonomy_subject_taxonomy_subject_id_seq'::regclass);


--
-- Name: twenty_one_century_skill_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY twenty_one_century_skill ALTER COLUMN id SET DEFAULT nextval('twenty_one_century_skill_twenty_one_century_skill_id_seq'::regclass);


--
-- Name: identity_id; Type: DEFAULT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY user_identity ALTER COLUMN id SET DEFAULT nextval('user_identity_id_seq'::regclass);


--
-- Name: auth_client_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY auth_client
    ADD CONSTRAINT auth_client_pkey PRIMARY KEY (client_id);


--
-- Name: class_code_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY class
    ADD CONSTRAINT class_code_key UNIQUE (code);


--
-- Name: class_member_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY class_member
    ADD CONSTRAINT class_member_pkey PRIMARY KEY (class_id, user_id);


--
-- Name: class_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: code_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY code
    ADD CONSTRAINT code_pkey PRIMARY KEY (id);


--
-- Name: collection_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: content_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: course_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: course_unit_lesson_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY course_unit_lesson_collection
    ADD CONSTRAINT course_unit_lesson_collection_pkey PRIMARY KEY (course_id, unit_id, lesson_id, collection_id);


--
-- Name: course_unit_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY course_unit_lesson
    ADD CONSTRAINT course_unit_lesson_pkey PRIMARY KEY (course_id, unit_id, lesson_id);


--
-- Name: course_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY course_unit
    ADD CONSTRAINT course_unit_pkey PRIMARY KEY (course_id, unit_id);


--
-- Name: default_code_code_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_code
    ADD CONSTRAINT default_code_code_key UNIQUE (code);


--
-- Name: default_code_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_code
    ADD CONSTRAINT default_code_pkey PRIMARY KEY (default_code_id);


--
-- Name: default_course_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_course
    ADD CONSTRAINT default_course_pkey PRIMARY KEY (default_course_id);


--
-- Name: default_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_domain
    ADD CONSTRAINT default_domain_pkey PRIMARY KEY (default_domain_id);


--
-- Name: default_subdomain_code_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_subdomain_code
    ADD CONSTRAINT default_subdomain_code_pkey PRIMARY KEY (default_subdomain_id, default_code_id);


--
-- Name: default_subdomain_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_subdomain
    ADD CONSTRAINT default_subdomain_pkey PRIMARY KEY (default_subdomain_id);


--
-- Name: default_subject_code_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_subject
    ADD CONSTRAINT default_subject_code_key UNIQUE (code);


--
-- Name: default_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY default_subject
    ADD CONSTRAINT default_subject_pkey PRIMARY KEY (default_subject_id);


--
-- Name: google_drive_connect_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY google_drive_connect
    ADD CONSTRAINT google_drive_connect_pkey PRIMARY KEY (user_id);


--
-- Name: metadata_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY metadata_reference
    ADD CONSTRAINT metadata_reference_pkey PRIMARY KEY (id);


--
-- Name: school_district_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY school_district
    ADD CONSTRAINT school_district_pkey PRIMARY KEY (id);


--
-- Name: school_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY school
    ADD CONSTRAINT school_pkey PRIMARY KEY (id);


--
-- Name: standard_framework_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY standard_framework
    ADD CONSTRAINT standard_framework_pkey PRIMARY KEY (id);


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);

CREATE INDEX state_country_id_idx ON state USING btree (country_id);


--
-- Name: taxonomy_code_code_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_code
    ADD CONSTRAINT taxonomy_code_code_key UNIQUE (code);


--
-- Name: taxonomy_code_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_code
    ADD CONSTRAINT taxonomy_code_pkey PRIMARY KEY (id);


--
-- Name: taxonomy_course_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_course
    ADD CONSTRAINT taxonomy_course_pkey PRIMARY KEY (taxonomy_course_id);


--
-- Name: taxonomy_domain_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_domain
    ADD CONSTRAINT taxonomy_domain_pkey PRIMARY KEY (taxonomy_domain_id);


--
-- Name: taxonomy_learning_target_map_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_learning_target_map
    ADD CONSTRAINT taxonomy_learning_target_map_pkey PRIMARY KEY (default_learning_target_code);


--
-- Name: taxonomy_standard_map_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_standard_map
    ADD CONSTRAINT taxonomy_standard_map_pkey PRIMARY KEY (default_standard_code);


--
-- Name: taxonomy_subdomain_code_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_subdomain_code
    ADD CONSTRAINT taxonomy_subdomain_code_pkey PRIMARY KEY (taxonomy_subdomain_id, taxonomy_code_id);


--
-- Name: taxonomy_subdomain_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_subdomain
    ADD CONSTRAINT taxonomy_subdomain_pkey PRIMARY KEY (taxonomy_subdomain_id);


--
-- Name: taxonomy_subject_code_standard_framework_code_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_subject
    ADD CONSTRAINT taxonomy_subject_code_standard_framework_code_key UNIQUE (code, standard_framework_code);


--
-- Name: taxonomy_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY taxonomy_subject
    ADD CONSTRAINT taxonomy_subject_pkey PRIMARY KEY (taxonomy_subject_id);


--
-- Name: twenty_one_century_skill_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY twenty_one_century_skill
    ADD CONSTRAINT twenty_one_century_skill_pkey PRIMARY KEY (id);


--
-- Name: user_email_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_demographic
    ADD CONSTRAINT user_email_key UNIQUE (email_id);


--
-- Name: user_identity_email_id_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_identity_email_id_key UNIQUE (email_id);


--
-- Name: user_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_identity_pkey PRIMARY KEY (id);


--
-- Name: user_identity_reference_id_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_identity_reference_id_key UNIQUE (reference_id);


--
-- Name: user_identity_username_key; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_identity_username_key UNIQUE (username);


--
-- Name: user_network_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_network
    ADD CONSTRAINT user_network_pkey PRIMARY KEY (user_id, follow_on_user_id);


--
-- Name: user_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_permission
    ADD CONSTRAINT user_permission_pkey PRIMARY KEY (user_id);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_demographic
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace: 
--

ALTER TABLE ONLY user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (user_id);


--
-- Name: auth_client_client_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX auth_client_client_id_idx ON auth_client USING btree (client_key);


--
-- Name: class_collaborator_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX class_collaborator_gin ON course USING gin (collaborator jsonb_path_ops);


--
-- Name: class_course_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX class_course_id_idx ON class USING btree (course_id);


--
-- Name: class_creator_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX class_creator_id_idx ON class USING btree (creator_id);


--
-- Name: class_member_class_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX class_member_class_id_idx ON class_member USING btree (class_id);


--
-- Name: class_member_user_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX class_member_user_id_idx ON class_member USING btree (user_id);


--
-- Name: code_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX code_code_idx ON code USING btree (code);


--
-- Name: code_parent_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX code_parent_code_id_idx ON code USING btree (parent_code_id);


--
-- Name: code_root_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX code_root_code_id_idx ON code USING btree (root_code_id);


--
-- Name: code_standard_framework_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX code_standard_framework_code_idx ON code USING btree (standard_framework_code);


--
-- Name: collection_collaborator_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX collection_collaborator_gin ON collection USING gin (collaborator jsonb_path_ops);


--
-- Name: collection_content_container_type_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX collection_content_container_type_idx ON collection USING btree (format);


--
-- Name: collection_owner_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX collection_owner_id_idx ON collection USING btree (owner_id);


--
-- Name: collection_original_creator_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX collection_original_creator_id_idx ON collection USING btree (original_creator_id);


--
-- Name: collection_title_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX collection_title_idx ON collection USING btree (title);


--
-- Name: content_collection_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_collection_id_idx ON content USING btree (collection_id);


--
-- Name: content_course_id_unit_id_lesson_id_collection_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_course_id_unit_id_lesson_id_collection_id_idx ON content USING btree (course_id, unit_id, lesson_id, collection_id);


--
-- Name: content_creator_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_creator_id_idx ON content USING btree (creator_id);


--
-- Name: content_format_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_format_idx ON content USING btree (content_format);


--
-- Name: content_taxonomy_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_taxonomy_gin ON content USING gin (taxonomy jsonb_path_ops);


--
-- Name: content_title_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX content_title_idx ON content USING btree (title);


--
-- Name: course_class_list_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_class_list_gin ON course USING gin (class_list jsonb_path_ops);


--
-- Name: course_collaborator_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_collaborator_gin ON course USING gin (collaborator jsonb_path_ops);


--
-- Name: course_owner_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_owner_id_idx ON course USING btree (owner_id);


--
-- Name: course_original_creator_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_original_creator_id_idx ON course USING btree (original_creator_id);


--
-- Name: course_title_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_title_idx ON course USING btree (title);


--
-- Name: course_unit_course_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_unit_course_id_idx ON course_unit USING btree (course_id);


--
-- Name: course_unit_lesson_collection_cul_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_unit_lesson_collection_cul_id_idx ON course_unit_lesson_collection USING btree (course_id, unit_id, lesson_id);

--
-- Name: course_unit_lesson_collection_coll_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_unit_lesson_collection_coll_id_idx ON course_unit_lesson_collection USING btree (collection_id);


--
-- Name: course_unit_lesson_course_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_unit_lesson_course_id_idx ON course_unit_lesson USING btree (course_id);


--
-- Name: course_unit_lesson_course_id_unit_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX course_unit_lesson_course_id_unit_id_idx ON course_unit_lesson USING btree (course_id, unit_id);


--
-- Name: default_code_parent_default_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX default_code_parent_default_code_id_idx ON default_code USING btree (parent_default_code_id);


--
-- Name: default_code_root_default_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX default_code_root_default_code_id_idx ON default_code USING btree (root_default_code_id);


--
-- Name: default_course_default_subject_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX default_course_default_subject_id_idx ON default_course USING btree (default_subject_id);


--
-- Name: default_subdomain_course_id_domain_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX default_subdomain_course_id_domain_id_idx ON default_subdomain USING btree (default_course_id, default_domain_id);


--
-- Name: taxonomy_code_parent_taxonomy_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_code_parent_taxonomy_code_id_idx ON taxonomy_code USING btree (parent_taxonomy_code_id);


--
-- Name: taxonomy_code_root_taxonomy_code_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_code_root_taxonomy_code_id_idx ON taxonomy_code USING btree (root_taxonomy_code_id);


--
-- Name: taxonomy_course_taxonomy_subject_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_course_taxonomy_subject_id_idx ON taxonomy_course USING btree (taxonomy_subject_id);


--
-- Name: taxonomy_domain_default_domain_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_domain_default_domain_id_idx ON taxonomy_domain USING btree (default_domain_id);


--
-- Name: taxonomy_learning_target_map_subject_learning_target_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_learning_target_map_subject_learning_target_code_idx ON taxonomy_learning_target_map USING btree (default_learning_target_code, default_subject_code);


--
-- Name: taxonomy_standard_framework_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_standard_framework_code_idx ON taxonomy_code USING btree (standard_framework_code);


--
-- Name: taxonomy_standard_map_standard_subject_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_standard_map_standard_subject_code_idx ON taxonomy_standard_map USING btree (default_standard_code, default_subject_code);


--
-- Name: taxonomy_subdomain_course_id_domain_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_subdomain_course_id_domain_id_idx ON taxonomy_subdomain USING btree (taxonomy_course_id, taxonomy_domain_id);


--
-- Name: taxonomy_subject_default_subject_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_subject_default_subject_id_idx ON taxonomy_subject USING btree (default_subject_id);


--
-- Name: taxonomy_subject_standard_framework_code_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX taxonomy_subject_standard_framework_code_idx ON taxonomy_subject USING btree (standard_framework_code);


--
-- Name: user_category_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_demographic_category_id_idx ON user_demographic USING btree (user_category);


--
-- Name: user_country_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_demographic_country_id_idx ON user_demographic USING btree (country_id);


--
-- Name: user_grade_gin; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_demographic_grade_gin ON user_demographic USING gin (grade jsonb_path_ops);


--
-- Name: user_identity_client_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_identity_client_id_idx ON user_identity USING btree (client_id);


--
-- Name: user_identity_email_confirm_status_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_identity_email_confirm_status_idx ON user_identity USING btree (email_confirm_status);


--
-- Name: user_identity_password_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_identity_password_idx ON user_identity USING btree (password);


--
-- Name: user_identity_status_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_identity_status_idx ON user_identity USING btree (status);


--
-- Name: user_identity_user_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_identity_user_id_idx ON user_identity USING btree (user_id);


--
-- Name: user_parent_user_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_parent_user_id_idx ON user_demographic USING btree (parent_user_id);


--
-- Name: user_school_district_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_school_district_id_idx ON user_demographic USING btree (school_district_id);


--
-- Name: user_school_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_school_id_idx ON user_demographic USING btree (school_id);


--
-- Name: user_state_id_idx; Type: INDEX; Schema: public; Owner: nucleus; Tablespace: 
--

CREATE INDEX user_state_id_idx ON user_demographic USING btree (state_id);


--
-- Name: code_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY code
    ADD CONSTRAINT code_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: default_course_default_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_course
    ADD CONSTRAINT default_course_default_subject_id_fkey FOREIGN KEY (default_subject_id) REFERENCES default_subject(default_subject_id);


--
-- Name: default_subdomain_default_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_subdomain
    ADD CONSTRAINT default_subdomain_default_course_id_fkey FOREIGN KEY (default_course_id) REFERENCES default_course(default_course_id);


--
-- Name: default_subdomain_default_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_subdomain
    ADD CONSTRAINT default_subdomain_default_domain_id_fkey FOREIGN KEY (default_domain_id) REFERENCES default_domain(default_domain_id);


--
-- Name: default_subject_default_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY default_subject
    ADD CONSTRAINT default_subject_default_standard_framework_code_fkey FOREIGN KEY (default_standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: taxonomy_code_default_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_code
    ADD CONSTRAINT taxonomy_code_default_code_id_fkey FOREIGN KEY (default_code_id) REFERENCES default_code(default_code_id);


--
-- Name: taxonomy_code_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_code
    ADD CONSTRAINT taxonomy_code_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: taxonomy_course_default_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_course
    ADD CONSTRAINT taxonomy_course_default_course_id_fkey FOREIGN KEY (default_course_id) REFERENCES default_course(default_course_id);


--
-- Name: taxonomy_course_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_course
    ADD CONSTRAINT taxonomy_course_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: taxonomy_course_taxonomy_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_course
    ADD CONSTRAINT taxonomy_course_taxonomy_subject_id_fkey FOREIGN KEY (taxonomy_subject_id) REFERENCES taxonomy_subject(taxonomy_subject_id);


--
-- Name: taxonomy_domain_default_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_domain
    ADD CONSTRAINT taxonomy_domain_default_domain_id_fkey FOREIGN KEY (default_domain_id) REFERENCES default_domain(default_domain_id);


--
-- Name: taxonomy_domain_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_domain
    ADD CONSTRAINT taxonomy_domain_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: taxonomy_learning_target_map_default_learning_target_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_learning_target_map
    ADD CONSTRAINT taxonomy_learning_target_map_default_learning_target_code_fkey FOREIGN KEY (default_learning_target_code) REFERENCES default_code(code);


--
-- Name: taxonomy_learning_target_map_default_subject_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_learning_target_map
    ADD CONSTRAINT taxonomy_learning_target_map_default_subject_code_fkey FOREIGN KEY (default_subject_code) REFERENCES default_subject(code);


--
-- Name: taxonomy_standard_map_default_standard_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_standard_map
    ADD CONSTRAINT taxonomy_standard_map_default_standard_code_fkey FOREIGN KEY (default_standard_code) REFERENCES default_code(code);


--
-- Name: taxonomy_standard_map_default_subject_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_standard_map
    ADD CONSTRAINT taxonomy_standard_map_default_subject_code_fkey FOREIGN KEY (default_subject_code) REFERENCES default_subject(code);


--
-- Name: taxonomy_subdomain_default_subdomain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subdomain
    ADD CONSTRAINT taxonomy_subdomain_default_subdomain_id_fkey FOREIGN KEY (default_subdomain_id) REFERENCES default_subdomain(default_subdomain_id);


--
-- Name: taxonomy_subdomain_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subdomain
    ADD CONSTRAINT taxonomy_subdomain_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: taxonomy_subdomain_taxonomy_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subdomain
    ADD CONSTRAINT taxonomy_subdomain_taxonomy_course_id_fkey FOREIGN KEY (taxonomy_course_id) REFERENCES taxonomy_course(taxonomy_course_id);


--
-- Name: taxonomy_subdomain_taxonomy_domain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subdomain
    ADD CONSTRAINT taxonomy_subdomain_taxonomy_domain_id_fkey FOREIGN KEY (taxonomy_domain_id) REFERENCES taxonomy_domain(taxonomy_domain_id);


--
-- Name: taxonomy_subject_default_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subject
    ADD CONSTRAINT taxonomy_subject_default_subject_id_fkey FOREIGN KEY (default_subject_id) REFERENCES default_subject(default_subject_id);


--
-- Name: taxonomy_subject_standard_framework_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY taxonomy_subject
    ADD CONSTRAINT taxonomy_subject_standard_framework_code_fkey FOREIGN KEY (standard_framework_code) REFERENCES standard_framework(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


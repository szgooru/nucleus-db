--
-- Name: school_district; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE school_district (
    school_district_id character(36) NOT NULL,
    name character(2000) NOT NULL,
    code character(1000) NOT NULL,
    creator_id character(36),
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()),
    modified timestamp without time zone DEFAULT timezone('UTC'::text, now())
);

--
-- Name: TABLE school_district; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE school_district IS 'It has the list of school district details.';


--
-- Name: school_district_id_pk; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY school_district
    ADD CONSTRAINT school_district_id_pk PRIMARY KEY (school_district_id);


--
-- Name: creator_id_bt; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX creator_id_bt ON school_district USING btree (creator_id);


--
-- PostgreSQL database dump complete
--

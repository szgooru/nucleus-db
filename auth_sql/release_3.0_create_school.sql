--
-- Name: school; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE school (
    school_id character varying(36) NOT NULL,
    school_district_id character varying(36) NOT NULL,
    name character(2000) NOT NULL,
    code character(1000) NOT NULL,
    creator_id character(36),
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    modified timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);


--
-- Name: TABLE school; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE school IS 'It has the list of school details.';


--
-- Name: school_id_pk; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY school
    ADD CONSTRAINT school_id_pk PRIMARY KEY (school_id);


--
-- Name: school_creator_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX school_creator_id ON school USING btree (creator_id);


--
-- Name: school_district_id; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY school
    ADD CONSTRAINT school_district_id FOREIGN KEY (school_district_id) REFERENCES school_district(school_district_id);


--
-- PostgreSQL database dump complete
--

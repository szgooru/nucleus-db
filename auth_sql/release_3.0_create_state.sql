--
-- Name: state; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE state (
    state_id bigint NOT NULL,
    country_id bigint NOT NULL,
    name character(2000) NOT NULL,
    code character(1000) NOT NULL,
    creator_id character(36),
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL
);

--
-- Name: TABLE state; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE state IS 'it has the list of states in country';


--
-- Name: COLUMN state.created; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN state.created IS 'DEFAULT (NOW() AT TIME ZONE ''UTC'')';


--
-- Name: COLUMN state.modified; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN state.modified IS 'DEFAULT (NOW() AT TIME ZONE ''UTC'')';


--
-- Name: state_country_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE state_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE state_country_id_seq OWNER TO nucleus;

--
-- Name: state_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE state_country_id_seq OWNED BY state.country_id;


--
-- Name: state_state_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE state_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE state_state_id_seq OWNER TO nucleus;

--
-- Name: state_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE state_state_id_seq OWNED BY state.state_id;


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state_id, country_id);


--
-- Name: code; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX code ON state USING btree (code);


--
-- Name: creator_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX creator_id ON state USING btree (creator_id);


--
-- Name: country_id; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY state
    ADD CONSTRAINT country_id FOREIGN KEY (country_id) REFERENCES country(country_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

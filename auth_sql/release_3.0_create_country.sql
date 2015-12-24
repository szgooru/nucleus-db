--
-- Name: country; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE country (
    country_id bigint NOT NULL,
    name character(2000) NOT NULL,
    code character(1000) NOT NULL,
    creator_id character(36),
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL
);

--
-- Name: TABLE country; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE country IS 'it has the list of country details';


--
-- Name: COLUMN country.created; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN country.created IS 'DEFAULT (NOW() AT TIME ZONE ''UTC'')';


--
-- Name: COLUMN country.modified; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN country.modified IS 'DEFAULT (NOW() AT TIME ZONE ''UTC'')';


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

ALTER SEQUENCE country_country_id_seq OWNED BY country.country_id;


--
-- Name: country_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- PostgreSQL database dump complete
--

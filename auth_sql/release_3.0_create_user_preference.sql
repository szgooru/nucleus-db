--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE user_preference (
    user_id character(36) NOT NULL,
    standard_preference jsonb NOT NULL,
    profile_visiblity bit(1) NOT NULL
);


--
-- Name: TABLE user_preference; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE user_preference IS 'used to store the user preference details like taxonomy preference, profile visibility  etc..';


--
-- Name: COLUMN user_preference.standard_preference; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN user_preference.standard_preference IS 'Used to store the standard preference as json object ';


--
-- Name: user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

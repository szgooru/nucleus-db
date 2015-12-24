--
-- Name: user_google_drive_connect; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE user_google_drive_connect (
    user_id character(36) NOT NULL,
    connected_email_id character(256) NOT NULL,
    refresh_token character(2000) NOT NULL,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    modified timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
);

--
-- Name: TABLE user_google_drive_connect; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE user_google_drive_connect IS 'it has the google drive connect details, like google access token, refresh token, connected gmail etc';


--
-- Name: user_google_drive_connect_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_google_drive_connect
    ADD CONSTRAINT user_google_drive_connect_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

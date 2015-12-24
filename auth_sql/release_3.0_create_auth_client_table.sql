--
-- Name: auth_client; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE auth_client (
    client_id character(36) NOT NULL,
    name character(256) NOT NULL,
    url character(2000),
    client_key character(64) NOT NULL,
    description character(5000),
    contact_email character(256),
    access_token_validity integer NOT NULL,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    modified timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    grant_types jsonb NOT NULL,
    referer_domains jsonb
);

--
-- Name: TABLE auth_client; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE auth_client IS 'It has all the details about the application client like secret key, client id, grant types and token validity.';


--
-- Name: COLUMN auth_client.access_token_validity; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN auth_client.access_token_validity IS 'Access token validity in secs';


--
-- Name: COLUMN auth_client.grant_types; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN auth_client.grant_types IS 'grant types can be credentials,anonymous, google_sso_authorize,wsfed_sso_authorize,saml_sso_authorize etc';


--
-- Name: COLUMN auth_client.referer_domains; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN auth_client.referer_domains IS 'It has the list of white list domains';


--
-- Name: auth_client_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY auth_client
    ADD CONSTRAINT auth_client_pkey PRIMARY KEY (client_id);


--
-- Name: auth_client_key; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX auth_client_key ON auth_client USING btree (client_key);


--
-- PostgreSQL database dump complete
--

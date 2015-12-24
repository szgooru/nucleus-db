--
-- Name: user_identity; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE user_identity (
    identity_id bigint NOT NULL,
    user_id character(36) NOT NULL,
    username character(32) NOT NULL,
    reference_id character(100),
    email_id character(256),
    password character(64),
    client_id character(36) NOT NULL,
    login_type user_identity_type NOT NULL,
    provision_type user_identity_type NOT NULL,
    email_confirm_status bit(1) NOT NULL,
    status user_identity_status NOT NULL,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL
);

--
-- Name: TABLE user_identity; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE user_identity IS 'Used to store the user identity, user can store the multiple identity for the same account. ';


--
-- Name: COLUMN user_identity.reference_id; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN user_identity.reference_id IS 'Some of the SSO authentication does not have email id in that case we have to store the reference id ';


--
-- Name: COLUMN user_identity.login_type; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN user_identity.login_type IS 'it''s  used to maintain which mode(google, wsfed,smal, credential) user used to login';


--
-- Name: COLUMN user_identity.provision_type; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN user_identity.provision_type IS 'It''s used to store  which mode(google, wsfed,smal, credential)  the identity get created';


--
-- Name: user_identity_identity_id_seq; Type: SEQUENCE; Schema: public; Owner: nucleus
--

CREATE SEQUENCE user_identity_identity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_identity_identity_id_seq OWNER TO nucleus;

--
-- Name: user_identity_identity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: nucleus
--

ALTER SEQUENCE user_identity_identity_id_seq OWNED BY user_identity.identity_id;


--
-- Name: email_id; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT email_id UNIQUE (email_id);


--
-- Name: reference_id; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT reference_id UNIQUE (reference_id);


--
-- Name: user_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_identity_pkey PRIMARY KEY (identity_id);


--
-- Name: username; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT username UNIQUE (username);


--
-- Name: email_confirm_status; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX email_confirm_status ON user_identity USING btree (email_confirm_status);


--
-- Name: password; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX password ON user_identity USING btree (password);


--
-- Name: status; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX status ON user_identity USING btree (status);


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX user_id ON user_identity USING btree (user_id);


--
-- Name: client_id; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT client_id FOREIGN KEY (client_id) REFERENCES auth_client(client_id);


--
-- Name: user_id; Type: FK CONSTRAINT; Schema: public; Owner: nucleus
--

ALTER TABLE ONLY user_identity
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

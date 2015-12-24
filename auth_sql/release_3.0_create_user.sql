--
-- Name: user; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE "user" (
    user_id character(36) NOT NULL,
    firstname character(100),
    lastname character(100),
    parent_user_id character(36) NOT NULL,
    user_category user_category NOT NULL,
    created timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    modified timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    modified_by character(36) NOT NULL,
    last_login timestamp without time zone,
    birth_date timestamp without time zone,
    grade jsonb,
    thumbnail_path character(1000),
    gender user_gender  NULL,
    about_me character(5000),
    school_id character(36),
    school_district_id character(36),
    email character(256),
    country_id bigint,
    state_id bigint
);

--
-- Name: email; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT email UNIQUE (email);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (user_id);


--
-- Name: country_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX country_id ON "user" USING btree (country_id);


--
-- Name: parent_user_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX parent_user_id ON "user" USING btree (parent_user_id);


--
-- Name: school_district_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX school_district_id ON "user" USING btree (school_district_id);


--
-- Name: school_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX school_id ON "user" USING btree (school_id);


--
-- Name: state_id; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX state_id ON "user" USING btree (state_id);


--
-- Name: user_category; Type: INDEX; Schema: public; Owner: nucleus; Tablespace:
--

CREATE INDEX user_category ON "user" USING btree (user_category);


--
-- PostgreSQL database dump complete
--

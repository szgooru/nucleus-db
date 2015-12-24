--
-- Name: user_permission; Type: TABLE; Schema: public; Owner: nucleus; Tablespace:
--

CREATE TABLE user_permission (
    user_id character(36) NOT NULL,
    permission jsonb
);

--
-- Name: TABLE user_permission; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON TABLE user_permission IS 'used to store the permission details like content_admin, super_admin  etc..';


--
-- Name: COLUMN user_permission.permission; Type: COMMENT; Schema: public; Owner: nucleus
--

COMMENT ON COLUMN user_permission.permission IS 'used to store the user permission details like json array format like [''content_admin'', ''super_admin'']';


--
-- Name: user_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: nucleus; Tablespace:
--

ALTER TABLE ONLY user_permission
    ADD CONSTRAINT user_permission_pkey PRIMARY KEY (user_id);


--
-- PostgreSQL database dump complete
--

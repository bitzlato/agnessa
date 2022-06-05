SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: cosine_similarity(double precision[], double precision[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cosine_similarity(vector1 double precision[], vector2 double precision[]) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
        BEGIN
          RETURN ( SELECT ((SELECT public.dot_product(vector1, vector2) as dot_pod)/((SELECT public.vector_norm(vector1) as norm1) * (SELECT public.vector_norm(vector2) as norm2)))  AS similarity_value);
        END;
      $$;


--
-- Name: FUNCTION cosine_similarity(vector1 double precision[], vector2 double precision[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.cosine_similarity(vector1 double precision[], vector2 double precision[]) IS 'this function is used to find a cosine similarity between two vector';


--
-- Name: dot_product(double precision[], double precision[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.dot_product(vector1 double precision[], vector2 double precision[]) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
        BEGIN
          RETURN(SELECT sum(mul) FROM (SELECT v1e*v2e as mul FROM unnest(vector1, vector2) AS t(v1e,v2e)) AS denominator);
        END;
      $$;


--
-- Name: FUNCTION dot_product(vector1 double precision[], vector2 double precision[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.dot_product(vector1 double precision[], vector2 double precision[]) IS 'This function is used to find a cosine similarity between two multi-dimensional vectors.';


--
-- Name: vector_norm(double precision[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.vector_norm(vector double precision[]) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
        BEGIN
          RETURN(SELECT SQRT(SUM(pow)) FROM (SELECT POWER(e,2) as pow from unnest(vector) as e) as norm);
        END;
      $$;


--
-- Name: FUNCTION vector_norm(vector double precision[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.vector_norm(vector double precision[]) IS 'This function is used to find a norm of vectors.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    subdomain character varying NOT NULL,
    secret character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    verification_callback_url character varying,
    email_from character varying,
    return_url character varying,
    form_description text,
    api_jwt_algorithm character varying DEFAULT 'ES256'::character varying NOT NULL,
    api_jwt_public_key jsonb
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: applicants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applicants (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    external_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    first_name public.citext,
    last_name public.citext,
    last_confirmed_verification_id bigint,
    confirmed_at timestamp without time zone,
    patronymic public.citext,
    emails jsonb DEFAULT '[]'::jsonb NOT NULL,
    legacy_external_id character varying
);


--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applicants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applicants_id_seq OWNED BY public.applicants.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    iso_code character varying NOT NULL,
    title_ru character varying NOT NULL,
    title_en character varying NOT NULL,
    id_types jsonb DEFAULT '[]'::jsonb NOT NULL,
    archived_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: document_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_types (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    file_type character varying NOT NULL,
    title character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: document_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.document_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.document_types_id_seq OWNED BY public.document_types.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invites (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id integer NOT NULL,
    inviter_id integer NOT NULL,
    email public.citext NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token character varying NOT NULL
);


--
-- Name: log_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.log_records (
    id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    verification_id bigint,
    member_id bigint,
    action character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: log_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.log_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.log_records_id_seq OWNED BY public.log_records.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id bigint NOT NULL,
    role character varying DEFAULT 'operator'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL,
    archived_at timestamp without time zone,
    inviter_id bigint
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: review_result_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_result_labels (
    id bigint NOT NULL,
    label character varying,
    public_comment text,
    final boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    label_ru character varying
);


--
-- Name: review_result_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_result_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_result_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_result_labels_id_seq OWNED BY public.review_result_labels.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    first_name character varying,
    last_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    crypted_password character varying,
    salt character varying,
    reset_password_token character varying,
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    access_count_to_reset_password_page integer DEFAULT 0,
    failed_logins_count integer DEFAULT 0,
    lock_expires_at timestamp without time zone,
    unlock_token character varying,
    remember_me_token character varying,
    remember_me_token_expires_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: verification_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verification_documents (
    id bigint NOT NULL,
    verification_id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    file character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    vector double precision[]
);


--
-- Name: verification_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verification_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verification_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verification_documents_id_seq OWNED BY public.verification_documents.id;


--
-- Name: verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verifications (
    id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    country character varying(2),
    legacy_external_id character varying,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    commment character varying,
    kind integer,
    legacy_documents json DEFAULT '[]'::json,
    external_json json DEFAULT '{}'::json,
    params json DEFAULT '{}'::json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reason character varying,
    name public.citext,
    last_name public.citext,
    document_number character varying,
    moderator_id integer,
    comment character varying,
    email public.citext,
    public_comment text,
    private_comment text,
    review_result_labels json DEFAULT '[]'::json,
    patronymic public.citext,
    birth_date date,
    gender character varying,
    applicant_comment text,
    remote_ip character varying,
    user_agent character varying,
    number character varying
);


--
-- Name: verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verifications_id_seq OWNED BY public.verifications.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants ALTER COLUMN id SET DEFAULT nextval('public.applicants_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: document_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_types ALTER COLUMN id SET DEFAULT nextval('public.document_types_id_seq'::regclass);


--
-- Name: log_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_records ALTER COLUMN id SET DEFAULT nextval('public.log_records_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: review_result_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_result_labels ALTER COLUMN id SET DEFAULT nextval('public.review_result_labels_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: verification_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_documents ALTER COLUMN id SET DEFAULT nextval('public.verification_documents_id_seq'::regclass);


--
-- Name: verifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifications ALTER COLUMN id SET DEFAULT nextval('public.verifications_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: document_types document_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT document_types_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: log_records log_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_records
    ADD CONSTRAINT log_records_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: review_result_labels review_result_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_result_labels
    ADD CONSTRAINT review_result_labels_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: verification_documents verification_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_documents
    ADD CONSTRAINT verification_documents_pkey PRIMARY KEY (id);


--
-- Name: verifications verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_subdomain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_on_subdomain ON public.accounts USING btree (subdomain);


--
-- Name: index_applicants_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_account_id ON public.applicants USING btree (account_id);


--
-- Name: index_applicants_on_account_id_and_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_applicants_on_account_id_and_external_id ON public.applicants USING btree (account_id, external_id);


--
-- Name: index_countries_on_iso_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_countries_on_iso_code ON public.countries USING btree (iso_code);


--
-- Name: index_document_types_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_types_on_account_id ON public.document_types USING btree (account_id);


--
-- Name: index_document_types_on_account_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_document_types_on_account_id_and_title ON public.document_types USING btree (account_id, title);


--
-- Name: index_invites_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invites_on_account_id ON public.invites USING btree (account_id);


--
-- Name: index_invites_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invites_on_email ON public.invites USING btree (email);


--
-- Name: index_invites_on_inviter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invites_on_inviter_id ON public.invites USING btree (inviter_id);


--
-- Name: index_invites_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invites_on_token ON public.invites USING btree (token);


--
-- Name: index_log_records_on_applicant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_records_on_applicant_id ON public.log_records USING btree (applicant_id);


--
-- Name: index_log_records_on_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_records_on_member_id ON public.log_records USING btree (member_id);


--
-- Name: index_log_records_on_verification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_log_records_on_verification_id ON public.log_records USING btree (verification_id);


--
-- Name: index_members_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_account_id ON public.members USING btree (account_id);


--
-- Name: index_members_on_inviter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_inviter_id ON public.members USING btree (inviter_id);


--
-- Name: index_members_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_user_id ON public.members USING btree (user_id);


--
-- Name: index_members_on_user_id_and_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_members_on_user_id_and_account_id ON public.members USING btree (user_id, account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_remember_me_token ON public.users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_verification_documents_on_document_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_verification_documents_on_document_type_id ON public.verification_documents USING btree (document_type_id);


--
-- Name: index_verification_documents_on_verification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_verification_documents_on_verification_id ON public.verification_documents USING btree (verification_id);


--
-- Name: index_verifications_on_applicant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_verifications_on_applicant_id ON public.verifications USING btree (applicant_id);


--
-- Name: index_verifications_on_legacy_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_verifications_on_legacy_external_id ON public.verifications USING btree (legacy_external_id);


--
-- Name: index_verifications_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_verifications_on_number ON public.verifications USING btree (number);


--
-- Name: members fk_rails_2e88fb7ce9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT fk_rails_2e88fb7ce9 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: verifications fk_rails_3700e5de81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verifications
    ADD CONSTRAINT fk_rails_3700e5de81 FOREIGN KEY (applicant_id) REFERENCES public.applicants(id);


--
-- Name: log_records fk_rails_5621998c82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_records
    ADD CONSTRAINT fk_rails_5621998c82 FOREIGN KEY (verification_id) REFERENCES public.verifications(id);


--
-- Name: verification_documents fk_rails_7349780761; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_documents
    ADD CONSTRAINT fk_rails_7349780761 FOREIGN KEY (verification_id) REFERENCES public.verifications(id);


--
-- Name: members fk_rails_91818ac2d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT fk_rails_91818ac2d3 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: document_types fk_rails_96e4b63413; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_types
    ADD CONSTRAINT fk_rails_96e4b63413 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: members fk_rails_d9a72144ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT fk_rails_d9a72144ca FOREIGN KEY (inviter_id) REFERENCES public.users(id);


--
-- Name: applicants fk_rails_e47cfc2b15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT fk_rails_e47cfc2b15 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: log_records fk_rails_f0248438a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_records
    ADD CONSTRAINT fk_rails_f0248438a2 FOREIGN KEY (applicant_id) REFERENCES public.applicants(id);


--
-- Name: verification_documents fk_rails_ff7a2e3d45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_documents
    ADD CONSTRAINT fk_rails_ff7a2e3d45 FOREIGN KEY (document_type_id) REFERENCES public.document_types(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220127072445'),
('20220301070337'),
('20220313081805'),
('20220314122203'),
('20220315114236'),
('20220316123017'),
('20220318115534'),
('20220321132359'),
('20220322104451'),
('20220322113246'),
('20220323061342'),
('20220323070822'),
('20220323075100'),
('20220323081612'),
('20220323083627'),
('20220324183541'),
('20220325112048'),
('20220329160322'),
('20220329164958'),
('20220330045211'),
('20220330065344'),
('20220330080203'),
('20220330080443'),
('20220330081801'),
('20220330132444'),
('20220331051929'),
('20220331111319'),
('20220401095142'),
('20220405075518'),
('20220406104412'),
('20220406171921'),
('20220406172201'),
('20220406173651'),
('20220407104828'),
('20220407141738'),
('20220407141831'),
('20220407151056'),
('20220408060206'),
('20220408143753'),
('20220411075404'),
('20220411090422'),
('20220412084508'),
('20220413143951'),
('20220415060521'),
('20220415072537'),
('20220415110908'),
('20220425123317'),
('20220427110134'),
('20220513073228'),
('20220517083538'),
('20220518074223'),
('20220524062435'),
('20220524065820'),
('20220526093309'),
('20220530165536'),
('20220531091059'),
('20220601092006'),
('20220602065948'),
('20220602135156');



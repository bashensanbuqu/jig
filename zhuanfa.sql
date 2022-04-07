--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6
-- Dumped by pg_dump version 13.6

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

ALTER TABLE ONLY public.server_user DROP CONSTRAINT server_user_user_id_fkey;
ALTER TABLE ONLY public.server_user DROP CONSTRAINT server_user_server_id_fkey;
ALTER TABLE ONLY public.port_user DROP CONSTRAINT port_user_user_id_fkey;
ALTER TABLE ONLY public.port_user DROP CONSTRAINT port_user_port_id_fkey;
ALTER TABLE ONLY public.port_usage DROP CONSTRAINT port_usage_port_id_fkey;
ALTER TABLE ONLY public.port DROP CONSTRAINT port_server_id_fkey;
ALTER TABLE ONLY public.port_forward_rule DROP CONSTRAINT port_forward_rule_port_id_fkey;
DROP INDEX public.ix_user_id;
DROP INDEX public.ix_user_email;
DROP INDEX public.ix_server_user_id;
DROP INDEX public.ix_server_name;
DROP INDEX public.ix_server_id;
DROP INDEX public.ix_port_user_id;
DROP INDEX public.ix_port_usage_id;
DROP INDEX public.ix_port_id;
DROP INDEX public.ix_port_forward_rule_id;
ALTER TABLE ONLY public."user" DROP CONSTRAINT user_pkey;
ALTER TABLE ONLY public.server_user DROP CONSTRAINT server_user_pkey;
ALTER TABLE ONLY public.server DROP CONSTRAINT server_pkey;
ALTER TABLE ONLY public.port_user DROP CONSTRAINT port_user_pkey;
ALTER TABLE ONLY public.port_usage DROP CONSTRAINT port_usage_pkey;
ALTER TABLE ONLY public.port DROP CONSTRAINT port_pkey;
ALTER TABLE ONLY public.port_forward_rule DROP CONSTRAINT port_forward_rule_pkey;
ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
ALTER TABLE ONLY public.server_user DROP CONSTRAINT _server_user_server_id_user_id_uc;
ALTER TABLE ONLY public.server DROP CONSTRAINT _server_ansible_name_uc;
ALTER TABLE ONLY public.server DROP CONSTRAINT _server_ansible_host_ansible_port_uc;
ALTER TABLE ONLY public.port_user DROP CONSTRAINT _port_user_server_id_user_id_uc;
ALTER TABLE ONLY public.port_usage DROP CONSTRAINT _port_usage_port_id_uc;
ALTER TABLE ONLY public.port DROP CONSTRAINT _port_num_server_uc;
ALTER TABLE ONLY public.port DROP CONSTRAINT _port_external_num_server_uc;
ALTER TABLE public."user" ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.server_user ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.server ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.port_user ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.port_usage ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.port_forward_rule ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.port ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_id_seq;
DROP TABLE public."user";
DROP SEQUENCE public.server_user_id_seq;
DROP TABLE public.server_user;
DROP SEQUENCE public.server_id_seq;
DROP TABLE public.server;
DROP SEQUENCE public.port_user_id_seq;
DROP TABLE public.port_user;
DROP SEQUENCE public.port_usage_id_seq;
DROP TABLE public.port_usage;
DROP SEQUENCE public.port_id_seq;
DROP SEQUENCE public.port_forward_rule_id_seq;
DROP TABLE public.port_forward_rule;
DROP TABLE public.port;
DROP TABLE public.alembic_version;
DROP TYPE public.methodenum;
--
-- Name: methodenum; Type: TYPE; Schema: public; Owner: aurora
--

CREATE TYPE public.methodenum AS ENUM (
    'IPTABLES',
    'GOST',
    'EHCO',
    'V2RAY',
    'SOCAT',
    'BROOK',
    'WSTUNNEL',
    'NODE_EXPORTER',
    'TINY_PORT_MAPPER',
    'SHADOWSOCKS',
    'CADDY',
    'IPERF',
    'REALM',
    'HAPROXY'
);


ALTER TYPE public.methodenum OWNER TO aurora;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO aurora;

--
-- Name: port; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.port (
    id integer NOT NULL,
    external_num integer,
    num integer NOT NULL,
    server_id integer,
    config json NOT NULL,
    is_active boolean,
    notes text
);


ALTER TABLE public.port OWNER TO aurora;

--
-- Name: port_forward_rule; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.port_forward_rule (
    id integer NOT NULL,
    port_id integer NOT NULL,
    config json NOT NULL,
    method public.methodenum NOT NULL,
    status character varying,
    is_active boolean
);


ALTER TABLE public.port_forward_rule OWNER TO aurora;

--
-- Name: port_forward_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.port_forward_rule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_forward_rule_id_seq OWNER TO aurora;

--
-- Name: port_forward_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.port_forward_rule_id_seq OWNED BY public.port_forward_rule.id;


--
-- Name: port_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.port_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_id_seq OWNER TO aurora;

--
-- Name: port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.port_id_seq OWNED BY public.port.id;


--
-- Name: port_usage; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.port_usage (
    id integer NOT NULL,
    port_id integer NOT NULL,
    download bigint NOT NULL,
    upload bigint NOT NULL,
    download_accumulate bigint NOT NULL,
    upload_accumulate bigint NOT NULL,
    download_checkpoint bigint NOT NULL,
    upload_checkpoint bigint NOT NULL
);


ALTER TABLE public.port_usage OWNER TO aurora;

--
-- Name: port_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.port_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_usage_id_seq OWNER TO aurora;

--
-- Name: port_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.port_usage_id_seq OWNED BY public.port_usage.id;


--
-- Name: port_user; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.port_user (
    id integer NOT NULL,
    port_id integer NOT NULL,
    user_id integer NOT NULL,
    config json NOT NULL
);


ALTER TABLE public.port_user OWNER TO aurora;

--
-- Name: port_user_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.port_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_user_id_seq OWNER TO aurora;

--
-- Name: port_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.port_user_id_seq OWNED BY public.port_user.id;


--
-- Name: server; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.server (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    ansible_name character varying NOT NULL,
    ansible_host character varying,
    ansible_port integer,
    ansible_user character varying,
    config json NOT NULL,
    ssh_password character varying,
    sudo_password character varying,
    is_active boolean
);


ALTER TABLE public.server OWNER TO aurora;

--
-- Name: server_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_id_seq OWNER TO aurora;

--
-- Name: server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.server_id_seq OWNED BY public.server.id;


--
-- Name: server_user; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public.server_user (
    id integer NOT NULL,
    server_id integer NOT NULL,
    user_id integer NOT NULL,
    config json NOT NULL,
    download bigint NOT NULL,
    upload bigint NOT NULL,
    notes text
);


ALTER TABLE public.server_user OWNER TO aurora;

--
-- Name: server_user_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.server_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_user_id_seq OWNER TO aurora;

--
-- Name: server_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.server_user_id_seq OWNED BY public.server_user.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: aurora
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    hashed_password character varying NOT NULL,
    is_active boolean,
    is_ops boolean,
    is_superuser boolean,
    notes text
);


ALTER TABLE public."user" OWNER TO aurora;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: aurora
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO aurora;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aurora
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: port id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port ALTER COLUMN id SET DEFAULT nextval('public.port_id_seq'::regclass);


--
-- Name: port_forward_rule id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_forward_rule ALTER COLUMN id SET DEFAULT nextval('public.port_forward_rule_id_seq'::regclass);


--
-- Name: port_usage id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_usage ALTER COLUMN id SET DEFAULT nextval('public.port_usage_id_seq'::regclass);


--
-- Name: port_user id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_user ALTER COLUMN id SET DEFAULT nextval('public.port_user_id_seq'::regclass);


--
-- Name: server id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server ALTER COLUMN id SET DEFAULT nextval('public.server_id_seq'::regclass);


--
-- Name: server_user id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server_user ALTER COLUMN id SET DEFAULT nextval('public.server_user_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.alembic_version (version_num) FROM stdin;
ea4a5dba09c3
\.


--
-- Data for Name: port; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.port (id, external_num, num, server_id, config, is_active, notes) FROM stdin;
3	\N	4002	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
2	\N	4003	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
1	\N	4004	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
4	\N	4005	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
6	\N	4006	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
8	\N	4007	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
7	\N	4008	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
9	\N	4009	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
10	\N	4010	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
11	\N	4011	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
12	\N	4012	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
13	\N	4013	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
14	\N	4014	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
17	\N	4015	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
16	\N	4016	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
15	\N	4017	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
18	\N	4018	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
20	\N	4019	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
19	\N	4020	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
21	\N	5001	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
22	\N	5002	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
25	\N	5003	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
24	\N	5004	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
27	\N	5005	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
26	\N	5006	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
23	\N	5007	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
28	\N	5008	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
29	\N	5009	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
31	\N	5010	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
30	\N	5011	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
32	\N	5012	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
33	\N	5013	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
34	\N	5014	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
35	\N	5016	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
37	\N	5017	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
38	\N	5018	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
40	\N	5019	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
39	\N	5020	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
42	\N	6001	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
41	\N	6002	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
43	\N	6003	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
46	\N	6004	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
44	\N	6005	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
45	\N	6006	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
47	\N	6007	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
48	\N	6008	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
49	\N	6009	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
50	\N	6010	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
59	\N	6020	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
51	\N	6015	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
57	\N	6017	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
54	\N	6012	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
52	\N	6013	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
55	\N	6014	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
58	\N	6018	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
53	\N	6011	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
60	\N	6019	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
5	\N	4001	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
36	\N	5015	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
56	\N	6016	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
64	\N	7001	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
61	\N	7002	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
65	\N	7003	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
63	\N	7004	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
62	\N	7005	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
66	\N	7006	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
68	\N	7007	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
67	\N	7008	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
69	\N	7009	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
70	\N	7010	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
71	\N	7011	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
72	\N	7012	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
73	\N	7013	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
74	\N	7014	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
77	\N	7015	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
76	\N	7016	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
75	\N	7017	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
78	\N	7018	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
79	\N	7019	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
80	\N	7020	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
91	\N	8011	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
93	\N	8012	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
92	\N	8013	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
94	\N	8014	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
95	\N	8015	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
96	\N	8016	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
98	\N	8017	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
97	\N	8018	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
100	\N	8019	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
99	\N	8020	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
81	\N	8001	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
82	\N	8002	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
83	\N	8003	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
85	\N	8004	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
87	\N	8005	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
86	\N	8006	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
84	\N	8007	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
88	\N	8008	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
89	\N	8009	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
90	\N	8010	1	{"egress_limit": 3000, "ingress_limit": 3000, "valid_until": null, "due_action": 0, "quota": null, "quota_action": 0}	t	
\.


--
-- Data for Name: port_forward_rule; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.port_forward_rule (id, port_id, config, method, status, is_active) FROM stdin;
16	16	{"type": "ALL", "remote_ip": "4.0.0.16", "remote_address": "4.0.0.16", "remote_port": 2000, "runner": "f7345ad0-f70d-43d7-a828-323c30754002"}	IPTABLES	successful	t
10	10	{"type": "ALL", "remote_ip": "4.0.0.10", "remote_address": "4.0.0.10", "remote_port": 2000, "runner": "ebbdd110-0f9f-4ca2-8cde-6a52a67acf93"}	IPTABLES	successful	t
41	42	{"type": "ALL", "remote_ip": "6.0.0.1", "remote_address": "6.0.0.1", "remote_port": 2000, "runner": "b806da13-e9f2-44c0-9071-46027f4c65af"}	IPTABLES	successful	t
3	2	{"type": "ALL", "remote_ip": "4.0.0.3", "remote_address": "4.0.0.3", "remote_port": 2000, "runner": "8a4d45d6-161b-41bf-b342-cf5da073aef8"}	IPTABLES	successful	t
11	11	{"type": "ALL", "remote_ip": "4.0.0.11", "remote_address": "4.0.0.11", "remote_port": 2000, "runner": "309070bc-1d20-4a24-bea7-9451c200b1b3"}	IPTABLES	successful	t
4	1	{"type": "ALL", "remote_ip": "4.0.0.4", "remote_address": "4.0.0.4", "remote_port": 2000, "runner": "1f122d6c-f147-49ed-a91f-fcfb7d7ea182"}	IPTABLES	successful	t
31	30	{"type": "ALL", "remote_ip": "5.0.0.11", "remote_address": "5.0.0.11", "remote_port": 2000, "runner": "d5c59173-7cd1-449f-8701-829e545397ca"}	IPTABLES	successful	t
17	15	{"type": "ALL", "remote_ip": "4.0.0.17", "remote_address": "4.0.0.17", "remote_port": 2000, "runner": "7f7e01f6-6ff7-4b43-a1a3-9e085e8761f2"}	IPTABLES	successful	t
5	4	{"type": "ALL", "remote_ip": "4.0.0.5", "remote_address": "4.0.0.5", "remote_port": 2000, "runner": "2efb66b2-492d-4bc7-a2ad-f08bd2711972"}	IPTABLES	successful	t
12	12	{"type": "ALL", "remote_ip": "4.0.0.12", "remote_address": "4.0.0.12", "remote_port": 2000, "runner": "04d3be2b-5d43-471c-9880-7ba04d73f74d"}	IPTABLES	successful	t
25	27	{"type": "ALL", "remote_ip": "5.0.0.5", "remote_address": "5.0.0.5", "remote_port": 2000, "runner": "ad4070d3-e3ae-46de-b0c0-ae81737fc320"}	IPTABLES	successful	t
6	6	{"type": "ALL", "remote_ip": "4.0.0.6", "remote_address": "4.0.0.6", "remote_port": 2000, "runner": "5bcfa1fc-9f7e-45d0-aa3a-ba13cadb8901"}	IPTABLES	successful	t
22	22	{"type": "ALL", "remote_ip": "5.0.0.2", "remote_address": "5.0.0.2", "remote_port": 2000, "runner": "7256a6c4-02db-4799-87da-34484b527cd4"}	IPTABLES	successful	t
13	13	{"type": "ALL", "remote_ip": "4.0.0.13", "remote_address": "4.0.0.13", "remote_port": 2000, "runner": "24885ebc-10c2-4b04-a8b7-38548d90d109"}	IPTABLES	successful	t
7	8	{"type": "ALL", "remote_ip": "4.0.0.7", "remote_address": "4.0.0.7", "remote_port": 2000, "runner": "aa79376c-8527-44bf-924c-82cf82644a99"}	IPTABLES	successful	t
19	20	{"type": "ALL", "remote_ip": "4.0.0.19", "remote_address": "4.0.0.19", "remote_port": 2000, "runner": "e19d5c99-4516-4ca8-ae42-e3e6e5744dc4"}	IPTABLES	successful	t
8	7	{"type": "ALL", "remote_ip": "4.0.0.8", "remote_address": "4.0.0.8", "remote_port": 2000, "runner": "bf7c8d37-0f57-459b-bed7-1f80b6f717a6"}	IPTABLES	successful	t
14	14	{"type": "ALL", "remote_ip": "4.0.0.14", "remote_address": "4.0.0.14", "remote_port": 2000, "runner": "d03a4052-d992-4cf7-98b4-c37a5d33c366"}	IPTABLES	successful	t
28	28	{"type": "ALL", "remote_ip": "5.0.0.8", "remote_address": "5.0.0.8", "remote_port": 2000, "runner": "294cbef7-8f25-4ebe-9788-5e48badddd5c"}	IPTABLES	successful	t
9	9	{"type": "ALL", "remote_ip": "4.0.0.9", "remote_address": "4.0.0.9", "remote_port": 2000, "runner": "a96c931f-d61f-44a0-aea3-757e90cbdaaf"}	IPTABLES	successful	t
20	19	{"type": "ALL", "remote_ip": "4.0.0.20", "remote_address": "4.0.0.20", "remote_port": 2000, "runner": "287f7045-33c2-4e18-92c4-111b9d6e2c5e"}	IPTABLES	successful	t
15	17	{"type": "ALL", "remote_ip": "4.0.0.15", "remote_address": "4.0.0.15", "remote_port": 2000, "runner": "d577f5d2-b45d-4e8e-9886-2dba56f23262"}	IPTABLES	successful	t
23	25	{"type": "ALL", "remote_ip": "5.0.0.3", "remote_address": "5.0.0.3", "remote_port": 2000, "runner": "2e6a4585-04c1-4e7f-ac51-02e63978b329"}	IPTABLES	successful	t
26	26	{"type": "ALL", "remote_ip": "5.0.0.6", "remote_address": "5.0.0.6", "remote_port": 2000, "runner": "5bf40905-cdab-4a68-9204-9200633d38ac"}	IPTABLES	successful	t
33	33	{"type": "ALL", "remote_ip": "5.0.0.13", "remote_address": "5.0.0.13", "remote_port": 2000, "runner": "adc5c80e-0a97-408c-9225-a9248d1ab4a9"}	IPTABLES	successful	t
32	32	{"type": "ALL", "remote_ip": "5.0.0.12", "remote_address": "5.0.0.12", "remote_port": 2000, "runner": "e8317176-044a-44c2-8f0c-e8323f7115f5"}	IPTABLES	successful	t
24	24	{"type": "ALL", "remote_ip": "5.0.0.4", "remote_address": "5.0.0.4", "remote_port": 2000, "runner": "77c179f2-e41e-4ac6-9947-3db20deb0157"}	IPTABLES	successful	t
29	29	{"type": "ALL", "remote_ip": "5.0.0.9", "remote_address": "5.0.0.9", "remote_port": 2000, "runner": "87f71cb1-b436-44a3-8a59-42cd446c062a"}	IPTABLES	successful	t
27	23	{"type": "ALL", "remote_ip": "5.0.0.7", "remote_address": "5.0.0.7", "remote_port": 2000, "runner": "ad98c508-5f60-4304-8573-33cbaac8f3b5"}	IPTABLES	successful	t
34	34	{"type": "ALL", "remote_ip": "5.0.0.14", "remote_address": "5.0.0.14", "remote_port": 2000, "runner": "a7e8935a-fbfe-4bcb-8590-d48fad3a6c1c"}	IPTABLES	successful	t
35	36	{"type": "ALL", "remote_ip": "5.0.0.15", "remote_address": "5.0.0.15", "remote_port": 2000, "runner": "3f89607f-8972-4423-93b8-d213bdff0839"}	IPTABLES	successful	t
36	35	{"type": "ALL", "remote_ip": "5.0.0.16", "remote_address": "5.0.0.16", "remote_port": 2000, "runner": "b29c14c7-f866-4c6d-99be-a2b2181baf85"}	IPTABLES	successful	t
37	37	{"type": "ALL", "remote_ip": "5.0.0.17", "remote_address": "5.0.0.17", "remote_port": 2000, "runner": "0bdd5af3-334e-45f6-8f80-d86bd5605050"}	IPTABLES	successful	t
38	38	{"type": "ALL", "remote_ip": "5.0.0.18", "remote_address": "5.0.0.18", "remote_port": 2000, "runner": "0ed2ede5-ffda-4600-b29d-89ee42fca5f9"}	IPTABLES	successful	t
21	21	{"type": "ALL", "remote_ip": "5.0.0.1", "remote_address": "5.0.0.1", "remote_port": 2000, "runner": "ec93a800-5265-4b09-922d-f11f844cea02"}	IPTABLES	successful	t
40	39	{"type": "ALL", "remote_ip": "5.0.0.20", "remote_address": "5.0.0.20", "remote_port": 2000, "runner": "359d12f4-c997-449a-bdf9-1b008aa93715"}	IPTABLES	successful	t
42	41	{"type": "ALL", "remote_ip": "6.0.0.2", "remote_address": "6.0.0.2", "remote_port": 2000, "runner": "04580d3c-27fe-4047-a995-7b694d66bce3"}	IPTABLES	successful	t
63	65	{"type": "ALL", "remote_ip": "7.0.0.3", "remote_address": "7.0.0.3", "remote_port": 2000, "runner": "5881ac3f-fdcf-433a-a625-654e77b41ac0"}	IPTABLES	successful	t
2	3	{"type": "ALL", "remote_ip": "4.0.0.2", "remote_address": "4.0.0.2", "remote_port": 2000, "runner": "623bca2c-5144-4f9d-b2b9-b60a317aab9b"}	IPTABLES	successful	t
50	50	{"type": "ALL", "remote_ip": "6.0.0.10", "remote_address": "6.0.0.10", "remote_port": 2000, "runner": "5332fa31-cf03-413f-8ec0-4df387a68ac4"}	IPTABLES	successful	t
43	43	{"type": "ALL", "remote_ip": "6.0.0.3", "remote_address": "6.0.0.3", "remote_port": 2000, "runner": "cbc972ae-637f-443b-a05d-1cf879516aa7"}	IPTABLES	successful	t
56	56	{"type": "ALL", "remote_ip": "6.0.0.16", "remote_address": "6.0.0.16", "remote_port": 2000, "runner": "bfec8a89-cea6-4837-a8c8-4ba9771aa243"}	IPTABLES	successful	t
44	46	{"type": "ALL", "remote_ip": "6.0.0.4", "remote_address": "6.0.0.4", "remote_port": 2000, "runner": "a95ddfd7-7ef3-461f-9b1d-cb10e982a604"}	IPTABLES	successful	t
51	53	{"type": "ALL", "remote_ip": "6.0.0.11", "remote_address": "6.0.0.11", "remote_port": 2000, "runner": "4aa58c53-a7ca-41c4-a227-870ee20aa30f"}	IPTABLES	successful	t
45	44	{"type": "ALL", "remote_ip": "6.0.0.5", "remote_address": "6.0.0.5", "remote_port": 2000, "runner": "2046971d-09fc-4d9d-bdfe-ccffc9286cd7"}	IPTABLES	successful	t
57	57	{"type": "ALL", "remote_ip": "6.0.0.17", "remote_address": "6.0.0.17", "remote_port": 2000, "runner": "01d7a094-c8d9-40ed-998a-beebcc6415ab"}	IPTABLES	successful	t
52	54	{"type": "ALL", "remote_ip": "6.0.0.12", "remote_address": "6.0.0.12", "remote_port": 2000, "runner": "abc27551-65a7-41b7-bea6-58c81372a93c"}	IPTABLES	successful	t
46	45	{"type": "ALL", "remote_ip": "6.0.0.6", "remote_address": "6.0.0.6", "remote_port": 2000, "runner": "3739c458-fcd1-4f41-9a50-1cea34c209cf"}	IPTABLES	successful	t
69	69	{"type": "ALL", "remote_ip": "7.0.0.9", "remote_address": "7.0.0.9", "remote_port": 2000, "runner": "0b6d355c-a4c1-4e65-a3bf-08104afd35e0"}	IPTABLES	successful	t
47	47	{"type": "ALL", "remote_ip": "6.0.0.7", "remote_address": "6.0.0.7", "remote_port": 2000, "runner": "ee00a4cd-cb9f-4800-8eee-d2e302b9f5f8"}	IPTABLES	successful	t
64	63	{"type": "ALL", "remote_ip": "7.0.0.4", "remote_address": "7.0.0.4", "remote_port": 2000, "runner": "60307aa4-bf05-4740-93f3-7a9417ebfd51"}	IPTABLES	successful	t
53	52	{"type": "ALL", "remote_ip": "6.0.0.13", "remote_address": "6.0.0.13", "remote_port": 2000, "runner": "4db10420-c107-43ae-9dbc-2e1e78dbdf3c"}	IPTABLES	successful	t
48	48	{"type": "ALL", "remote_ip": "6.0.0.8", "remote_address": "6.0.0.8", "remote_port": 2000, "runner": "8e7757e4-b677-461d-850a-ad516bbcbdbd"}	IPTABLES	successful	t
58	58	{"type": "ALL", "remote_ip": "6.0.0.18", "remote_address": "6.0.0.18", "remote_port": 2000, "runner": "0732c293-7681-4886-bc01-c9bcc4607bda"}	IPTABLES	successful	t
49	49	{"type": "ALL", "remote_ip": "6.0.0.9", "remote_address": "6.0.0.9", "remote_port": 2000, "runner": "b1bf132f-84a3-4f8a-baf5-d3a8828d8d22"}	IPTABLES	successful	t
54	55	{"type": "ALL", "remote_ip": "6.0.0.14", "remote_address": "6.0.0.14", "remote_port": 2000, "runner": "4bda2f5c-22a8-4f06-b263-663045657e1e"}	IPTABLES	successful	t
59	60	{"type": "ALL", "remote_ip": "6.0.0.19", "remote_address": "6.0.0.19", "remote_port": 2000, "runner": "7fdf3553-2da0-4424-acdf-564919a91ecb"}	IPTABLES	successful	t
55	51	{"type": "ALL", "remote_ip": "6.0.0.15", "remote_address": "6.0.0.15", "remote_port": 2000, "runner": "d52930e2-6435-4bc3-b2eb-a53acc238796"}	IPTABLES	successful	t
67	68	{"type": "ALL", "remote_ip": "7.0.0.7", "remote_address": "7.0.0.7", "remote_port": 2000, "runner": "e310398c-79c7-4628-972d-af8f7e438126"}	IPTABLES	successful	t
65	62	{"type": "ALL", "remote_ip": "7.0.0.5", "remote_address": "7.0.0.5", "remote_port": 2000, "runner": "b692ab2a-0de9-4705-890c-05f6af46d4f8"}	IPTABLES	successful	t
66	66	{"type": "ALL", "remote_ip": "7.0.0.6", "remote_address": "7.0.0.6", "remote_port": 2000, "runner": "22857b5d-c1c8-42ad-8c21-67dbbafb3546"}	IPTABLES	successful	t
60	59	{"type": "ALL", "remote_ip": "6.0.0.20", "remote_address": "6.0.0.20", "remote_port": 2000, "runner": "cfb0e81c-796e-4c2c-a771-dada5f40f678"}	IPTABLES	successful	t
72	72	{"type": "ALL", "remote_ip": "7.0.0.12", "remote_address": "7.0.0.12", "remote_port": 2000, "runner": "accf0b24-652a-436b-9cf2-9621d6dacdf3"}	IPTABLES	successful	t
71	71	{"type": "ALL", "remote_ip": "7.0.0.11", "remote_address": "7.0.0.11", "remote_port": 2000, "runner": "9c027f84-b233-4648-b141-ee1343d7281b"}	IPTABLES	successful	t
68	67	{"type": "ALL", "remote_ip": "7.0.0.8", "remote_address": "7.0.0.8", "remote_port": 2000, "runner": "9fd506a8-5597-4bb6-ab3f-b4dcfddc78d6"}	IPTABLES	successful	t
70	70	{"type": "ALL", "remote_ip": "7.0.0.10", "remote_address": "7.0.0.10", "remote_port": 2000, "runner": "9a795b38-02d1-4781-a244-4c29495d0d7b"}	IPTABLES	successful	t
73	73	{"type": "ALL", "remote_ip": "7.0.0.13", "remote_address": "7.0.0.13", "remote_port": 2000, "runner": "a7f0144e-174e-4921-9be6-923d1a44ef25"}	IPTABLES	successful	t
74	74	{"type": "ALL", "remote_ip": "7.0.0.14", "remote_address": "7.0.0.14", "remote_port": 2000, "runner": "abdce49e-9a9a-45a5-8a04-f2f778fe0292"}	IPTABLES	successful	t
75	77	{"type": "ALL", "remote_ip": "7.0.0.15", "remote_address": "7.0.0.15", "remote_port": 2000, "runner": "75e68a05-7756-499b-b5e1-6e76d6b22e21"}	IPTABLES	successful	t
76	76	{"type": "ALL", "remote_ip": "7.0.0.16", "remote_address": "7.0.0.16", "remote_port": 2000, "runner": "fdbe1e6b-3a18-4ca8-981c-f168cf867a9f"}	IPTABLES	successful	t
77	75	{"type": "ALL", "remote_ip": "7.0.0.17", "remote_address": "7.0.0.17", "remote_port": 2000, "runner": "4412d3ea-55f9-4395-8a91-f50a33832530"}	IPTABLES	successful	t
39	40	{"type": "ALL", "remote_ip": "5.0.0.19", "remote_address": "5.0.0.19", "remote_port": 2000, "runner": "dacbd309-d3a4-475c-b5b6-ca1e43ae7edf"}	IPTABLES	successful	t
61	64	{"type": "ALL", "remote_ip": "7.0.0.1", "remote_address": "7.0.0.1", "remote_port": 2000, "runner": "01298dfb-044a-4063-983a-a6cf0ce194f8"}	IPTABLES	successful	t
81	81	{"type": "ALL", "remote_ip": "8.0.0.1", "remote_address": "8.0.0.1", "remote_port": 2000, "runner": "4bca7c68-c2a6-4833-949d-eb48e6e7ab1e"}	IPTABLES	successful	t
62	61	{"type": "ALL", "remote_ip": "7.0.0.2", "remote_address": "7.0.0.2", "remote_port": 2000, "runner": "73a8292b-26ae-4e7f-82ff-89e87aef3739"}	IPTABLES	successful	t
84	85	{"type": "ALL", "remote_ip": "8.0.0.4", "remote_address": "8.0.0.4", "remote_port": 2000, "runner": "2f2c53bf-6cc3-42be-8248-7c6b8ac66b95"}	IPTABLES	successful	t
80	80	{"type": "ALL", "remote_ip": "7.0.0.20", "remote_address": "7.0.0.20", "remote_port": 2000, "runner": "040058f5-a8b4-4a33-8590-64d8abc03106"}	IPTABLES	successful	t
87	84	{"type": "ALL", "remote_ip": "8.0.0.7", "remote_address": "8.0.0.7", "remote_port": 2000, "runner": "c81dd5d9-06c8-4ffc-834c-2a902f93ffc9"}	IPTABLES	successful	t
98	97	{"type": "ALL", "remote_ip": "8.0.0.18", "remote_address": "8.0.0.18", "remote_port": 2000, "runner": "926b8dab-c410-4444-8090-cf8a3160569f"}	IPTABLES	successful	t
95	95	{"type": "ALL", "remote_ip": "8.0.0.15", "remote_address": "8.0.0.15", "remote_port": 2000, "runner": "33aa8ffd-a74d-4858-8894-9e8e0e37c7b2"}	IPTABLES	successful	t
30	31	{"type": "ALL", "remote_ip": "5.0.0.10", "remote_address": "5.0.0.10", "remote_port": 2000, "runner": "b931b59f-4f3e-4581-bf8f-8bedb2bedbcb"}	IPTABLES	successful	t
83	83	{"type": "ALL", "remote_ip": "8.0.0.3", "remote_address": "8.0.0.3", "remote_port": 2000, "runner": "83c23fcd-33b8-438b-a50e-926053f8f322"}	IPTABLES	successful	t
92	93	{"type": "ALL", "remote_ip": "8.0.0.12", "remote_address": "8.0.0.12", "remote_port": 2000, "runner": "c15a91de-2181-4990-9077-97d5a45290da"}	IPTABLES	successful	t
86	86	{"type": "ALL", "remote_ip": "8.0.0.6", "remote_address": "8.0.0.6", "remote_port": 2000, "runner": "347901e9-39ff-4774-8732-ed2fa207951f"}	IPTABLES	successful	t
78	78	{"type": "ALL", "remote_ip": "7.0.0.18", "remote_address": "7.0.0.18", "remote_port": 2000, "runner": "6faa1e30-8c85-4054-b373-df497e736c14"}	IPTABLES	successful	t
89	89	{"type": "ALL", "remote_ip": "8.0.0.9", "remote_address": "8.0.0.9", "remote_port": 2000, "runner": "32f8781e-15a8-4958-9c5b-6e78acf95da7"}	IPTABLES	successful	t
100	99	{"type": "ALL", "remote_ip": "8.0.0.20", "remote_address": "8.0.0.20", "remote_port": 2000, "runner": "271975f1-92aa-4456-9e79-239d4ec43f38"}	IPTABLES	successful	t
18	18	{"type": "ALL", "remote_ip": "4.0.0.18", "remote_address": "4.0.0.18", "remote_port": 2000, "runner": "b79aee5f-41ba-43ac-b842-74f311c3573a"}	IPTABLES	successful	t
91	91	{"type": "ALL", "remote_ip": "8.0.0.11", "remote_address": "8.0.0.11", "remote_port": 2000, "runner": "b63de5cd-f8c0-48f8-bb77-70b4f63d924e"}	IPTABLES	successful	t
94	94	{"type": "ALL", "remote_ip": "8.0.0.14", "remote_address": "8.0.0.14", "remote_port": 2000, "runner": "e8a427cb-06f6-4570-85ee-a6bbb7546ae5"}	IPTABLES	successful	t
85	87	{"type": "ALL", "remote_ip": "8.0.0.5", "remote_address": "8.0.0.5", "remote_port": 2000, "runner": "712ad158-90e1-47c9-a545-833c2489393f"}	IPTABLES	successful	t
88	88	{"type": "ALL", "remote_ip": "8.0.0.8", "remote_address": "8.0.0.8", "remote_port": 2000, "runner": "a3f4cc3d-c957-47e6-b358-0b350f927bf8"}	IPTABLES	successful	t
82	82	{"type": "ALL", "remote_ip": "8.0.0.2", "remote_address": "8.0.0.2", "remote_port": 2000, "runner": "c60a3b5b-ed7e-4403-b092-c7d9e1e6903d"}	IPTABLES	successful	t
97	98	{"type": "ALL", "remote_ip": "8.0.0.17", "remote_address": "8.0.0.17", "remote_port": 2000, "runner": "72a5622a-8b69-4dd8-af70-62e661c2114b"}	IPTABLES	successful	t
99	100	{"type": "ALL", "remote_ip": "8.0.0.19", "remote_address": "8.0.0.19", "remote_port": 2000, "runner": "6e45ec79-c8dd-40b9-a88e-9a32dea08a7a"}	IPTABLES	successful	t
96	96	{"type": "ALL", "remote_ip": "8.0.0.16", "remote_address": "8.0.0.16", "remote_port": 2000, "runner": "4b6675e3-6e0b-43ad-bb11-632095efa09c"}	IPTABLES	successful	t
93	92	{"type": "ALL", "remote_ip": "8.0.0.13", "remote_address": "8.0.0.13", "remote_port": 2000, "runner": "1a738c8d-53ee-4954-a997-140342e79baf"}	IPTABLES	successful	t
90	90	{"type": "ALL", "remote_ip": "8.0.0.10", "remote_address": "8.0.0.10", "remote_port": 2000, "runner": "c396bb39-644c-4878-9362-6cdfb4bdcfe5"}	IPTABLES	successful	t
79	79	{"type": "ALL", "remote_ip": "7.0.0.19", "remote_address": "7.0.0.19", "remote_port": 2000, "runner": "d3d5e145-b13c-48fa-9c8f-98c8e009a1b3"}	IPTABLES	successful	t
1	5	{"type": "ALL", "remote_ip": "4.0.0.1", "remote_address": "4.0.0.1", "remote_port": 2000, "runner": "ac256926-4c2e-4d75-b4bd-98f15faa37b5"}	IPTABLES	successful	t
\.


--
-- Data for Name: port_usage; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.port_usage (id, port_id, download, upload, download_accumulate, upload_accumulate, download_checkpoint, upload_checkpoint) FROM stdin;
84	80	0	0	0	0	0	0
85	79	0	0	0	0	0	0
86	78	0	0	0	0	0	0
3	59	0	0	0	0	0	0
4	65	0	0	0	0	0	0
5	61	0	0	0	0	0	0
6	64	0	0	0	0	0	0
7	60	0	0	0	0	0	0
8	58	0	0	0	0	0	0
9	57	0	0	0	0	0	0
10	56	0	0	0	0	0	0
11	51	0	0	0	0	0	0
12	55	0	0	0	0	0	0
13	52	0	0	0	0	0	0
14	54	0	0	0	0	0	0
15	53	0	0	0	0	0	0
16	50	0	0	0	0	0	0
17	49	0	0	0	0	0	0
18	48	0	0	0	0	0	0
19	47	0	0	0	0	0	0
20	45	0	0	0	0	0	0
21	44	0	0	0	0	0	0
22	46	0	0	0	0	0	0
23	43	0	0	0	0	0	0
25	42	0	0	0	0	0	0
26	39	0	0	0	0	0	0
27	40	0	0	0	0	0	0
28	38	0	0	0	0	0	0
29	37	0	0	0	0	0	0
30	35	0	0	0	0	0	0
31	36	0	0	0	0	0	0
32	34	0	0	0	0	0	0
33	33	0	0	0	0	0	0
34	32	0	0	0	0	0	0
35	30	0	0	0	0	0	0
36	31	0	0	0	0	0	0
37	29	0	0	0	0	0	0
38	28	0	0	0	0	0	0
39	23	0	0	0	0	0	0
40	26	0	0	0	0	0	0
41	27	0	0	0	0	0	0
42	24	0	0	0	0	0	0
43	25	0	0	0	0	0	0
44	22	0	0	0	0	0	0
45	21	0	0	0	0	0	0
46	19	0	0	0	0	0	0
47	20	0	0	0	0	0	0
48	18	0	0	0	0	0	0
49	15	0	0	0	0	0	0
50	16	0	0	0	0	0	0
51	17	0	0	0	0	0	0
52	14	0	0	0	0	0	0
53	13	0	0	0	0	0	0
54	12	0	0	0	0	0	0
55	11	0	0	0	0	0	0
56	10	0	0	0	0	0	0
57	9	0	0	0	0	0	0
58	7	0	0	0	0	0	0
59	8	0	0	0	0	0	0
60	6	0	0	0	0	0	0
61	4	0	0	0	0	0	0
62	1	0	0	0	0	0	0
63	2	0	0	0	0	0	0
24	41	0	44	0	0	0	0
64	99	0	0	0	0	0	0
65	100	0	0	0	0	0	0
66	97	0	0	0	0	0	0
67	98	0	0	0	0	0	0
68	96	0	0	0	0	0	0
69	95	0	0	0	0	0	0
70	94	0	0	0	0	0	0
72	93	0	0	0	0	0	0
73	91	0	0	0	0	0	0
74	90	0	0	0	0	0	0
75	89	0	0	0	0	0	0
77	84	0	0	0	0	0	0
78	86	0	0	0	0	0	0
79	87	0	0	0	0	0	0
80	85	0	0	0	0	0	0
81	83	0	0	0	0	0	0
82	82	0	0	0	0	0	0
87	75	0	0	0	0	0	0
88	76	0	0	0	0	0	0
89	77	0	0	0	0	0	0
90	74	0	0	0	0	0	0
91	73	0	0	0	0	0	0
92	72	0	0	0	0	0	0
93	71	0	0	0	0	0	0
94	70	0	0	0	0	0	0
95	69	0	0	0	0	0	0
96	67	0	0	0	0	0	0
97	68	0	0	0	0	0	0
71	92	0	40	0	0	0	0
76	88	0	40	0	0	0	0
83	81	0	44	0	0	0	0
98	66	0	0	0	0	0	0
99	62	0	0	0	0	0	0
100	63	0	0	0	0	0	0
1	5	0	0	0	0	0	0
2	3	0	0	0	0	0	0
\.


--
-- Data for Name: port_user; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.port_user (id, port_id, user_id, config) FROM stdin;
\.


--
-- Data for Name: server; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.server (id, name, address, ansible_name, ansible_host, ansible_port, ansible_user, config, ssh_password, sudo_password, is_active) FROM stdin;
1	中转	1.1.1.1	中转	1.1.1.1	22	root	{"system": {"msg": "Data could not be sent to remote host \\"1.1.1.1\\". Make sure this host can be reached over ssh: ssh: connect to host 1.1.1.1 port 22: Connection timed out\\r\\n"}, "services": {"NetworkManager-dispatcher.service": {"name": "NetworkManager-dispatcher.service", "source": "systemd", "state": "inactive", "status": "enabled"}, "NetworkManager-wait-online.service": {"name": "NetworkManager-wait-online.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "NetworkManager.service": {"name": "NetworkManager.service", "source": "systemd", "state": "running", "status": "enabled"}, "abrt-ccpp.service": {"name": "abrt-ccpp.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "abrt-oops.service": {"name": "abrt-oops.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "abrt-pstoreoops.service": {"name": "abrt-pstoreoops.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "abrt-vmcore.service": {"name": "abrt-vmcore.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "abrt-xorg.service": {"name": "abrt-xorg.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "abrtd.service": {"name": "abrtd.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "arp-ethers.service": {"name": "arp-ethers.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "atd.service": {"name": "atd.service", "source": "systemd", "state": "running", "status": "enabled"}, "auditd.service": {"name": "auditd.service", "source": "systemd", "state": "running", "status": "enabled"}, "autovt@.service": {"name": "autovt@.service", "source": "systemd", "state": "unknown", "status": "enabled"}, "azure-repo-svc.service": {"name": "azure-repo-svc.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "blk-availability.service": {"name": "blk-availability.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "brandbot.service": {"name": "brandbot.service", "source": "systemd", "state": "inactive", "status": "static"}, "chrony-dnssrv@.service": {"name": "chrony-dnssrv@.service", "source": "systemd", "state": "unknown", "status": "static"}, "chrony-wait.service": {"name": "chrony-wait.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "chronyd.service": {"name": "chronyd.service", "source": "systemd", "state": "running", "status": "enabled"}, "console-getty.service": {"name": "console-getty.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "console-shell.service": {"name": "console-shell.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "container-getty@.service": {"name": "container-getty@.service", "source": "systemd", "state": "unknown", "status": "static"}, "containerd.service": {"name": "containerd.service", "source": "systemd", "state": "running", "status": "disabled"}, "cpupower.service": {"name": "cpupower.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "crond.service": {"name": "crond.service", "source": "systemd", "state": "running", "status": "enabled"}, "dbus-org.freedesktop.NetworkManager.service": {"name": "dbus-org.freedesktop.NetworkManager.service", "source": "systemd", "state": "active", "status": "enabled"}, "dbus-org.freedesktop.hostname1.service": {"name": "dbus-org.freedesktop.hostname1.service", "source": "systemd", "state": "inactive", "status": "static"}, "dbus-org.freedesktop.import1.service": {"name": "dbus-org.freedesktop.import1.service", "source": "systemd", "state": "inactive", "status": "static"}, "dbus-org.freedesktop.locale1.service": {"name": "dbus-org.freedesktop.locale1.service", "source": "systemd", "state": "inactive", "status": "static"}, "dbus-org.freedesktop.login1.service": {"name": "dbus-org.freedesktop.login1.service", "source": "systemd", "state": "active", "status": "static"}, "dbus-org.freedesktop.machine1.service": {"name": "dbus-org.freedesktop.machine1.service", "source": "systemd", "state": "inactive", "status": "static"}, "dbus-org.freedesktop.nm-dispatcher.service": {"name": "dbus-org.freedesktop.nm-dispatcher.service", "source": "systemd", "state": "inactive", "status": "enabled"}, "dbus-org.freedesktop.timedate1.service": {"name": "dbus-org.freedesktop.timedate1.service", "source": "systemd", "state": "inactive", "status": "static"}, "dbus.service": {"name": "dbus.service", "source": "systemd", "state": "running", "status": "static"}, "debug-shell.service": {"name": "debug-shell.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "dm-event.service": {"name": "dm-event.service", "source": "systemd", "state": "stopped", "status": "static"}, "dmraid-activation.service": {"name": "dmraid-activation.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "docker.service": {"name": "docker.service", "source": "systemd", "state": "running", "status": "enabled"}, "dracut-cmdline.service": {"name": "dracut-cmdline.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-initqueue.service": {"name": "dracut-initqueue.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-mount.service": {"name": "dracut-mount.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-pre-mount.service": {"name": "dracut-pre-mount.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-pre-pivot.service": {"name": "dracut-pre-pivot.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-pre-trigger.service": {"name": "dracut-pre-trigger.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-pre-udev.service": {"name": "dracut-pre-udev.service", "source": "systemd", "state": "inactive", "status": "static"}, "dracut-shutdown.service": {"name": "dracut-shutdown.service", "source": "systemd", "state": "stopped", "status": "static"}, "ebtables.service": {"name": "ebtables.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "emergency.service": {"name": "emergency.service", "source": "systemd", "state": "stopped", "status": "static"}, "firewalld.service": {"name": "firewalld.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "fprintd.service": {"name": "fprintd.service", "source": "systemd", "state": "inactive", "status": "static"}, "fstrim.service": {"name": "fstrim.service", "source": "systemd", "state": "inactive", "status": "static"}, "getty@.service": {"name": "getty@.service", "source": "systemd", "state": "unknown", "status": "enabled"}, "getty@tty1.service": {"name": "getty@tty1.service", "source": "systemd", "state": "running", "status": "unknown"}, "halt-local.service": {"name": "halt-local.service", "source": "systemd", "state": "inactive", "status": "static"}, "hypervfcopyd.service": {"name": "hypervfcopyd.service", "source": "systemd", "state": "inactive", "status": "static"}, "hypervkvpd.service": {"name": "hypervkvpd.service", "source": "systemd", "state": "running", "status": "static"}, "hypervvssd.service": {"name": "hypervvssd.service", "source": "systemd", "state": "inactive", "status": "static"}, "initrd-cleanup.service": {"name": "initrd-cleanup.service", "source": "systemd", "state": "inactive", "status": "static"}, "initrd-parse-etc.service": {"name": "initrd-parse-etc.service", "source": "systemd", "state": "inactive", "status": "static"}, "initrd-switch-root.service": {"name": "initrd-switch-root.service", "source": "systemd", "state": "inactive", "status": "static"}, "initrd-udevadm-cleanup-db.service": {"name": "initrd-udevadm-cleanup-db.service", "source": "systemd", "state": "inactive", "status": "static"}, "ip6tables-restore.service": {"name": "ip6tables-restore.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "iprdump.service": {"name": "iprdump.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "iprinit.service": {"name": "iprinit.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "iprupdate.service": {"name": "iprupdate.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "iptables-check.service": {"name": "iptables-check.service", "source": "systemd", "state": "stopped", "status": "static"}, "iptables-restore.service": {"name": "iptables-restore.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "irqbalance.service": {"name": "irqbalance.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "kdump.service": {"name": "kdump.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "kmod-static-nodes.service": {"name": "kmod-static-nodes.service", "source": "systemd", "state": "stopped", "status": "static"}, "kpatch.service": {"name": "kpatch.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "libstoragemgmt.service": {"name": "libstoragemgmt.service", "source": "systemd", "state": "running", "status": "enabled"}, "lvm2-lvmetad.service": {"name": "lvm2-lvmetad.service", "source": "systemd", "state": "running", "status": "static"}, "lvm2-lvmpolld.service": {"name": "lvm2-lvmpolld.service", "source": "systemd", "state": "stopped", "status": "static"}, "lvm2-monitor.service": {"name": "lvm2-monitor.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "lvm2-pvscan@.service": {"name": "lvm2-pvscan@.service", "source": "systemd", "state": "unknown", "status": "static"}, "mdadm-grow-continue@.service": {"name": "mdadm-grow-continue@.service", "source": "systemd", "state": "unknown", "status": "static"}, "mdadm-last-resort@.service": {"name": "mdadm-last-resort@.service", "source": "systemd", "state": "unknown", "status": "static"}, "mdmon@.service": {"name": "mdmon@.service", "source": "systemd", "state": "unknown", "status": "static"}, "mdmonitor.service": {"name": "mdmonitor.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "messagebus.service": {"name": "messagebus.service", "source": "systemd", "state": "active", "status": "static"}, "microcode.service": {"name": "microcode.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "netconsole": {"name": "netconsole", "source": "sysv", "state": "stopped", "status": "disabled"}, "network": {"name": "network", "source": "sysv", "state": "running", "status": "enabled"}, "network.service": {"name": "network.service", "source": "systemd", "state": "stopped", "status": "unknown"}, "nfs-rquotad.service": {"name": "nfs-rquotad.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "ntpdate.service": {"name": "ntpdate.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "plymouth-halt.service": {"name": "plymouth-halt.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "plymouth-kexec.service": {"name": "plymouth-kexec.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "plymouth-poweroff.service": {"name": "plymouth-poweroff.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "plymouth-quit-wait.service": {"name": "plymouth-quit-wait.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "plymouth-quit.service": {"name": "plymouth-quit.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "plymouth-read-write.service": {"name": "plymouth-read-write.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "plymouth-reboot.service": {"name": "plymouth-reboot.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "plymouth-start.service": {"name": "plymouth-start.service", "source": "systemd", "state": "stopped", "status": "disabled"}, "plymouth-switch-root.service": {"name": "plymouth-switch-root.service", "source": "systemd", "state": "inactive", "status": "static"}, "polkit.service": {"name": "polkit.service", "source": "systemd", "state": "running", "status": "static"}, "postfix.service": {"name": "postfix.service", "source": "systemd", "state": "running", "status": "enabled"}, "psacct.service": {"name": "psacct.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "quotaon.service": {"name": "quotaon.service", "source": "systemd", "state": "inactive", "status": "static"}, "rc-local.service": {"name": "rc-local.service", "source": "systemd", "state": "stopped", "status": "static"}, "rdisc.service": {"name": "rdisc.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "rescue.service": {"name": "rescue.service", "source": "systemd", "state": "stopped", "status": "static"}, "rhel-autorelabel-mark.service": {"name": "rhel-autorelabel-mark.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "rhel-autorelabel.service": {"name": "rhel-autorelabel.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-configure.service": {"name": "rhel-configure.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-dmesg.service": {"name": "rhel-dmesg.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-domainname.service": {"name": "rhel-domainname.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-import-state.service": {"name": "rhel-import-state.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-loadmodules.service": {"name": "rhel-loadmodules.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rhel-readonly.service": {"name": "rhel-readonly.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "rngd.service": {"name": "rngd.service", "source": "systemd", "state": "running", "status": "enabled"}, "rpc-rquotad.service": {"name": "rpc-rquotad.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "rpcbind.service": {"name": "rpcbind.service", "source": "systemd", "state": "running", "status": "enabled"}, "rsyncd.service": {"name": "rsyncd.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "rsyncd@.service": {"name": "rsyncd@.service", "source": "systemd", "state": "unknown", "status": "static"}, "rsyslog.service": {"name": "rsyslog.service", "source": "systemd", "state": "running", "status": "enabled"}, "selinux-policy-migrate-local-changes@.service": {"name": "selinux-policy-migrate-local-changes@.service", "source": "systemd", "state": "unknown", "status": "static"}, "selinux-policy-migrate-local-changes@targeted.service": {"name": "selinux-policy-migrate-local-changes@targeted.service", "source": "systemd", "state": "stopped", "status": "unknown"}, "serial-getty@.service": {"name": "serial-getty@.service", "source": "systemd", "state": "unknown", "status": "disabled"}, "serial-getty@ttyS0.service": {"name": "serial-getty@ttyS0.service", "source": "systemd", "state": "running", "status": "unknown"}, "smartd.service": {"name": "smartd.service", "source": "systemd", "state": "running", "status": "enabled"}, "sshd-keygen.service": {"name": "sshd-keygen.service", "source": "systemd", "state": "stopped", "status": "static"}, "sshd.service": {"name": "sshd.service", "source": "systemd", "state": "running", "status": "enabled"}, "sshd@.service": {"name": "sshd@.service", "source": "systemd", "state": "unknown", "status": "static"}, "sysstat.service": {"name": "sysstat.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "systemd-ask-password-console.service": {"name": "systemd-ask-password-console.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-ask-password-plymouth.service": {"name": "systemd-ask-password-plymouth.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-ask-password-wall.service": {"name": "systemd-ask-password-wall.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-backlight@.service": {"name": "systemd-backlight@.service", "source": "systemd", "state": "unknown", "status": "static"}, "systemd-binfmt.service": {"name": "systemd-binfmt.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-bootchart.service": {"name": "systemd-bootchart.service", "source": "systemd", "state": "inactive", "status": "disabled"}, "systemd-firstboot.service": {"name": "systemd-firstboot.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-fsck-root.service": {"name": "systemd-fsck-root.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-fsck@.service": {"name": "systemd-fsck@.service", "source": "systemd", "state": "unknown", "status": "static"}, "systemd-halt.service": {"name": "systemd-halt.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-hibernate-resume@.service": {"name": "systemd-hibernate-resume@.service", "source": "systemd", "state": "unknown", "status": "static"}, "systemd-hibernate.service": {"name": "systemd-hibernate.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-hostnamed.service": {"name": "systemd-hostnamed.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-hwdb-update.service": {"name": "systemd-hwdb-update.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-hybrid-sleep.service": {"name": "systemd-hybrid-sleep.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-importd.service": {"name": "systemd-importd.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-initctl.service": {"name": "systemd-initctl.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-journal-catalog-update.service": {"name": "systemd-journal-catalog-update.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-journal-flush.service": {"name": "systemd-journal-flush.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-journald.service": {"name": "systemd-journald.service", "source": "systemd", "state": "running", "status": "static"}, "systemd-kexec.service": {"name": "systemd-kexec.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-localed.service": {"name": "systemd-localed.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-logind.service": {"name": "systemd-logind.service", "source": "systemd", "state": "running", "status": "static"}, "systemd-machine-id-commit.service": {"name": "systemd-machine-id-commit.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-machined.service": {"name": "systemd-machined.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-modules-load.service": {"name": "systemd-modules-load.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-nspawn@.service": {"name": "systemd-nspawn@.service", "source": "systemd", "state": "unknown", "status": "disabled"}, "systemd-poweroff.service": {"name": "systemd-poweroff.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-quotacheck.service": {"name": "systemd-quotacheck.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-random-seed.service": {"name": "systemd-random-seed.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-readahead-collect.service": {"name": "systemd-readahead-collect.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "systemd-readahead-done.service": {"name": "systemd-readahead-done.service", "source": "systemd", "state": "stopped", "status": "indirect"}, "systemd-readahead-drop.service": {"name": "systemd-readahead-drop.service", "source": "systemd", "state": "inactive", "status": "enabled"}, "systemd-readahead-replay.service": {"name": "systemd-readahead-replay.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "systemd-reboot.service": {"name": "systemd-reboot.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-remount-fs.service": {"name": "systemd-remount-fs.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-rfkill@.service": {"name": "systemd-rfkill@.service", "source": "systemd", "state": "unknown", "status": "static"}, "systemd-shutdownd.service": {"name": "systemd-shutdownd.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-suspend.service": {"name": "systemd-suspend.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-sysctl.service": {"name": "systemd-sysctl.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-timedated.service": {"name": "systemd-timedated.service", "source": "systemd", "state": "inactive", "status": "static"}, "systemd-tmpfiles-clean.service": {"name": "systemd-tmpfiles-clean.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-tmpfiles-setup-dev.service": {"name": "systemd-tmpfiles-setup-dev.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-tmpfiles-setup.service": {"name": "systemd-tmpfiles-setup.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-udev-settle.service": {"name": "systemd-udev-settle.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-udev-trigger.service": {"name": "systemd-udev-trigger.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-udevd.service": {"name": "systemd-udevd.service", "source": "systemd", "state": "running", "status": "static"}, "systemd-update-done.service": {"name": "systemd-update-done.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-update-utmp-runlevel.service": {"name": "systemd-update-utmp-runlevel.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-update-utmp.service": {"name": "systemd-update-utmp.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-user-sessions.service": {"name": "systemd-user-sessions.service", "source": "systemd", "state": "stopped", "status": "static"}, "systemd-vconsole-setup.service": {"name": "systemd-vconsole-setup.service", "source": "systemd", "state": "stopped", "status": "static"}, "teamd@.service": {"name": "teamd@.service", "source": "systemd", "state": "unknown", "status": "static"}, "tuned.service": {"name": "tuned.service", "source": "systemd", "state": "running", "status": "enabled"}, "usb_modeswitch@.service": {"name": "usb_modeswitch@.service", "source": "systemd", "state": "unknown", "status": "static"}, "vdo.service": {"name": "vdo.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "waagent-network-setup.service": {"name": "waagent-network-setup.service", "source": "systemd", "state": "stopped", "status": "enabled"}, "waagent.service": {"name": "waagent.service", "source": "systemd", "state": "running", "status": "enabled"}, "wpa_supplicant.service": {"name": "wpa_supplicant.service", "source": "systemd", "state": "inactive", "status": "disabled"}}, "init": "2b40391be44a4566e97f2727a4252165"}	taohaiying520.	\N	t
\.


--
-- Data for Name: server_user; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public.server_user (id, server_id, user_id, config, download, upload, notes) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: aurora
--

COPY public."user" (id, email, first_name, last_name, hashed_password, is_active, is_ops, is_superuser, notes) FROM stdin;
1	qq@qq.com	\N	\N	$2b$12$y2aiWY.YISWGExHGb7zmw.t.8JDTU.Q9LOwJRHYVtSyptileh05iS	t	f	t	\N
\.


--
-- Name: port_forward_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.port_forward_rule_id_seq', 101, true);


--
-- Name: port_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.port_id_seq', 101, true);


--
-- Name: port_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.port_usage_id_seq', 101, true);


--
-- Name: port_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.port_user_id_seq', 1, false);


--
-- Name: server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.server_id_seq', 1, true);


--
-- Name: server_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.server_user_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurora
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: port _port_external_num_server_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port
    ADD CONSTRAINT _port_external_num_server_uc UNIQUE (external_num, server_id);


--
-- Name: port _port_num_server_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port
    ADD CONSTRAINT _port_num_server_uc UNIQUE (num, server_id);


--
-- Name: port_usage _port_usage_port_id_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_usage
    ADD CONSTRAINT _port_usage_port_id_uc UNIQUE (port_id);


--
-- Name: port_user _port_user_server_id_user_id_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_user
    ADD CONSTRAINT _port_user_server_id_user_id_uc UNIQUE (port_id, user_id);


--
-- Name: server _server_ansible_host_ansible_port_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT _server_ansible_host_ansible_port_uc UNIQUE (ansible_host, ansible_port);


--
-- Name: server _server_ansible_name_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT _server_ansible_name_uc UNIQUE (ansible_name);


--
-- Name: server_user _server_user_server_id_user_id_uc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server_user
    ADD CONSTRAINT _server_user_server_id_user_id_uc UNIQUE (server_id, user_id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: port_forward_rule port_forward_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_forward_rule
    ADD CONSTRAINT port_forward_rule_pkey PRIMARY KEY (id);


--
-- Name: port port_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port
    ADD CONSTRAINT port_pkey PRIMARY KEY (id);


--
-- Name: port_usage port_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_usage
    ADD CONSTRAINT port_usage_pkey PRIMARY KEY (id);


--
-- Name: port_user port_user_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_user
    ADD CONSTRAINT port_user_pkey PRIMARY KEY (id);


--
-- Name: server server_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_pkey PRIMARY KEY (id);


--
-- Name: server_user server_user_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server_user
    ADD CONSTRAINT server_user_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_port_forward_rule_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_port_forward_rule_id ON public.port_forward_rule USING btree (id);


--
-- Name: ix_port_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_port_id ON public.port USING btree (id);


--
-- Name: ix_port_usage_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_port_usage_id ON public.port_usage USING btree (id);


--
-- Name: ix_port_user_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_port_user_id ON public.port_user USING btree (id);


--
-- Name: ix_server_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_server_id ON public.server USING btree (id);


--
-- Name: ix_server_name; Type: INDEX; Schema: public; Owner: aurora
--

CREATE UNIQUE INDEX ix_server_name ON public.server USING btree (name);


--
-- Name: ix_server_user_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_server_user_id ON public.server_user USING btree (id);


--
-- Name: ix_user_email; Type: INDEX; Schema: public; Owner: aurora
--

CREATE UNIQUE INDEX ix_user_email ON public."user" USING btree (email);


--
-- Name: ix_user_id; Type: INDEX; Schema: public; Owner: aurora
--

CREATE INDEX ix_user_id ON public."user" USING btree (id);


--
-- Name: port_forward_rule port_forward_rule_port_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_forward_rule
    ADD CONSTRAINT port_forward_rule_port_id_fkey FOREIGN KEY (port_id) REFERENCES public.port(id);


--
-- Name: port port_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port
    ADD CONSTRAINT port_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.server(id);


--
-- Name: port_usage port_usage_port_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_usage
    ADD CONSTRAINT port_usage_port_id_fkey FOREIGN KEY (port_id) REFERENCES public.port(id);


--
-- Name: port_user port_user_port_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_user
    ADD CONSTRAINT port_user_port_id_fkey FOREIGN KEY (port_id) REFERENCES public.port(id);


--
-- Name: port_user port_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.port_user
    ADD CONSTRAINT port_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: server_user server_user_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server_user
    ADD CONSTRAINT server_user_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.server(id);


--
-- Name: server_user server_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurora
--

ALTER TABLE ONLY public.server_user
    ADD CONSTRAINT server_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--


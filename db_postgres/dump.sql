
SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

-- CREATE ROLE developer;
ALTER ROLE developer WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE DATABASE logs_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE logs_db OWNER TO developer;

\connect logs_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA system;

ALTER SCHEMA system OWNER TO developer;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE system.events (
    id integer NOT NULL,
    event_type character varying(50),
    description text,
    occurred_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE system.events OWNER TO developer;

CREATE SEQUENCE system.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE system.events_id_seq OWNER TO developer;

ALTER SEQUENCE system.events_id_seq OWNED BY system.events.id;

ALTER TABLE ONLY system.events ALTER COLUMN id SET DEFAULT nextval('system.events_id_seq'::regclass);

COPY system.events (id, event_type, description, occurred_at) FROM stdin;
1	INFO	System started	2026-01-30 18:16:05.600129
2	WARNING	Low disk space	2026-01-30 18:16:05.600129
\.


SELECT pg_catalog.setval('system.events_id_seq', 33, true);

ALTER TABLE ONLY system.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);

\connect postgres


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE DATABASE sales_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE sales_db OWNER TO developer;

\connect sales_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA analytics;


ALTER SCHEMA analytics OWNER TO developer;

CREATE SCHEMA core;


ALTER SCHEMA core OWNER TO developer;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE analytics.sales_stats (
    id integer NOT NULL,
    product_id integer,
    sale_date date,
    quantity integer
);


ALTER TABLE analytics.sales_stats OWNER TO developer;

CREATE SEQUENCE analytics.sales_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE analytics.sales_stats_id_seq OWNER TO developer;

ALTER SEQUENCE analytics.sales_stats_id_seq OWNED BY analytics.sales_stats.id;

CREATE TABLE core.products (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE core.products OWNER TO developer;

CREATE SEQUENCE core.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE core.products_id_seq OWNER TO developer;

ALTER SEQUENCE core.products_id_seq OWNED BY core.products.id;

ALTER TABLE ONLY analytics.sales_stats ALTER COLUMN id SET DEFAULT nextval('analytics.sales_stats_id_seq'::regclass);

ALTER TABLE ONLY core.products ALTER COLUMN id SET DEFAULT nextval('core.products_id_seq'::regclass);

COPY analytics.sales_stats (id, product_id, sale_date, quantity) FROM stdin;
1	1	2026-01-30	5
2	2	2026-01-30	20
\.


COPY core.products (id, name, price, created_at) FROM stdin;
1	Laptop	1200.00	2026-01-30 18:16:05.569296
2	Mouse	25.50	2026-01-30 18:16:05.569296
3	Keyboard	75.00	2026-01-30 18:16:05.569296
\.

SELECT pg_catalog.setval('analytics.sales_stats_id_seq', 33, true);

SELECT pg_catalog.setval('core.products_id_seq', 33, true);

ALTER TABLE ONLY analytics.sales_stats
    ADD CONSTRAINT sales_stats_pkey PRIMARY KEY (id);

ALTER TABLE ONLY core.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);

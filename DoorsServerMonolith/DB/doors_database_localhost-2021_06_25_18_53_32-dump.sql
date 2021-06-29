--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Debian 13.3-1.pgdg100+1)
-- Dumped by pg_dump version 13.3

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
-- Name: doors_service; Type: TYPE; Schema: public; Owner: vapor_username
--

CREATE TYPE public.doors_service AS ENUM (
    'id',
    'scene',
    'engine',
    'bank',
    'arteka'
);


ALTER TYPE public.doors_service OWNER TO vapor_username;

--
-- Name: role; Type: TYPE; Schema: public; Owner: vapor_username
--

CREATE TYPE public.role AS ENUM (
    'empty',
    'guest',
    'use',
    'test',
    'dev',
    'publish',
    'admin'
);


ALTER TYPE public.role OWNER TO vapor_username;

--
-- Name: shift_blocks(); Type: FUNCTION; Schema: public; Owner: vapor_username
--

CREATE FUNCTION public.shift_blocks() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

        BEGIN
                UPDATE blocks block
                SET index = index +1
                , flip_flag = NOT flip_flag       -- alternating bit protocol ;-)
                WHERE NEW.index < OLD.index
                AND OLD.flip_flag = NEW.flip_flag -- redundant condition
                AND block.index >= NEW.index
                AND block.index < OLD.index
                AND block.id <> NEW.id             -- exclude the initiating row
                ;
                UPDATE blocks block
                SET index = index -1
                , flip_flag = NOT flip_flag
                WHERE NEW.index > OLD.index
                AND OLD.flip_flag = NEW.flip_flag
                AND block.index <= NEW.index
                AND block.index > OLD.index
                AND block.id <> NEW.id
                ;
                RETURN NEW;
        END;

        $$;


ALTER FUNCTION public.shift_blocks() OWNER TO vapor_username;

--
-- Name: shift_levels(); Type: FUNCTION; Schema: public; Owner: vapor_username
--

CREATE FUNCTION public.shift_levels() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

        BEGIN
                UPDATE levels level
                SET index = index +1
                , flip_flag = NOT flip_flag       -- alternating bit protocol ;-)
                WHERE NEW.index < OLD.index
                AND OLD.flip_flag = NEW.flip_flag -- redundant condition
                AND level.index >= NEW.index
                AND level.index < OLD.index
                AND level.id <> NEW.id             -- exclude the initiating row
                ;
                UPDATE levels level
                SET index = index -1
                , flip_flag = NOT flip_flag
                WHERE NEW.index > OLD.index
                AND OLD.flip_flag = NEW.flip_flag
                AND level.index <= NEW.index
                AND level.index > OLD.index
                AND level.id <> NEW.id
                ;
                RETURN NEW;
        END;

        $$;


ALTER FUNCTION public.shift_levels() OWNER TO vapor_username;

--
-- Name: shift_points(); Type: FUNCTION; Schema: public; Owner: vapor_username
--

CREATE FUNCTION public.shift_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

        BEGIN
                UPDATE points point
                SET index = index +1
                , flip_flag = NOT flip_flag       -- alternating bit protocol ;-)
                WHERE NEW.index < OLD.index
                AND OLD.flip_flag = NEW.flip_flag -- redundant condition
                AND point.index >= NEW.index
                AND point.index < OLD.index
                AND point.id <> NEW.id             -- exclude the initiating row
                ;
                UPDATE points point
                SET index = index -1
                , flip_flag = NOT flip_flag
                WHERE NEW.index > OLD.index
                AND OLD.flip_flag = NEW.flip_flag
                AND point.index <= NEW.index
                AND point.index > OLD.index
                AND point.id <> NEW.id
                ;
                RETURN NEW;
        END;

        $$;


ALTER FUNCTION public.shift_points() OWNER TO vapor_username;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _fluent_enums; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public._fluent_enums (
    id uuid NOT NULL,
    name text NOT NULL,
    "case" text NOT NULL
);


ALTER TABLE public._fluent_enums OWNER TO vapor_username;

--
-- Name: _fluent_migrations; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public._fluent_migrations (
    id uuid NOT NULL,
    name text NOT NULL,
    batch bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public._fluent_migrations OWNER TO vapor_username;

--
-- Name: block-types; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public."block-types" (
    id uuid NOT NULL,
    "userID" uuid NOT NULL,
    "superBlockTypeID" uuid,
    name text NOT NULL,
    "pluralName" text NOT NULL
);


ALTER TABLE public."block-types" OWNER TO vapor_username;

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.blocks (
    id uuid NOT NULL,
    "userID" uuid NOT NULL,
    "levelID" uuid,
    "blockTypeID" uuid,
    index bigint NOT NULL,
    flip_flag boolean DEFAULT false NOT NULL
);


ALTER TABLE public.blocks OWNER TO vapor_username;

--
-- Name: levels; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.levels (
    id uuid NOT NULL,
    "userID" uuid NOT NULL,
    index bigint NOT NULL,
    flip_flag boolean DEFAULT false NOT NULL
);


ALTER TABLE public.levels OWNER TO vapor_username;

--
-- Name: points; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.points (
    id uuid NOT NULL,
    "userID" uuid NOT NULL,
    "superPointID" uuid,
    "blockID" uuid,
    index bigint NOT NULL,
    flip_flag boolean DEFAULT false NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.points OWNER TO vapor_username;

--
-- Name: user_email_tokens; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.user_email_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


ALTER TABLE public.user_email_tokens OWNER TO vapor_username;

--
-- Name: user_password_tokens; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.user_password_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL
);


ALTER TABLE public.user_password_tokens OWNER TO vapor_username;

--
-- Name: user_refresh_tokens; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.user_refresh_tokens (
    id uuid NOT NULL,
    token text,
    user_id uuid,
    expires_at timestamp with time zone,
    issued_at timestamp with time zone
);


ALTER TABLE public.user_refresh_tokens OWNER TO vapor_username;

--
-- Name: users; Type: TABLE; Schema: public; Owner: vapor_username
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    is_email_verified boolean DEFAULT false NOT NULL,
    phone text,
    is_phone_verified boolean DEFAULT false NOT NULL,
    password_hash text NOT NULL,
    role public.role DEFAULT 'empty'::public.role NOT NULL,
    name text,
    doors_services_active text[] DEFAULT ARRAY['id'::text] NOT NULL,
    doors_services_inactive text[] DEFAULT ARRAY['scene'::text, 'engine'::text, 'bank'::text, 'arteka'::text] NOT NULL
);


ALTER TABLE public.users OWNER TO vapor_username;

--
-- Data for Name: _fluent_enums; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public._fluent_enums (id, name, "case") FROM stdin;
22e76200-c1ae-41fd-9ffa-8149254c5533	role	empty
3d05861e-9d98-4d38-bd1d-7b907426a382	role	guest
cf38ebf6-5417-4682-9d6f-487a5ec88379	role	use
c86ffbea-4262-48b2-b358-d5e19e403285	role	test
f2cb352c-be2d-4ce4-a256-d5a50bc22477	role	dev
86ac7078-e0da-4b7f-9705-ad87c1dd5bb3	role	publish
b0418c2a-10e2-4f36-8ccc-838caa9527db	role	admin
a25c0a46-a4f0-4336-94bf-ca8683d9cba9	doors_service	id
12a03467-03ea-481b-91fb-3ceda89e4e41	doors_service	scene
a2341f29-b931-45d3-b73c-01884d7c9578	doors_service	engine
8dad4235-e790-4567-b45f-8cb237980a8c	doors_service	bank
88022545-fc65-411b-a9d2-c58bc7fbbcc8	doors_service	arteka
\.


--
-- Data for Name: _fluent_migrations; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public._fluent_migrations (id, name, batch, created_at, updated_at) FROM stdin;
e7692084-56f6-4087-954d-c0298389dfd5	App.CreateUser	1	2021-06-25 12:51:26.485069+00	2021-06-25 12:51:26.485069+00
a03e190d-7754-4731-b070-11c25c68b096	App.UserAddDoorsServices	1	2021-06-25 12:51:26.513964+00	2021-06-25 12:51:26.513964+00
e2a06e2c-762f-4408-b7ce-3514ed489283	App.CreateRefreshToken	1	2021-06-25 12:51:26.529795+00	2021-06-25 12:51:26.529795+00
56b9e674-bc2b-4daf-a9a2-21483a29c2e6	App.CreateEmailToken	1	2021-06-25 12:51:26.54547+00	2021-06-25 12:51:26.54547+00
a2448a72-1751-4d73-b7a7-e3d7654302f9	App.CreatePasswordToken	1	2021-06-25 12:51:26.558161+00	2021-06-25 12:51:26.558161+00
ed1ce1b2-b367-4684-9266-31d49e97fe12	App.CreateLevel	1	2021-06-25 12:51:26.567875+00	2021-06-25 12:51:26.567875+00
d5d76851-e6e3-42c4-889d-073598ce802e	App.CreateBlockType	1	2021-06-25 12:51:26.580228+00	2021-06-25 12:51:26.580228+00
8a03acca-bfbf-439c-b7b1-2854e4aa90a7	App.CreateBlock	1	2021-06-25 12:51:26.590422+00	2021-06-25 12:51:26.590422+00
78c7e0bb-66bb-4b04-9214-00dc4096c118	App.CreatePoint	1	2021-06-25 12:51:26.603074+00	2021-06-25 12:51:26.603074+00
\.


--
-- Data for Name: block-types; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public."block-types" (id, "userID", "superBlockTypeID", name, "pluralName") FROM stdin;
bef26cf6-d81f-4b66-97b7-a854a24f5524	4d84f719-a536-4af7-96dd-4d29e3aaaa18	\N	scene	scenes
\.


--
-- Data for Name: blocks; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.blocks (id, "userID", "levelID", "blockTypeID", index, flip_flag) FROM stdin;
0b96c0c6-d14a-4df8-add8-82cea7b4d612	4d84f719-a536-4af7-96dd-4d29e3aaaa18	1abb8021-c825-4940-8b8b-419c95bce90a	bef26cf6-d81f-4b66-97b7-a854a24f5524	0	f
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.levels (id, "userID", index, flip_flag) FROM stdin;
1abb8021-c825-4940-8b8b-419c95bce90a	4d84f719-a536-4af7-96dd-4d29e3aaaa18	0	f
\.


--
-- Data for Name: points; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.points (id, "userID", "superPointID", "blockID", index, flip_flag, text) FROM stdin;
7c9bfe8d-7a24-4bb7-a0bf-7339a7f08e89	4d84f719-a536-4af7-96dd-4d29e3aaaa18	\N	\N	0	f	Pineapple
9a0e9b83-b650-43dd-a1a4-3be8c1f9868b	4d84f719-a536-4af7-96dd-4d29e3aaaa18	\N	\N	2	t	Apple
9624d86f-8744-4cfb-94f8-071bf3cc2237	4d84f719-a536-4af7-96dd-4d29e3aaaa18	\N	\N	3	t	Orange
5ce6ae64-efab-4bf9-8a1f-fc11614429c9	4d84f719-a536-4af7-96dd-4d29e3aaaa18	\N	\N	1	t	Banana
\.


--
-- Data for Name: user_email_tokens; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.user_email_tokens (id, user_id, token, expires_at) FROM stdin;
e75bc8e8-0797-4bdf-bebc-93ca125f31e5	4d84f719-a536-4af7-96dd-4d29e3aaaa18	0d3d09e3e4d28fc13744a35fd6dd966d4c996842dd2ac0268b4c0068adf4257b	2021-06-26 12:51:59.331465+00
\.


--
-- Data for Name: user_password_tokens; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.user_password_tokens (id, user_id, token, expires_at) FROM stdin;
\.


--
-- Data for Name: user_refresh_tokens; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.user_refresh_tokens (id, token, user_id, expires_at, issued_at) FROM stdin;
b1e3b5a4-8a95-46f1-a8f4-37797780ce51	c5616b8859dee9b3516b52c89f7235c75f129048b20cc0fc14126f55909b6fe8	4d84f719-a536-4af7-96dd-4d29e3aaaa18	2021-07-09 12:52:20.653155+00	2021-06-25 12:52:20.653155+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vapor_username
--

COPY public.users (id, username, email, is_email_verified, phone, is_phone_verified, password_hash, role, name, doors_services_active, doors_services_inactive) FROM stdin;
4d84f719-a536-4af7-96dd-4d29e3aaaa18	il	il@ft.com	f	\N	f	$2b$12$mElFYSDdkZZGOXFBcsSG1.Q3OoG2gFiYH20mSTdHlpKEZ/BKhxjIS	empty	\N	{id}	{scene}
\.


--
-- Name: _fluent_enums _fluent_enums_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public._fluent_enums
    ADD CONSTRAINT _fluent_enums_pkey PRIMARY KEY (id);


--
-- Name: _fluent_migrations _fluent_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT _fluent_migrations_pkey PRIMARY KEY (id);


--
-- Name: block-types block-types_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public."block-types"
    ADD CONSTRAINT "block-types_pkey" PRIMARY KEY (id);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: points points_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- Name: _fluent_enums uq:_fluent_enums.name+_fluent_enums.case; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public._fluent_enums
    ADD CONSTRAINT "uq:_fluent_enums.name+_fluent_enums.case" UNIQUE (name, "case");


--
-- Name: _fluent_migrations uq:_fluent_migrations.name; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT "uq:_fluent_migrations.name" UNIQUE (name);


--
-- Name: user_email_tokens uq:user_email_tokens.token; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_email_tokens
    ADD CONSTRAINT "uq:user_email_tokens.token" UNIQUE (token);


--
-- Name: user_email_tokens uq:user_email_tokens.user_id; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_email_tokens
    ADD CONSTRAINT "uq:user_email_tokens.user_id" UNIQUE (user_id);


--
-- Name: user_refresh_tokens uq:user_refresh_tokens.token; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT "uq:user_refresh_tokens.token" UNIQUE (token);


--
-- Name: user_refresh_tokens uq:user_refresh_tokens.user_id; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT "uq:user_refresh_tokens.user_id" UNIQUE (user_id);


--
-- Name: users uq:users.email; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "uq:users.email" UNIQUE (email);


--
-- Name: users uq:users.phone; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "uq:users.phone" UNIQUE (phone);


--
-- Name: users uq:users.username; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "uq:users.username" UNIQUE (username);


--
-- Name: user_email_tokens user_email_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_email_tokens
    ADD CONSTRAINT user_email_tokens_pkey PRIMARY KEY (id);


--
-- Name: user_password_tokens user_password_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_password_tokens
    ADD CONSTRAINT user_password_tokens_pkey PRIMARY KEY (id);


--
-- Name: user_refresh_tokens user_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT user_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: blocks shift_blocks; Type: TRIGGER; Schema: public; Owner: vapor_username
--

CREATE TRIGGER shift_blocks AFTER UPDATE OF index ON public.blocks FOR EACH ROW WHEN (((old.flip_flag = new.flip_flag) AND (old.index <> new.index))) EXECUTE FUNCTION public.shift_blocks();


--
-- Name: levels shift_levels; Type: TRIGGER; Schema: public; Owner: vapor_username
--

CREATE TRIGGER shift_levels AFTER UPDATE OF index ON public.levels FOR EACH ROW WHEN (((old.flip_flag = new.flip_flag) AND (old.index <> new.index))) EXECUTE FUNCTION public.shift_levels();


--
-- Name: points shift_points; Type: TRIGGER; Schema: public; Owner: vapor_username
--

CREATE TRIGGER shift_points AFTER UPDATE OF index ON public.points FOR EACH ROW WHEN (((old.flip_flag = new.flip_flag) AND (old.index <> new.index))) EXECUTE FUNCTION public.shift_points();


--
-- Name: block-types block-types_superBlockTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public."block-types"
    ADD CONSTRAINT "block-types_superBlockTypeID_fkey" FOREIGN KEY ("superBlockTypeID") REFERENCES public."block-types"(id);


--
-- Name: block-types block-types_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public."block-types"
    ADD CONSTRAINT "block-types_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users(id);


--
-- Name: blocks blocks_blockTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT "blocks_blockTypeID_fkey" FOREIGN KEY ("blockTypeID") REFERENCES public."block-types"(id);


--
-- Name: blocks blocks_levelID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT "blocks_levelID_fkey" FOREIGN KEY ("levelID") REFERENCES public.levels(id);


--
-- Name: blocks blocks_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT "blocks_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users(id);


--
-- Name: levels levels_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT "levels_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users(id);


--
-- Name: points points_blockID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT "points_blockID_fkey" FOREIGN KEY ("blockID") REFERENCES public.blocks(id);


--
-- Name: points points_superPointID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT "points_superPointID_fkey" FOREIGN KEY ("superPointID") REFERENCES public.points(id);


--
-- Name: points points_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT "points_userID_fkey" FOREIGN KEY ("userID") REFERENCES public.users(id);


--
-- Name: user_email_tokens user_email_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_email_tokens
    ADD CONSTRAINT user_email_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_password_tokens user_password_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_password_tokens
    ADD CONSTRAINT user_password_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_refresh_tokens user_refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vapor_username
--

ALTER TABLE ONLY public.user_refresh_tokens
    ADD CONSTRAINT user_refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


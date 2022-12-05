--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

-- Started on 2022-12-05 22:39:29

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
-- TOC entry 3595 (class 1262 OID 17467)
-- Name: Sound Good Musical School; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Sound Good Musical School" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_Sweden.1252';


ALTER DATABASE "Sound Good Musical School" OWNER TO postgres;

\connect -reuse-previous=on "dbname='Sound Good Musical School'"

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
-- TOC entry 901 (class 1247 OID 17469)
-- Name: LVL; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."LVL" AS ENUM (
    'beginner',
    'intermediet',
    'advance'
);


ALTER TYPE public."LVL" OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 18169)
-- Name: lesson_counting(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lesson_counting(input_year integer) RETURNS TABLE(mo character varying, tot_lesson integer, ind_lesson integer, grp_lesson integer, ens_lesson integer)
    LANGUAGE sql
    AS $$
SELECT mo, tot_lesson,ind_lesson,grp_lesson,ens_lesson
FROM(SELECT TO_CHAR(time_slot.date,'MONTH') AS mo,
		   COUNT(lesson.id) AS tot_lesson, 
		   COUNT(individual_lesson.lesson_id) AS ind_lesson,
		   COUNT(group_lesson.lesson_id) AS grp_lesson,
		   COUNT(ensemble.lesson_id) AS ens_lesson
	FROM time_slot
	INNER JOIN lesson on time_slot.id = lesson.time_slot_id 
	AND EXTRACT(YEAR FROM time_slot.date) = INPUT_YEAR
	LEFT JOIN individual_lesson on lesson.id = individual_lesson.lesson_id
	LEFT JOIN group_lesson on lesson.id = group_lesson.lesson_id
	LEFT JOIN ensemble on lesson.id = ensemble.lesson_id
	group by mo) AS f
ORDER BY EXTRACT(MONTH FROM TO_DATE(mo,'MONTH'));
$$;


ALTER FUNCTION public.lesson_counting(input_year integer) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 18168)
-- Name: overworking(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.overworking(max_lesson integer) RETURNS TABLE(number_of_lessons integer, instructor integer)
    LANGUAGE sql
    AS $$
SELECT COUNT(instructor) AS number_of_lessons,instructor
FROM (SELECT lesson.instructor_id AS instructor, time_slot.date AS date
	FROM lesson
	INNER JOIN time_slot 
	on lesson.time_slot_id = time_slot.id 
	AND EXTRACT(MONTH FROM date) = (EXTRACT(MONTH FROM CURRENT_DATE))
	AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE)) AS f
GROUP BY instructor
HAVING COUNT(instructor) > max_lesson
ORDER BY number_of_lessons;
$$;


ALTER FUNCTION public.overworking(max_lesson integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 17547)
-- Name: contact_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_person (
    id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.contact_person OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17545)
-- Name: contact_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_person_id_seq OWNER TO postgres;

--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 231
-- Name: contact_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_person_id_seq OWNED BY public.contact_person.id;


--
-- TOC entry 232 (class 1259 OID 17546)
-- Name: contact_person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_person_person_id_seq OWNER TO postgres;

--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 232
-- Name: contact_person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_person_person_id_seq OWNED BY public.contact_person.person_id;


--
-- TOC entry 215 (class 1259 OID 17476)
-- Name: email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email (
    id bigint NOT NULL,
    email_adress character varying(500)
);


ALTER TABLE public.email OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17475)
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_id_seq OWNER TO postgres;

--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 214
-- Name: email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_id_seq OWNED BY public.email.id;


--
-- TOC entry 261 (class 1259 OID 17655)
-- Name: ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble (
    lesson_id bigint NOT NULL,
    genre character varying(500),
    min_number integer DEFAULT 5 NOT NULL,
    max_number integer DEFAULT 20 NOT NULL
);


ALTER TABLE public.ensemble OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 17654)
-- Name: ensemble_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ensemble_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ensemble_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 260
-- Name: ensemble_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ensemble_lesson_id_seq OWNED BY public.ensemble.lesson_id;


--
-- TOC entry 276 (class 1259 OID 18215)
-- Name: ensemble_schedule; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ensemble_schedule AS
SELECT
    NULL::bigint AS lesson_id,
    NULL::character varying(500) AS genre,
    NULL::text AS weekday,
    NULL::bigint AS booked_students,
    NULL::text AS seat_information;


ALTER TABLE public.ensemble_schedule OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 17685)
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    lesson_id bigint NOT NULL,
    instrument_to_play character varying(500),
    min_number integer DEFAULT 5 NOT NULL,
    max_number integer DEFAULT 20 NOT NULL
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 17683)
-- Name: group_lesson_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_lesson_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_lesson_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 265
-- Name: group_lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_lesson_lesson_id_seq OWNED BY public.group_lesson.lesson_id;


--
-- TOC entry 272 (class 1259 OID 18052)
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    lesson_id bigint NOT NULL,
    instrument_to_play character varying
);


ALTER TABLE public.individual_lesson OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 18051)
-- Name: individual_lesson_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.individual_lesson_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_lesson_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 271
-- Name: individual_lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.individual_lesson_lesson_id_seq OWNED BY public.individual_lesson.lesson_id;


--
-- TOC entry 235 (class 1259 OID 17556)
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    id bigint NOT NULL,
    teach_ensemble boolean NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17554)
-- Name: instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_id_seq OWNER TO postgres;

--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 234
-- Name: instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_id_seq OWNED BY public.instructor.id;


--
-- TOC entry 267 (class 1259 OID 17958)
-- Name: instructor_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_person_id_seq OWNER TO postgres;

--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 267
-- Name: instructor_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_person_id_seq OWNED BY public.instructor.person_id;


--
-- TOC entry 238 (class 1259 OID 17565)
-- Name: instructor_time_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_time_slot (
    time_slot_id bigint NOT NULL,
    instructor_id bigint NOT NULL
);


ALTER TABLE public.instructor_time_slot OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17564)
-- Name: instructor_time_slot_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_time_slot_instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_time_slot_instructor_id_seq OWNER TO postgres;

--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 237
-- Name: instructor_time_slot_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_time_slot_instructor_id_seq OWNED BY public.instructor_time_slot.instructor_id;


--
-- TOC entry 236 (class 1259 OID 17563)
-- Name: instructor_time_slot_time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_time_slot_time_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_time_slot_time_slot_id_seq OWNER TO postgres;

--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 236
-- Name: instructor_time_slot_time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_time_slot_time_slot_id_seq OWNED BY public.instructor_time_slot.time_slot_id;


--
-- TOC entry 274 (class 1259 OID 18148)
-- Name: instrument_to_learn; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_to_learn (
    student_id bigint NOT NULL,
    instrument_type character varying(500) NOT NULL,
    present_level public."LVL"
);


ALTER TABLE public.instrument_to_learn OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 18002)
-- Name: instrument_to_teach; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_to_teach (
    instructor_id bigint NOT NULL,
    instrument_type character varying(500) NOT NULL
);


ALTER TABLE public.instrument_to_teach OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 18001)
-- Name: instrument_to_teach_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_to_teach_instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_to_teach_instructor_id_seq OWNER TO postgres;

--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 269
-- Name: instrument_to_teach_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_to_teach_instructor_id_seq OWNED BY public.instrument_to_teach.instructor_id;


--
-- TOC entry 273 (class 1259 OID 18147)
-- Name: instruments_to_learn_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instruments_to_learn_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instruments_to_learn_student_id_seq OWNER TO postgres;

--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 273
-- Name: instruments_to_learn_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instruments_to_learn_student_id_seq OWNED BY public.instrument_to_learn.student_id;


--
-- TOC entry 243 (class 1259 OID 17594)
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    id bigint NOT NULL,
    location character varying(500),
    time_slot_id bigint NOT NULL,
    price_id bigint NOT NULL,
    instructor_id bigint NOT NULL
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17590)
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 239
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- TOC entry 242 (class 1259 OID 17593)
-- Name: lesson_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_instructor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_instructor_id_seq OWNER TO postgres;

--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 242
-- Name: lesson_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_instructor_id_seq OWNED BY public.lesson.instructor_id;


--
-- TOC entry 241 (class 1259 OID 17592)
-- Name: lesson_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_price_id_seq OWNER TO postgres;

--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 241
-- Name: lesson_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_price_id_seq OWNED BY public.lesson.price_id;


--
-- TOC entry 240 (class 1259 OID 17591)
-- Name: lesson_time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_time_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_time_slot_id_seq OWNER TO postgres;

--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 240
-- Name: lesson_time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_time_slot_id_seq OWNED BY public.lesson.time_slot_id;


--
-- TOC entry 217 (class 1259 OID 17485)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id bigint NOT NULL,
    ssn character varying(15) NOT NULL,
    first_name character varying(500) NOT NULL,
    last_name character varying(500) NOT NULL,
    street character varying(500),
    zip character varying(500),
    adress character varying(500),
    CONSTRAINT person_ssn_ck CHECK ((length((ssn)::text) = 15))
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17495)
-- Name: person_email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_email (
    email_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.person_email OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17493)
-- Name: person_email_id_email_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_email_id_email_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_email_id_email_seq OWNER TO postgres;

--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 218
-- Name: person_email_id_email_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_email_id_email_seq OWNED BY public.person_email.email_id;


--
-- TOC entry 219 (class 1259 OID 17494)
-- Name: person_email_id_person_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_email_id_person_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_email_id_person_seq OWNER TO postgres;

--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 219
-- Name: person_email_id_person_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_email_id_person_seq OWNED BY public.person_email.person_id;


--
-- TOC entry 216 (class 1259 OID 17484)
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO postgres;

--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 216
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- TOC entry 246 (class 1259 OID 17607)
-- Name: person_phone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_phone (
    phone_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.person_phone OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17606)
-- Name: person_phone_id_person_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_phone_id_person_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_phone_id_person_seq OWNER TO postgres;

--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 245
-- Name: person_phone_id_person_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_phone_id_person_seq OWNED BY public.person_phone.person_id;


--
-- TOC entry 244 (class 1259 OID 17605)
-- Name: person_phone_id_phone_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.person_phone_id_phone_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_phone_id_phone_seq OWNER TO postgres;

--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 244
-- Name: person_phone_id_phone_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.person_phone_id_phone_seq OWNED BY public.person_phone.phone_id;


--
-- TOC entry 222 (class 1259 OID 17503)
-- Name: phone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phone (
    id bigint NOT NULL,
    phone_number character varying(500) NOT NULL
);


ALTER TABLE public.phone OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17502)
-- Name: phone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phone_id_seq OWNER TO postgres;

--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 221
-- Name: phone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phone_id_seq OWNED BY public.phone.id;


--
-- TOC entry 224 (class 1259 OID 17512)
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id bigint NOT NULL,
    discount integer,
    fee integer,
    payment integer,
    price_name character varying(500)
);


ALTER TABLE public.price OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17511)
-- Name: price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_id_seq OWNER TO postgres;

--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 223
-- Name: price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_id_seq OWNED BY public.price.id;


--
-- TOC entry 264 (class 1259 OID 17676)
-- Name: rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rental (
    student_id bigint NOT NULL,
    specific_instrument_id bigint NOT NULL,
    day_of_rent date NOT NULL
);


ALTER TABLE public.rental OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 17675)
-- Name: rental_specific_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rental_specific_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rental_specific_instrument_id_seq OWNER TO postgres;

--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 263
-- Name: rental_specific_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rental_specific_instrument_id_seq OWNED BY public.rental.specific_instrument_id;


--
-- TOC entry 262 (class 1259 OID 17674)
-- Name: rental_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rental_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rental_student_id_seq OWNER TO postgres;

--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 262
-- Name: rental_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rental_student_id_seq OWNED BY public.rental.student_id;


--
-- TOC entry 249 (class 1259 OID 17616)
-- Name: siblings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siblings (
    sibling_a_id bigint NOT NULL,
    sibling_b_id bigint NOT NULL
);


ALTER TABLE public.siblings OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17531)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 18162)
-- Name: sibling_count; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sibling_count AS
 SELECT count(*) AS count,
    f.number_of_siblings
   FROM ( SELECT student.id,
            count(siblings.sibling_a_id) AS number_of_siblings
           FROM (public.student
             LEFT JOIN public.siblings ON (((student.id = siblings.sibling_a_id) OR (student.id = siblings.sibling_b_id))))
          GROUP BY student.id
         HAVING (count(siblings.sibling_a_id) <= 2)
          ORDER BY (count(siblings.sibling_a_id))) f
  GROUP BY f.number_of_siblings;


ALTER TABLE public.sibling_count OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17614)
-- Name: siblings_sibling_a_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.siblings_sibling_a_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.siblings_sibling_a_id_seq OWNER TO postgres;

--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 247
-- Name: siblings_sibling_a_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.siblings_sibling_a_id_seq OWNED BY public.siblings.sibling_a_id;


--
-- TOC entry 248 (class 1259 OID 17615)
-- Name: siblings_sibling_b_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.siblings_sibling_b_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.siblings_sibling_b_id_seq OWNER TO postgres;

--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 248
-- Name: siblings_sibling_b_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.siblings_sibling_b_id_seq OWNED BY public.siblings.sibling_b_id;


--
-- TOC entry 253 (class 1259 OID 17626)
-- Name: specific_instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specific_instrument (
    id bigint NOT NULL,
    id_stock bigint NOT NULL,
    brand character varying(500) NOT NULL,
    price_to_rent bigint NOT NULL,
    instrument_name character varying(500) NOT NULL
);


ALTER TABLE public.specific_instrument OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17623)
-- Name: specific_instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specific_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specific_instrument_id_seq OWNER TO postgres;

--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 250
-- Name: specific_instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specific_instrument_id_seq OWNED BY public.specific_instrument.id;


--
-- TOC entry 251 (class 1259 OID 17624)
-- Name: specific_instrument_id_stock_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specific_instrument_id_stock_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specific_instrument_id_stock_seq OWNER TO postgres;

--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 251
-- Name: specific_instrument_id_stock_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specific_instrument_id_stock_seq OWNED BY public.specific_instrument.id_stock;


--
-- TOC entry 252 (class 1259 OID 17625)
-- Name: specific_instrument_price_to_rent_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specific_instrument_price_to_rent_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.specific_instrument_price_to_rent_seq OWNER TO postgres;

--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 252
-- Name: specific_instrument_price_to_rent_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specific_instrument_price_to_rent_seq OWNED BY public.specific_instrument.price_to_rent;


--
-- TOC entry 226 (class 1259 OID 17521)
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    id bigint NOT NULL,
    instrument_type character varying(500) NOT NULL
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17520)
-- Name: stock_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_id_seq OWNER TO postgres;

--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 225
-- Name: stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_id_seq OWNED BY public.stock.id;


--
-- TOC entry 256 (class 1259 OID 17638)
-- Name: student_contact_person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_contact_person (
    contact_person_id bigint NOT NULL,
    student_id bigint NOT NULL
);


ALTER TABLE public.student_contact_person OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 17636)
-- Name: student_contact_person_contact_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_contact_person_contact_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_contact_person_contact_person_id_seq OWNER TO postgres;

--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 254
-- Name: student_contact_person_contact_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_contact_person_contact_person_id_seq OWNED BY public.student_contact_person.contact_person_id;


--
-- TOC entry 255 (class 1259 OID 17637)
-- Name: student_contact_person_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_contact_person_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_contact_person_student_id_seq OWNER TO postgres;

--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 255
-- Name: student_contact_person_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_contact_person_student_id_seq OWNED BY public.student_contact_person.student_id;


--
-- TOC entry 227 (class 1259 OID 17529)
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_id_seq OWNER TO postgres;

--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 227
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- TOC entry 259 (class 1259 OID 17647)
-- Name: student_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_lesson (
    student_id bigint NOT NULL,
    lesson_id bigint NOT NULL
);


ALTER TABLE public.student_lesson OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 17646)
-- Name: student_lesson_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_lesson_lesson_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_lesson_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 258
-- Name: student_lesson_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_lesson_lesson_id_seq OWNED BY public.student_lesson.lesson_id;


--
-- TOC entry 257 (class 1259 OID 17645)
-- Name: student_lesson_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_lesson_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_lesson_student_id_seq OWNER TO postgres;

--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 257
-- Name: student_lesson_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_lesson_student_id_seq OWNED BY public.student_lesson.student_id;


--
-- TOC entry 268 (class 1259 OID 17986)
-- Name: student_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_person_id_seq OWNER TO postgres;

--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 268
-- Name: student_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_person_id_seq OWNED BY public.student.person_id;


--
-- TOC entry 230 (class 1259 OID 17539)
-- Name: time_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_slot (
    id bigint NOT NULL,
    start_time time(6) without time zone,
    end_time time(6) without time zone,
    date date
);


ALTER TABLE public.time_slot OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17538)
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO postgres;

--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 229
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slot.id;


--
-- TOC entry 3321 (class 2604 OID 17550)
-- Name: contact_person id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person ALTER COLUMN id SET DEFAULT nextval('public.contact_person_id_seq'::regclass);


--
-- TOC entry 3322 (class 2604 OID 17551)
-- Name: contact_person person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person ALTER COLUMN person_id SET DEFAULT nextval('public.contact_person_person_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 17479)
-- Name: email id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email ALTER COLUMN id SET DEFAULT nextval('public.email_id_seq'::regclass);


--
-- TOC entry 3342 (class 2604 OID 17658)
-- Name: ensemble lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble ALTER COLUMN lesson_id SET DEFAULT nextval('public.ensemble_lesson_id_seq'::regclass);


--
-- TOC entry 3347 (class 2604 OID 17688)
-- Name: group_lesson lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.group_lesson_lesson_id_seq'::regclass);


--
-- TOC entry 3351 (class 2604 OID 18055)
-- Name: individual_lesson lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.individual_lesson_lesson_id_seq'::regclass);


--
-- TOC entry 3323 (class 2604 OID 17559)
-- Name: instructor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN id SET DEFAULT nextval('public.instructor_id_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 17959)
-- Name: instructor person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN person_id SET DEFAULT nextval('public.instructor_person_id_seq'::regclass);


--
-- TOC entry 3325 (class 2604 OID 17568)
-- Name: instructor_time_slot time_slot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_time_slot ALTER COLUMN time_slot_id SET DEFAULT nextval('public.instructor_time_slot_time_slot_id_seq'::regclass);


--
-- TOC entry 3326 (class 2604 OID 17569)
-- Name: instructor_time_slot instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_time_slot ALTER COLUMN instructor_id SET DEFAULT nextval('public.instructor_time_slot_instructor_id_seq'::regclass);


--
-- TOC entry 3352 (class 2604 OID 18151)
-- Name: instrument_to_learn student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_learn ALTER COLUMN student_id SET DEFAULT nextval('public.instruments_to_learn_student_id_seq'::regclass);


--
-- TOC entry 3350 (class 2604 OID 18005)
-- Name: instrument_to_teach instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_teach ALTER COLUMN instructor_id SET DEFAULT nextval('public.instrument_to_teach_instructor_id_seq'::regclass);


--
-- TOC entry 3327 (class 2604 OID 17597)
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- TOC entry 3328 (class 2604 OID 17598)
-- Name: lesson time_slot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN time_slot_id SET DEFAULT nextval('public.lesson_time_slot_id_seq'::regclass);


--
-- TOC entry 3329 (class 2604 OID 17599)
-- Name: lesson price_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN price_id SET DEFAULT nextval('public.lesson_price_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 17600)
-- Name: lesson instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN instructor_id SET DEFAULT nextval('public.lesson_instructor_id_seq'::regclass);


--
-- TOC entry 3312 (class 2604 OID 17488)
-- Name: person id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- TOC entry 3313 (class 2604 OID 17498)
-- Name: person_email email_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email ALTER COLUMN email_id SET DEFAULT nextval('public.person_email_id_email_seq'::regclass);


--
-- TOC entry 3314 (class 2604 OID 17499)
-- Name: person_email person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email ALTER COLUMN person_id SET DEFAULT nextval('public.person_email_id_person_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 17610)
-- Name: person_phone phone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone ALTER COLUMN phone_id SET DEFAULT nextval('public.person_phone_id_phone_seq'::regclass);


--
-- TOC entry 3332 (class 2604 OID 17611)
-- Name: person_phone person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone ALTER COLUMN person_id SET DEFAULT nextval('public.person_phone_id_person_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 17506)
-- Name: phone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone ALTER COLUMN id SET DEFAULT nextval('public.phone_id_seq'::regclass);


--
-- TOC entry 3316 (class 2604 OID 17515)
-- Name: price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price ALTER COLUMN id SET DEFAULT nextval('public.price_id_seq'::regclass);


--
-- TOC entry 3345 (class 2604 OID 17679)
-- Name: rental student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental ALTER COLUMN student_id SET DEFAULT nextval('public.rental_student_id_seq'::regclass);


--
-- TOC entry 3346 (class 2604 OID 17680)
-- Name: rental specific_instrument_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental ALTER COLUMN specific_instrument_id SET DEFAULT nextval('public.rental_specific_instrument_id_seq'::regclass);


--
-- TOC entry 3333 (class 2604 OID 17619)
-- Name: siblings sibling_a_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings ALTER COLUMN sibling_a_id SET DEFAULT nextval('public.siblings_sibling_a_id_seq'::regclass);


--
-- TOC entry 3334 (class 2604 OID 17620)
-- Name: siblings sibling_b_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings ALTER COLUMN sibling_b_id SET DEFAULT nextval('public.siblings_sibling_b_id_seq'::regclass);


--
-- TOC entry 3335 (class 2604 OID 17629)
-- Name: specific_instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specific_instrument ALTER COLUMN id SET DEFAULT nextval('public.specific_instrument_id_seq'::regclass);


--
-- TOC entry 3336 (class 2604 OID 17630)
-- Name: specific_instrument id_stock; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specific_instrument ALTER COLUMN id_stock SET DEFAULT nextval('public.specific_instrument_id_stock_seq'::regclass);


--
-- TOC entry 3337 (class 2604 OID 17631)
-- Name: specific_instrument price_to_rent; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specific_instrument ALTER COLUMN price_to_rent SET DEFAULT nextval('public.specific_instrument_price_to_rent_seq'::regclass);


--
-- TOC entry 3317 (class 2604 OID 17524)
-- Name: stock id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock ALTER COLUMN id SET DEFAULT nextval('public.stock_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 17534)
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- TOC entry 3319 (class 2604 OID 17987)
-- Name: student person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN person_id SET DEFAULT nextval('public.student_person_id_seq'::regclass);


--
-- TOC entry 3338 (class 2604 OID 17641)
-- Name: student_contact_person contact_person_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_person ALTER COLUMN contact_person_id SET DEFAULT nextval('public.student_contact_person_contact_person_id_seq'::regclass);


--
-- TOC entry 3339 (class 2604 OID 17642)
-- Name: student_contact_person student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_person ALTER COLUMN student_id SET DEFAULT nextval('public.student_contact_person_student_id_seq'::regclass);


--
-- TOC entry 3340 (class 2604 OID 17650)
-- Name: student_lesson student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson ALTER COLUMN student_id SET DEFAULT nextval('public.student_lesson_student_id_seq'::regclass);


--
-- TOC entry 3341 (class 2604 OID 17651)
-- Name: student_lesson lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson ALTER COLUMN lesson_id SET DEFAULT nextval('public.student_lesson_lesson_id_seq'::regclass);


--
-- TOC entry 3320 (class 2604 OID 17542)
-- Name: time_slot id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- TOC entry 3355 (class 2606 OID 18075)
-- Name: email email_email_adress_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_email_adress_key UNIQUE (email_adress);


--
-- TOC entry 3405 (class 2606 OID 17871)
-- Name: ensemble ensemble_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_lesson_id_key UNIQUE (lesson_id);


--
-- TOC entry 3411 (class 2606 OID 17867)
-- Name: group_lesson group_lesson_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_lesson_id_key UNIQUE (lesson_id);


--
-- TOC entry 3417 (class 2606 OID 18100)
-- Name: individual_lesson individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3387 (class 2606 OID 18000)
-- Name: instructor instructor_person_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_key UNIQUE (person_id);


--
-- TOC entry 3415 (class 2606 OID 18009)
-- Name: instrument_to_teach instrument_to_teach_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_teach
    ADD CONSTRAINT instrument_to_teach_pkey PRIMARY KEY (instructor_id, instrument_type);


--
-- TOC entry 3419 (class 2606 OID 18155)
-- Name: instrument_to_learn instruments_to_learn_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_learn
    ADD CONSTRAINT instruments_to_learn_pkey PRIMARY KEY (student_id, instrument_type);


--
-- TOC entry 3359 (class 2606 OID 17875)
-- Name: person person_ssn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_ssn_key UNIQUE (ssn);


--
-- TOC entry 3361 (class 2606 OID 18079)
-- Name: person person_ssn_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_ssn_key1 UNIQUE (ssn);


--
-- TOC entry 3367 (class 2606 OID 18073)
-- Name: phone phone_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_phone_number_key UNIQUE (phone_number);


--
-- TOC entry 3385 (class 2606 OID 17553)
-- Name: contact_person pk_contact_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT pk_contact_person PRIMARY KEY (id);


--
-- TOC entry 3357 (class 2606 OID 17483)
-- Name: email pk_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT pk_email PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 17662)
-- Name: ensemble pk_ensemble; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT pk_ensemble PRIMARY KEY (lesson_id);


--
-- TOC entry 3413 (class 2606 OID 17691)
-- Name: group_lesson pk_group_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT pk_group_lesson PRIMARY KEY (lesson_id);


--
-- TOC entry 3389 (class 2606 OID 17562)
-- Name: instructor pk_instructor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT pk_instructor PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 17571)
-- Name: instructor_time_slot pk_instructor_time_slot; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_time_slot
    ADD CONSTRAINT pk_instructor_time_slot PRIMARY KEY (time_slot_id, instructor_id);


--
-- TOC entry 3393 (class 2606 OID 17604)
-- Name: lesson pk_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT pk_lesson PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 17492)
-- Name: person pk_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT pk_person PRIMARY KEY (id);


--
-- TOC entry 3365 (class 2606 OID 17501)
-- Name: person_email pk_person_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT pk_person_email PRIMARY KEY (email_id, person_id);


--
-- TOC entry 3395 (class 2606 OID 17613)
-- Name: person_phone pk_person_phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT pk_person_phone PRIMARY KEY (phone_id, person_id);


--
-- TOC entry 3369 (class 2606 OID 17510)
-- Name: phone pk_phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT pk_phone PRIMARY KEY (id);


--
-- TOC entry 3371 (class 2606 OID 17519)
-- Name: price pk_price; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT pk_price PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 17682)
-- Name: rental pk_rental; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT pk_rental PRIMARY KEY (student_id, specific_instrument_id);


--
-- TOC entry 3397 (class 2606 OID 17622)
-- Name: siblings pk_siblings; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT pk_siblings PRIMARY KEY (sibling_a_id, sibling_b_id);


--
-- TOC entry 3399 (class 2606 OID 17635)
-- Name: specific_instrument pk_specific_instrument; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specific_instrument
    ADD CONSTRAINT pk_specific_instrument PRIMARY KEY (id);


--
-- TOC entry 3375 (class 2606 OID 17528)
-- Name: stock pk_stock; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT pk_stock PRIMARY KEY (id);


--
-- TOC entry 3379 (class 2606 OID 17537)
-- Name: student pk_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT pk_student PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 17644)
-- Name: student_contact_person pk_student_contact_person; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_person
    ADD CONSTRAINT pk_student_contact_person PRIMARY KEY (contact_person_id, student_id);


--
-- TOC entry 3403 (class 2606 OID 17653)
-- Name: student_lesson pk_student_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT pk_student_lesson PRIMARY KEY (student_id, lesson_id);


--
-- TOC entry 3383 (class 2606 OID 17544)
-- Name: time_slot pk_time_slot; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT pk_time_slot PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 18071)
-- Name: price price_price_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_name_key UNIQUE (price_name);


--
-- TOC entry 3377 (class 2606 OID 18077)
-- Name: stock stock_instrument_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_instrument_type_key UNIQUE (instrument_type);


--
-- TOC entry 3381 (class 2606 OID 17998)
-- Name: student student_person_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_id_key UNIQUE (person_id);


--
-- TOC entry 3589 (class 2618 OID 18218)
-- Name: ensemble_schedule _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.ensemble_schedule AS
 SELECT ensemble.lesson_id,
    ensemble.genre,
    to_char((time_slot.date)::timestamp with time zone, 'dy'::text) AS weekday,
    count(student_lesson.student_id) AS booked_students,
        CASE
            WHEN (count(student_lesson.student_id) >= ensemble.max_number) THEN 'FULLY BOOKED'::text
            WHEN ((count(student_lesson.student_id) + 1) = ensemble.max_number) THEN '1 SEAT LEFT'::text
            WHEN ((count(student_lesson.student_id) + 2) = ensemble.max_number) THEN '2 SEAT LEFT'::text
            ELSE 'SEATS AVAILABLE'::text
        END AS seat_information
   FROM (((public.ensemble
     JOIN public.lesson ON ((lesson.id = ensemble.lesson_id)))
     JOIN public.time_slot ON (((time_slot.id = lesson.time_slot_id) AND (date_part('week'::text, time_slot.date) = date_part('week'::text, CURRENT_DATE)) AND (EXTRACT(year FROM time_slot.date) = EXTRACT(year FROM CURRENT_DATE)))))
     JOIN public.student_lesson ON ((ensemble.lesson_id = student_lesson.lesson_id)))
  GROUP BY ensemble.lesson_id, ensemble.genre, time_slot.date
  ORDER BY (EXTRACT(dow FROM time_slot.date)), ensemble.genre;


--
-- TOC entry 3439 (class 2606 OID 17888)
-- Name: ensemble ensemble_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3423 (class 2606 OID 17725)
-- Name: contact_person fk_contact_person_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_person
    ADD CONSTRAINT fk_contact_person_0 FOREIGN KEY (person_id) REFERENCES public.person(id);


--
-- TOC entry 3427 (class 2606 OID 17755)
-- Name: lesson fk_lesson_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_0 FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- TOC entry 3428 (class 2606 OID 17760)
-- Name: lesson fk_lesson_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_1 FOREIGN KEY (price_id) REFERENCES public.price(id);


--
-- TOC entry 3429 (class 2606 OID 17765)
-- Name: lesson fk_lesson_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT fk_lesson_2 FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- TOC entry 3440 (class 2606 OID 17825)
-- Name: rental fk_rental_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_0 FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- TOC entry 3441 (class 2606 OID 17830)
-- Name: rental fk_rental_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_1 FOREIGN KEY (specific_instrument_id) REFERENCES public.specific_instrument(id);


--
-- TOC entry 3434 (class 2606 OID 17790)
-- Name: specific_instrument fk_specific_instrument_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specific_instrument
    ADD CONSTRAINT fk_specific_instrument_0 FOREIGN KEY (id_stock) REFERENCES public.stock(id);


--
-- TOC entry 3442 (class 2606 OID 18090)
-- Name: group_lesson group_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3444 (class 2606 OID 18080)
-- Name: individual_lesson individual_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3424 (class 2606 OID 17964)
-- Name: instructor instructor_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) NOT VALID;


--
-- TOC entry 3425 (class 2606 OID 18111)
-- Name: instructor_time_slot instructor_time_slot_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_time_slot
    ADD CONSTRAINT instructor_time_slot_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3426 (class 2606 OID 18106)
-- Name: instructor_time_slot instructor_time_slot_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_time_slot
    ADD CONSTRAINT instructor_time_slot_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3443 (class 2606 OID 18101)
-- Name: instrument_to_teach instrument_to_teach_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_teach
    ADD CONSTRAINT instrument_to_teach_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3445 (class 2606 OID 18156)
-- Name: instrument_to_learn instruments_to_learn_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_to_learn
    ADD CONSTRAINT instruments_to_learn_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


--
-- TOC entry 3420 (class 2606 OID 17918)
-- Name: person_email person_email_id_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_id_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3421 (class 2606 OID 17923)
-- Name: person_email person_email_id_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_email
    ADD CONSTRAINT person_email_id_person_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3430 (class 2606 OID 17933)
-- Name: person_phone person_phone_id_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_id_person_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3431 (class 2606 OID 17928)
-- Name: person_phone person_phone_id_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_phone
    ADD CONSTRAINT person_phone_id_phone_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3432 (class 2606 OID 17908)
-- Name: siblings siblings_sibling_a_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_sibling_a_id_fkey FOREIGN KEY (sibling_a_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3433 (class 2606 OID 17913)
-- Name: siblings siblings_sibling_b_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_sibling_b_id_fkey FOREIGN KEY (sibling_b_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3435 (class 2606 OID 17898)
-- Name: student_contact_person student_contact_person_contact_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_person
    ADD CONSTRAINT student_contact_person_contact_person_id_fkey FOREIGN KEY (contact_person_id) REFERENCES public.contact_person(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3436 (class 2606 OID 17903)
-- Name: student_contact_person student_contact_person_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_person
    ADD CONSTRAINT student_contact_person_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3437 (class 2606 OID 17943)
-- Name: student_lesson student_lesson_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3438 (class 2606 OID 17938)
-- Name: student_lesson student_lesson_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_lesson
    ADD CONSTRAINT student_lesson_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 3422 (class 2606 OID 17992)
-- Name: student student_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) NOT VALID;


-- Completed on 2022-12-05 22:39:29

--
-- PostgreSQL database dump complete
--


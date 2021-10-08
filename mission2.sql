CREATE DATABASE   music_library
WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;


CREATE TABLE public.song
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character(10) COLLATE pg_catalog."default" NOT NULL,
    executor_id  integer,
    duration  time with time zone,
    release_date timestamp without time zone,
    CONSTRAINT song_pkey PRIMARY KEY (id),
    CONSTRAINT foreign_key_1 FOREIGN KEY (executor_id)
        REFERENCES public.executor (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE public.executor
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character(10) COLLATE pg_catalog."default",
    CONSTRAINT executor_pkey PRIMARY KEY (id)
);

CREATE TABLE public.genre
(
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    name character(10) COLLATE pg_catalog."default",
    executor_id  integer,
    song_id  integer,
    CONSTRAINT genre_pkey PRIMARY KEY (id),
    CONSTRAINT foreign_key_1 FOREIGN KEY (executor_id)
        REFERENCES public.executor (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        CONSTRAINT foreign_key_2 FOREIGN KEY (song_id)
        REFERENCES public.song (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION random_between(low INT ,high INT)
    RETURNS INT AS
$$
BEGIN
    RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_string() returns text AS
$$
declare
    chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    result text := '';
    i integer := 0;
begin
    for i in 1..10 loop
            result := result || chars[1+random()*(array_length(chars, 1)-1)];
        end loop;
    return result;
end
$$ language plpgsql;

INSERT INTO song(name,executor_id,duration,release_date)
SELECT
    random_string(),
    random_between (1,20),
    date_trunc('second',FORMAT(NOW(),'hh:mm') + (random() )),
    date_trunc('second',LOCALTIMESTAMP(1) + (random() * ( LOCALTIMESTAMP(1)+'90 days' -  LOCALTIMESTAMP(1))))
FROM generate_series(1,20);


INSERT INTO genre(name,executor_id,song_id)
SELECT
    random_string(),
    random_between (1,20),
    random_between (1,20)
FROM generate_series(1,20);

INSERT INTO executor(name)
SELECT
    random_string()
FROM generate_series(1,20);


SELECT song.name, song.duration, song.release_date FROM public.song
    INNER JOIN genre g on song.id = g.song_id WHERE g.name='Rock' ORDER BY song.release_date limit 10;


SELECT  executor.name, COUNT(s.id) FROM public.executor inner join song s on executor.id = s.executor_id GROUP BY  s.executor_id
ORDER BY COUNT(s.executor_id) DESC  limit 5;


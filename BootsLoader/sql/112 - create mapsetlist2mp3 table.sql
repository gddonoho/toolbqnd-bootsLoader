CREATE TABLE IF NOT EXISTS public.mapsetlist2mp3
(
    concertid integer NOT NULL,
    setlistsongorder integer NOT NULL,
    mp3linksongorder integer NOT NULL,
    CONSTRAINT fk_concert FOREIGN KEY (concertid)
        REFERENCES public.concert (concertid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;
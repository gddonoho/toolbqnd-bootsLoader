CREATE TABLE IF NOT EXISTS public.recording
(
    recordingid integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    concertid integer NOT NULL,
    linkurl character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT fk_concert FOREIGN KEY (concertid)
        REFERENCES public.concert (concertid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS unq_recording
    ON public.recording USING btree
    (recordingid ASC NULLS LAST)
    TABLESPACE pg_default;
CREATE TABLE IF NOT EXISTS public.mp3link
(
    recordingid integer NOT NULL,
    songorder integer NOT NULL,
    linkurl character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT fk_recording FOREIGN KEY (recordingid)
        REFERENCES public.recording (recordingid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS unq_recording_song
    ON public.mp3link USING btree
    (recordingid ASC NULLS LAST, songorder ASC NULLS LAST)
    TABLESPACE pg_default;
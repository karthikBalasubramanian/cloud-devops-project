\c postgres;
CREATE SCHEMA translation;

SET search_path TO translation;

CREATE TABLE translator (
    origin text,
    origin_language text,
    translation text,
    translation_language text
);


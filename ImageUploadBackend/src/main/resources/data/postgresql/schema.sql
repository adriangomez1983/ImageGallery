DROP TABLE IF EXISTS image;

CREATE TABLE image (
    id uuid PRIMARY KEY NOT NULL,
    created_at timestamp without time zone,
    data bytea,
    description character varying(255),
    display_name character varying(255),
    favorite boolean,
    main boolean,
    url character varying(255)
);
--liquibase formatted sql

--changeset anthon haväng:001-create-browse-schema runInTransaction:true

-- 1) Top-level browse cards (the outer card headers in UI)
CREATE TABLE browse_group
(
    id            BIGSERIAL PRIMARY KEY,
    key           TEXT        NOT NULL UNIQUE, -- e.g. official_swedish, semi_official_swedish, foreign, international
    title_sv      TEXT        NOT NULL,
    title_en      TEXT        NOT NULL,
    display_order INTEGER     NOT NULL CHECK (display_order > 0),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (display_order)
);

-- 2) Categories (A..L, foreign, international)
CREATE TABLE category
(
    id              BIGSERIAL PRIMARY KEY,
    browse_group_id BIGINT      NOT NULL REFERENCES browse_group (id) ON DELETE RESTRICT,
    code            TEXT        NOT NULL UNIQUE, -- e.g. A, B, ..., L, foreign, international
    title_sv        TEXT        NOT NULL,
    title_en        TEXT        NOT NULL,
    display_order   INTEGER     NOT NULL CHECK (display_order > 0),
    is_expandable   BOOLEAN     NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (browse_group_id, display_order)
);

-- 3) Optional subcategories under a category
CREATE TABLE subcategory
(
    id            BIGSERIAL PRIMARY KEY,
    category_id   BIGINT      NOT NULL REFERENCES category (id) ON DELETE CASCADE,
    key           TEXT        NOT NULL, -- stable key inside category
    title_sv      TEXT        NOT NULL,
    title_en      TEXT        NOT NULL,
    display_order INTEGER     NOT NULL CHECK (display_order > 0),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (category_id, key),
    UNIQUE (category_id, display_order)
);

-- 4) Decorations/medals
--    Can belong EITHER directly to category OR to subcategory (exclusive).
CREATE TABLE decoration
(
    id             BIGSERIAL PRIMARY KEY,
    category_id    BIGINT REFERENCES category (id) ON DELETE CASCADE,
    subcategory_id BIGINT REFERENCES subcategory (id) ON DELETE CASCADE,

    name_sv        TEXT        NOT NULL,
    name_en        TEXT        NOT NULL,

    -- "Initial number" used by K/L etc; nullable where not used
    initial_number INTEGER CHECK (initial_number > 0),

    -- for display/sort flexibility: some data uses year, some doesn't
    year_display   TEXT, -- e.g. "1909", "2006", "före 1976 ..."
    year_sort      INTEGER CHECK (year_sort BETWEEN 1500 AND 2100),

    -- descriptive text for modal/details
    description_sv TEXT,
    description_en TEXT,

    -- deterministic ordering from source data
    display_order  INTEGER     NOT NULL CHECK (display_order > 0),

    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Must belong to exactly one parent level
    CHECK (
        (category_id IS NOT NULL AND subcategory_id IS NULL)
            OR
        (category_id IS NULL AND subcategory_id IS NOT NULL)
        )
);

CREATE UNIQUE INDEX uq_decoration_category_order
    ON decoration (category_id, display_order)
    WHERE subcategory_id IS NULL;

CREATE UNIQUE INDEX uq_decoration_subcategory_order
    ON decoration (subcategory_id, display_order)
    WHERE subcategory_id IS NOT NULL;

CREATE UNIQUE INDEX uq_decoration_category_initial
    ON decoration (category_id, initial_number)
    WHERE subcategory_id IS NULL AND initial_number IS NOT NULL;

CREATE UNIQUE INDEX uq_decoration_subcategory_initial
    ON decoration (subcategory_id, initial_number)
    WHERE category_id IS NULL AND initial_number IS NOT NULL;

CREATE TABLE decoration_short_code
(
    id             BIGSERIAL PRIMARY KEY,
    decoration_id  BIGINT      NOT NULL REFERENCES decoration (id) ON DELETE CASCADE,
    short_code     TEXT        NOT NULL,
    display_order  INTEGER     NOT NULL CHECK (display_order > 0),
    description_sv TEXT,
    description_en TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (decoration_id, display_order)
);


CREATE TABLE decoration_ribbon_image
(
    id            BIGSERIAL PRIMARY KEY,
    decoration_id BIGINT      NOT NULL REFERENCES decoration (id) ON DELETE CASCADE,
    image_url     TEXT        NOT NULL,
    label_sv      TEXT,
    label_en      TEXT,
    is_primary    BOOLEAN     NOT NULL DEFAULT false,
    display_order INTEGER     NOT NULL CHECK (display_order > 0),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (decoration_id, display_order)
);

CREATE UNIQUE INDEX uq_ribbon_primary_per_decoration
    ON decoration_ribbon_image (decoration_id)
    WHERE is_primary = true;

CREATE TABLE decoration_medal_image
(
    id            BIGSERIAL PRIMARY KEY,
    decoration_id BIGINT      NOT NULL REFERENCES decoration (id) ON DELETE CASCADE,
    image_url     TEXT        NOT NULL,
    label_sv      TEXT,
    label_en      TEXT,
    is_primary    BOOLEAN     NOT NULL DEFAULT false,
    display_order INTEGER     NOT NULL CHECK (display_order > 0),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (decoration_id, display_order)
);

CREATE UNIQUE INDEX uq_medal_primary_per_decoration
    ON decoration_medal_image (decoration_id)
    WHERE is_primary = true;

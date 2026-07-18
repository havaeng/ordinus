--liquibase formatted sql

--changeset anthon.havang:008-add-decoration-status-fields

ALTER TABLE decoration
    ADD COLUMN IF NOT EXISTS is_commemorative  BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS is_active         BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN IF NOT EXISTS country_of_origin TEXT;

ALTER TABLE decoration_short_code
    ADD COLUMN IF NOT EXISTS is_active       BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN IF NOT EXISTS display_in_list BOOLEAN NOT NULL DEFAULT true;

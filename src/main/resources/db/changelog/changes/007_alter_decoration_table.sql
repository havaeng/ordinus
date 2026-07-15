--liquibase formatted sql

--changeset anthon.havang:007-alter-decoration-table

ALTER TABLE decoration
    ALTER COLUMN name_en DROP NOT NULL;

ALTER TABLE decoration
    DROP COLUMN IF EXISTS year_sort;

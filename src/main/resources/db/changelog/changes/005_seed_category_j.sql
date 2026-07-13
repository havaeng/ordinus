--liquibase formatted sql

--changeset anthon.haväng:005-seed-category-j runInTransaction:true
--preconditions onFail:HALT
--precondition-sql-check expectedResult:1 SELECT COUNT(*) FROM category WHERE code = 'J';

-- Re-seed Category J (idempotent)
DELETE
FROM decoration_short_code
WHERE decoration_id IN (SELECT d.id
                        FROM decoration d
                                 JOIN category c ON c.id = d.category_id
                        WHERE c.code = 'J');

DELETE
FROM decoration
WHERE category_id = (SELECT id FROM category WHERE code = 'J');



WITH j_src(initial_number, display_order, name_sv, description_sv, abbr_pipe) AS (VALUES (1, 1, 'Johanniterorden', NULL,
                                                                                          'RRJohO|RJohO')),
     jcat AS (SELECT id
              FROM category
              WHERE code = 'J')
INSERT
INTO decoration (category_id, subcategory_id, name_sv, name_en, initial_number,
                 year_display, year_sort, description_sv, description_en, display_order)
SELECT jcat.id,
       NULL,
       j.name_sv,
       j.name_sv,
       j.initial_number,
       NULL,
       NULL,
       j.description_sv,
       j.description_sv,
       j.display_order
FROM j_src j
         CROSS JOIN jcat;

WITH j_src(initial_number, abbr_pipe) AS (VALUES (1, 'RRJohO|RJohO'))
INSERT
INTO decoration_short_code (decoration_id, short_code, display_order, description_sv, description_en)
SELECT d.id,
       trim(a.abbr),
       a.ord::int,
       NULL,
       NULL
FROM j_src j
         JOIN category c ON c.code = 'J'
         JOIN decoration d ON d.category_id = c.id AND d.initial_number = j.initial_number
         CROSS JOIN LATERAL unnest(string_to_array(j.abbr_pipe, '|')) WITH ORDINALITY AS a(abbr, ord);

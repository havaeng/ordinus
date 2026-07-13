--liquibase formatted sql

--changeset anthon.havang:004-insert-categories runInTransaction:true splitStatements:false

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'A',
       'Kategori A - Kungl. Maj:ts orden (Kungl. Serafimerorden)',
       'Category A - The Royal Order of the Seraphim',
       1,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'B',
       'Kategori B - Svenska krigsdekorationer m.m',
       'Category B - Swedish War Decorations, etc.',
       2,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'C',
       'Kategori C - Kungliga minnetecken',
       'Category C - Royal Commemorative Medals',
       3,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'D',
       'Kategori D - H.M. Konungens medaljer',
       'Category D - H.M. The King''s Medals',
       4,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'E',
       'Kategori E - De kungliga riddarordnarna',
       'Category E - The Royal Orders of Knighthood',
       5,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'F',
       'Kategori F - Officiella svenska ordensmedaljer',
       'Category F - Official Swedish Order Medals',
       6,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'G',
       'Kategori G - Av regeringen utdelade Kungliga medaljer',
       'Category G - Royal Medals Awarded by the Government',
       7,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'H',
       'Kategori H - Medalj som vid särskilt tillfälle förlänats av H.M. Konungen i hovprotokoll',
       'Category H - Medal Awarded by H.M. The King on Special Occasions in the Court Protocol',
       8,
       true
FROM browse_group bg
WHERE bg.key = 'official_swedish';

UPDATE category
SET title_sv = 'Kategori I - Övriga officiella medaljer',
    title_en = 'Category I - Other Official Medals'
WHERE code = 'I';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'J',
       'Kategori J - Halvofficiell orden',
       'Category J - Semi-Official Order',
       1,
       true
FROM browse_group bg
WHERE bg.key = 'semi_official_swedish';

UPDATE category
SET title_sv = 'Kategori K - Halvofficiella medaljer',
    title_en = 'Category K - Semi-Official Medals'
WHERE code = 'K';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'L',
       'Kategori L - Halvofficiella medaljer',
       'Category L - Semi-Official Medals',
       1,
       true
FROM browse_group bg
WHERE bg.key = 'swedish_without_state_emblem';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'foreign',
       'Utländska utmärkelser',
       'Foreign Awards',
       1,
       true
FROM browse_group bg
WHERE bg.key = 'foreign';

INSERT INTO category (browse_group_id, code, title_sv, title_en, display_order, is_expandable)
SELECT bg.id,
       'international',
       'Internationella utmärkelser',
       'International Awards',
       1,
       true
FROM browse_group bg
WHERE bg.key = 'international';

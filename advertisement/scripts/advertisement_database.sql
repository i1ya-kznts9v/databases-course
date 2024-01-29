---------------------------------------------------------------
-- Создание базы данных
---------------------------------------------------------------

-- CREATE DATABASE advertisement_db;
-- \c advertisement_db

---------------------------------------------------------------
-- Создание таблиц, primary key (PK) и базовых ограничений
-- целостности (constraint)
---------------------------------------------------------------

CREATE TABLE advertiser
(
    advertiser_id INTEGER            NOT NULL,
    full_name     VARCHAR(64)        NOT NULL,
    address       VARCHAR(64)        NOT NULL,
    phone         VARCHAR(64) UNIQUE NOT NULL,
    email         VARCHAR(64) UNIQUE NOT NULL,
    CONSTRAINT advertiser_pk PRIMARY KEY (advertiser_id),
    CONSTRAINT not_empty_advertiser_name CHECK (LENGTH(TRIM(full_name)) > 0)
)
;


CREATE TABLE contract
(
    contract_id      INTEGER                        NOT NULL,
    advertiser_id    INTEGER                        NOT NULL,
    advertisement_id INTEGER                        NOT NULL,
    contract_date    DATE DEFAULT CURRENT_DATE      NOT NULL,
    -- By default, the company takes a week to review and place ads --
    placement_date   DATE DEFAULT CURRENT_DATE + 7  NOT NULL,
    -- By default, the company places ads for a month --
    expiration_date  DATE DEFAULT CURRENT_DATE + 31 NOT NULL,
    -- When the period expires, the contract is deactivated --
    is_active        BOOL DEFAULT TRUE              NOT NULL,
    CONSTRAINT contract_pk PRIMARY KEY (contract_id),
    CONSTRAINT correct_placement_date CHECK (placement_date >= contract_date),
    CONSTRAINT correct_expiration_date CHECK (expiration_date > placement_date)
)
;


CREATE TABLE report
(
    report_id        INTEGER              NOT NULL,
    advertiser_id    INTEGER              NOT NULL,
    advertisement_id INTEGER              NOT NULL,
    message          VARCHAR DEFAULT NULL NULL,
    CONSTRAINT report_pk PRIMARY KEY (report_id)
)
;


CREATE TABLE advertisement_type
(
    advertisement_type_id INTEGER            NOT NULL,
    type                  VARCHAR(64) UNIQUE NOT NULL,
    CONSTRAINT advertisement_type_pk PRIMARY KEY (advertisement_type_id)
)
;


CREATE TABLE advertisement
(
    advertisement_id      INTEGER NOT NULL,
    advertisement_type_id INTEGER NOT NULL,
    CONSTRAINT advertisement_pk PRIMARY KEY (advertisement_id)
)
;


CREATE TABLE mass_media
(
    mass_media_id         INTEGER     NOT NULL,
    advertisement_type_id INTEGER     NOT NULL,
    full_name             VARCHAR(64) NOT NULL,
    CONSTRAINT mass_media_pk PRIMARY KEY (mass_media_id),
    CONSTRAINT not_empty_mass_media_name CHECK (LENGTH(TRIM(full_name)) > 0)
)
;


CREATE TABLE advertisement_mass_media
(
    advertisement_id INTEGER NOT NULL,
    mass_media_id    INTEGER NOT NULL
    --CONSTRAINT unique_advertisement_mass_media UNIQUE (advertisement_id, mass_media_id)
)
;


CREATE TABLE advertisement_data
(
    advertisement_data_id INTEGER              NOT NULL,
    advertisement_id      INTEGER              NOT NULL,
    heading               VARCHAR(64)          NOT NULL,
    -- Content URL, number, path, etc or NULL if it's not --
    content               VARCHAR DEFAULT NULL NULL,
    CONSTRAINT advertisement_data_pk PRIMARY KEY (advertisement_data_id),
    CONSTRAINT not_empty_heading CHECK (LENGTH(TRIM(heading)) > 0)
)
;


CREATE TABLE advertisement_review
(
    advertisement_review_id INTEGER               NOT NULL,
    advertisement_id        INTEGER               NOT NULL,
    -- By default, the company considers ads to be unverified --
    acceptance              BOOL    DEFAULT FALSE NOT NULL,
    -- By default, the company sets the maximum age limit --
    age_limit               INTEGER DEFAULT 21    NOT NULL,
    -- Document URL, number, path, etc or NULL if it's not --
    document                VARCHAR DEFAULT NULL  NULL,
    CONSTRAINT advertisement_review_pk PRIMARY KEY (advertisement_review_id)
)
;

---------------------------------------------------------------
-- Создание foreign key (FK)
---------------------------------------------------------------

ALTER TABLE advertisement_data
    ADD CONSTRAINT data_advertisement_fk
        FOREIGN KEY (advertisement_id)
            REFERENCES advertisement (advertisement_id) ON DELETE CASCADE
;


ALTER TABLE advertisement_review
    ADD CONSTRAINT review_advertisement_fk
        FOREIGN KEY (advertisement_id)
            REFERENCES advertisement (advertisement_id) ON DELETE CASCADE
;


ALTER TABLE advertisement
    ADD CONSTRAINT advertisement_type_fk
        FOREIGN KEY (advertisement_type_id)
            REFERENCES advertisement_type (advertisement_type_id)
;


ALTER TABLE mass_media
    ADD CONSTRAINT mass_media_type_fk
        FOREIGN KEY (advertisement_type_id)
            REFERENCES advertisement_type (advertisement_type_id)
;


ALTER TABLE advertisement_mass_media
    ADD CONSTRAINT advertisement_fk
        FOREIGN KEY (advertisement_id)
            REFERENCES advertisement (advertisement_id)
;


ALTER TABLE advertisement_mass_media
    ADD CONSTRAINT mass_media_fk
        FOREIGN KEY (mass_media_id)
            REFERENCES mass_media (mass_media_id)
;


ALTER TABLE report
    ADD CONSTRAINT report_advertiser_fk
        FOREIGN KEY (advertiser_id)
            REFERENCES advertiser (advertiser_id)
;


ALTER TABLE report
    ADD CONSTRAINT report_advertisement_fk
        FOREIGN KEY (advertisement_id)
            REFERENCES advertisement (advertisement_id)
;


ALTER TABLE contract
    ADD CONSTRAINT contract_advertiser_fk
        FOREIGN KEY (advertiser_id)
            REFERENCES advertiser (advertiser_id)
;


ALTER TABLE contract
    ADD CONSTRAINT contract_advertisement_fk
        FOREIGN KEY (advertisement_id)
            REFERENCES advertisement (advertisement_id)
;

---------------------------------------------------------------
-- Заполнение таблиц данными
---------------------------------------------------------------

INSERT INTO advertiser(advertiser_id, full_name, address, phone, email)
VALUES (1, 'Saint Petersburg State University', 'Saint Petersburg, Universitetskaya nab., 7/9', ' +78123282000',
        'spbu@spbu.ru'),
       (2, 'AliExpress', 'Moscow, Presnenskaya nab., 10', ' +78123246070', 'partner@aliexpress.com'),
       (3, 'Apple', 'Moscow, Romanov per., 4', ' +78003335173', 'advertisement@apple.com')
;


INSERT INTO advertisement_type(advertisement_type_id, type)
VALUES (1, 'TV'),
       (2, 'Email'),
       (3, 'Internet'),
       (4, 'Billboard'),
       (5, 'Paper'),
       (6, 'Radio'),
       (7, 'Event')
;


INSERT INTO advertisement(advertisement_id, advertisement_type_id)
VALUES (1, 7),
       (2, 3),
       (3, 1),
       (4, 6),
       (5, 5)
;


INSERT INTO advertisement_data(advertisement_data_id, advertisement_id, heading, content)
VALUES (1, 1, 'New MacBook Pro is coming!', 'https://www.apple.com/ru/apple-events/october-2021/?useASL=true'),
       (2, 2, 'New Air Pods is coming!', 'https://www.apple.com/ru/apple-events/october-2021/?useASL=true'),
       (3, 3, 'New AliExpress sales.', DEFAULT),
       (4, 4, 'Annual Open House Day.', 'https://spbu.ru/news-events/calendar/den-abiturienta-5'),
       (5, 5, 'Student exchange program starts.', 'https://edu.spbu.ru/obuchenie-za-rubezhom-po-programmam-obmena.html')
;


INSERT INTO advertisement_review(advertisement_review_id, advertisement_id, acceptance, age_limit, document)
VALUES (1, 1, TRUE, 3, '#1337:Accepted'),
       (2, 2, TRUE, 3, '#1338:Accepted'),
       (3, 3, FALSE, DEFAULT, '#228:Disclaimer due to suspicious goods'),
       (4, 4, TRUE, 16, '#1901:Accepted'),
       (5, 5, TRUE, 18, '#3001:Accepted with restrictions')
;


INSERT INTO contract(contract_id, advertiser_id, advertisement_id, contract_date, placement_date, expiration_date,
                     is_active)
VALUES (1, 1, 4, DATE '2021-11-06', DATE '2022-01-10', DATE '2022-11-11', TRUE),
       (2, 1, 5, DATE '2020-08-13', DATE '2020-08-15', DATE '2021-08-13', FALSE),
       (3, 2, 3, DEFAULT, DEFAULT, DATE '2022-09-03', TRUE),
       (4, 3, 1, DATE '2021-12-01', DATE '2022-01-19', DATE '2023-01-01', TRUE),
       (5, 3, 2, DEFAULT, CURRENT_DATE + 10, CURRENT_DATE + 180, TRUE)
;


INSERT INTO mass_media(mass_media_id, advertisement_type_id, full_name)
VALUES (1, 1, 'VGTRK'),
       (2, 6, 'VGTRK'),
       (3, 7, 'VGTRK'),
       (4, 1, 'Match TV'),
       (5, 7, 'UFC'),
       (6, 2, 'Yandex'),
       (7, 3, 'Yandex'),
       (8, 3, 'Google'),
       (9, 6, 'Studio 21'),
       (10, 4, 'Expert'),
       (11, 5, 'Expert'),
       (12, 4, 'Red Square'),
       (13, 1, 'Mega'),
       (14, 4, 'Mega'),
       (15, 5, 'Mega'),
       (16, 6, 'Mega'),
       (17, 7, 'Mega')
;


INSERT INTO advertisement_mass_media(advertisement_id, mass_media_id)
VALUES (1, 5),
       (2, 8),
       (3, 1),
       (4, 9),
       (5, 15)
;


INSERT INTO report(report_id, advertiser_id, advertisement_id, message)
VALUES (1, 1, 4, 'Your advertisement has been successfully reviewed.'),
       (2, 1, 5, 'The advertisement placement period has expired. Thank you for choosing us.'),
       (3, 2, 3, 'Sorry, your advertisement has not been reviewed. It is necessary to remove suspicious goods.'),
       (4, 3, 1, 'We are almost done processing your advertisement. Do you want to publish your ad earlier?'),
       (5, 3, 2, 'We are starting to process your advertisement. Thank you for choosing us!')
;

---------------------------------------------------------------
-- Создание индексов
---------------------------------------------------------------

CREATE INDEX index_advertisement on advertisement (advertisement_id, advertisement_type_id)
;
CREATE INDEX index_contract on contract (advertiser_id, advertisement_id)
;
CREATE INDEX index_advertisement_mass_media on advertisement_mass_media (advertisement_id, mass_media_id)
;

---------------------------------------------------------------
-- Создание хранимых функций и процедур с примерами их вызовов
---------------------------------------------------------------

-- Добавление нового клиента (размещающего рекламу)
CREATE FUNCTION add_advertiser(
    new_full_name VARCHAR(64),
    new_address VARCHAR(64),
    new_phone VARCHAR(64),
    new_email VARCHAR(64))
    RETURNS INTEGER
AS
$$
DECLARE
    new_advertiser_id INTEGER;
BEGIN
    SELECT MAX(advertiser_id) + 1 INTO new_advertiser_id FROM advertiser;
    INSERT INTO advertiser(advertiser_id, full_name, address, phone, email)
    VALUES (new_advertiser_id, new_full_name, new_address, new_phone, new_email);
    RETURN new_advertiser_id;
END;
$$
    LANGUAGE plpgsql
;
-- Тест
-- SELECT add_advertiser(
--                'Lanit Terkom',
--                'Saint Petersburg, 16th line V.O., 7',
--                '+78129222091',
--                'contact@lanit-tercom.com')
-- ;
-- SELECT *
-- FROM advertiser
-- WHERE full_name = 'Lanit Terkom'
-- ;


-- Добавление нового типа рекламы
CREATE PROCEDURE add_advertisement_type(
    new_type VARCHAR(64))
AS
$$
DECLARE
    new_advertisement_type_id INTEGER;
BEGIN
    SELECT MAX(advertisement_type_id) + 1 INTO new_advertisement_type_id FROM advertisement_type;
    INSERT INTO advertisement_type(advertisement_type_id, type)
    VALUES (new_advertisement_type_id, new_type);
END;
$$
    LANGUAGE plpgsql
;
-- Тест
-- CALL add_advertisement_type('Live')
-- ;
-- SELECT *
-- FROM advertisement_type
-- WHERE type = 'Live'
-- ;


-- Добавление данных рекламы
CREATE PROCEDURE add_advertisement_data(
    foreign_advertisement_id INTEGER,
    new_heading VARCHAR(64),
    new_content VARCHAR)
AS
$$
DECLARE
    new_advertisement_data_id INTEGER;
BEGIN
    SELECT MAX(advertisement_data_id) + 1 INTO new_advertisement_data_id FROM advertisement_data;
    INSERT INTO advertisement_data(advertisement_data_id, advertisement_id, heading, content)
    VALUES (new_advertisement_data_id, foreign_advertisement_id, new_heading, new_content);
END;
$$
    LANGUAGE plpgsql
;

-- Добавление рекламы
CREATE FUNCTION add_advertisement(
    foreign_advertisement_type_id INTEGER,
    new_heading VARCHAR(64),
    new_content VARCHAR)
    RETURNS INTEGER
AS
$$
DECLARE
    new_advertisement_id INTEGER;
BEGIN
    SELECT MAX(advertisement_id) + 1 INTO new_advertisement_id FROM advertisement;
    INSERT INTO advertisement(advertisement_id, advertisement_type_id)
    VALUES (new_advertisement_id, foreign_advertisement_type_id);
    CALL add_advertisement_data(new_advertisement_id, new_heading, new_content);
    RETURN new_advertisement_id;
END;
$$
    LANGUAGE plpgsql
;
-- Тест
-- SELECT add_advertisement(
--                '8',
--                'New guest in the studio.',
--                'https://www.1tv.ru/shows/vecherniy-urgant/gosti/aleksandr-revva-vecherniy-urgant-fragment-vypuska-ot-03-12-2021')
-- ;
-- SELECT heading, content
-- FROM advertisement
--          JOIN advertisement_data ON advertisement.advertisement_id = advertisement_data.advertisement_id
-- WHERE advertisement_type_id = 8
-- ;


-- Выбрать все СМИ по типу
CREATE FUNCTION get_mass_media_by_type(
    by_type VARCHAR(64))
    RETURNS TABLE
            (
                m_media_id   INTEGER,
                m_media_type VARCHAR(64),
                m_media_name VARCHAR(64)
            )
AS
$$
BEGIN
    RETURN QUERY SELECT mass_media_id::INTEGER, type::VARCHAR, full_name::VARCHAR
                 FROM mass_media
                          JOIN advertisement_type
                               ON mass_media.advertisement_type_id = advertisement_type.advertisement_type_id
                 WHERE type = by_type;
END;
$$
    LANGUAGE plpgsql
;
-- Тест
-- SELECT *
-- FROM get_mass_media_by_type('Paper')
-- ;


-- Добавить ревью к рекламе
CREATE PROCEDURE add_advertisement_review(
    foreign_advertisement_id INTEGER,
    new_acceptance BOOLEAN,
    new_age_limit INTEGER,
    new_document VARCHAR)
AS
$$
DECLARE
    new_review_id INTEGER;
BEGIN
    SELECT MAX(advertisement_review_id) + 1 INTO new_review_id FROM advertisement_review;
    INSERT INTO advertisement_review(advertisement_review_id, advertisement_id, acceptance, age_limit, document)
    VALUES (new_review_id, foreign_advertisement_id, new_acceptance, new_age_limit, new_document);
END;
$$
    LANGUAGE plpgsql
;
-- Тест
-- CALL add_advertisement_review(6, TRUE, 16, '#834:Several notes and edits')
-- ;
-- SELECT *
-- FROM advertisement_review
-- WHERE advertisement_id = 6
-- ;

---------------------------------------------------------------
-- Создание хранимых треггеров с примерами их работы
---------------------------------------------------------------

-- Проверка соответствий типов рекламы и обслуживающей СМИ
CREATE FUNCTION check_advertisement_mass_media_types()
    RETURNS TRIGGER
AS
$$
BEGIN
    IF (SELECT advertisement_type_id FROM advertisement WHERE advertisement_id = new.advertisement_id) !=
       (SELECT advertisement_type_id FROM mass_media WHERE mass_media_id = new.mass_media_id) THEN
        RAISE EXCEPTION 'Inconsistency between types of advertisement and mass media.';
    END IF;
    RETURN new;
END;
$$
    LANGUAGE plpgsql
;

-- Триггер для проверки соответствий типов рекламы и обслуживающей СМИ
-- при вставке или обновлении таблицы
CREATE TRIGGER advertisement_mass_media_types_trigger
    BEFORE INSERT OR UPDATE
    ON advertisement_mass_media
    FOR EACH ROW
EXECUTE PROCEDURE check_advertisement_mass_media_types()
;
-- Тест
-- INSERT INTO advertisement_mass_media
-- VALUES (6, 13)
-- ;
-- INSERT INTO advertisement_mass_media
-- VALUES (5, 11)
-- ;
-- SELECT *
-- FROM advertisement_mass_media
-- WHERE mass_media_id = 11
-- ;


-- Отмена при попытке удалить контракты
-- для безопасности
CREATE FUNCTION contract_deletion_canceling()
    RETURNS TRIGGER
AS
$$
BEGIN
    RAISE EXCEPTION 'It is prohibited to delete contracts.';
    RETURN NULL;
END;
$$
    LANGUAGE plpgsql
;

-- Триггер для отмены при попытке удалить контракты
-- для безопасности
CREATE TRIGGER contract_deletion_trigger
    BEFORE DELETE
    ON contract
    FOR EACH STATEMENT
EXECUTE PROCEDURE contract_deletion_canceling()
;
-- Тест
-- DELETE
-- FROM contract
-- WHERE contract_id = 2
-- ;


-- Отправка произвольного оповещения с информацией клиенту в триггере
CREATE FUNCTION generate_report()
    RETURNS TRIGGER
AS
$$
DECLARE
    new_report_id INTEGER;
BEGIN
    SELECT MAX(report_id) + 1 INTO new_report_id FROM report;
    INSERT INTO report(report_id, advertiser_id, advertisement_id, message)
    VALUES (new_report_id, new.advertiser_id, new.advertisement_id,
            tg_argv[0]);
    RETURN new;
END;
$$
    LANGUAGE plpgsql
;

-- Триггер для отправки оповещения клиенту при
-- подписании контракта
CREATE TRIGGER contract_sign_report_trigger
    AFTER INSERT
    ON contract
    FOR EACH ROW
EXECUTE PROCEDURE generate_report(
        'Thank you for choosing us! Your advertisement is already being processed. We will inform you when it is ready for placement, but no later than.')
;
-- Тест
-- INSERT INTO contract(contract_id, advertiser_id, advertisement_id)
-- VALUES (6, 3, 2)
-- ;
-- SELECT *
-- FROM report
-- WHERE advertisement_id = 2
-- ;

---------------------------------------------------------------
-- Создание хранимых представлений
---------------------------------------------------------------

-- Активные контракты
CREATE VIEW active_contracts
            (contract_id, advertiser_id, advertisement_id, contract_date, placement_date, expiration_date)
AS
SELECT contract_id, advertiser_id, advertisement_id, contract_date, placement_date, expiration_date
FROM contract
WHERE is_active = TRUE
;
-- Тест
-- SELECT *
-- FROM active_contracts
-- ;


-- Реклама для несовершеннолетних
CREATE VIEW underage_advertisement
            (advertisement_id,
             age_limit,
             type,
             heading,
             content)
AS
SELECT part.advertisement_id,
       age_limit,
       type,
       heading,
       content
FROM (SELECT advertisement.advertisement_id,
             advertisement_type_id,
             age_limit
      FROM advertisement
               JOIN advertisement_review ON advertisement.advertisement_id = advertisement_review.advertisement_id
      WHERE age_limit < 18) AS part
         JOIN advertisement_type ON part.advertisement_type_id = advertisement_type.advertisement_type_id
         JOIN advertisement_data ON part.advertisement_id = advertisement_data.advertisement_id
;
-- Тест
-- SELECT *
-- FROM underage_advertisement
-- ;


-- СМИ, контракт с которыми сейчас активен
CREATE VIEW active_mass_media
AS
SELECT part.mass_media_id,
       full_name,
       type,
       advertisement_id
FROM (SELECT mass_media_id, active_contracts.advertisement_id
      FROM active_contracts
               JOIN advertisement_mass_media
                    ON active_contracts.advertisement_id = advertisement_mass_media.advertisement_id) AS part
         JOIN mass_media ON part.mass_media_id = mass_media.mass_media_id
         JOIN advertisement_type ON mass_media.advertisement_type_id = advertisement_type.advertisement_type_id
;
-- Тест
-- SELECT *
-- FROM active_mass_media
-- ;

---------------------------------------------------------------
-- Возможные запросы
---------------------------------------------------------------

-- Компании, заказавшие рекламу более чем на 300 дней,
-- и фактический срок их заказов
SELECT expiration_date - active_contracts.placement_date, full_name, address, phone, email
FROM active_contracts
         JOIN advertiser ON active_contracts.advertiser_id = advertiser.advertiser_id
WHERE expiration_date - active_contracts.placement_date >= 300
ORDER BY expiration_date - active_contracts.placement_date
;


-- Активные рекламы, подходящие несовершеннолетним, и контракты по ним
SELECT heading, content, contract_date, placement_date, expiration_date
FROM advertisement
         JOIN
     underage_advertisement
     ON advertisement.advertisement_id = underage_advertisement.advertisement_id
         JOIN contract ON underage_advertisement.advertisement_id = contract.advertisement_id
WHERE contract.contract_id IN (SELECT active_contracts.contract_id FROM active_contracts)
;


-- Активные СМИ рекламирующие AliExpress
SELECT full_name, type
FROM active_mass_media
WHERE advertisement_id = (SELECT advertisement_id
                          FROM contract
                          WHERE contract.advertiser_id =
                                (SELECT advertiser_id FROM advertiser WHERE full_name = 'AliExpress'))
;


-- Кто выполнял контракты, которые уже неактивны
SELECT full_name
FROM (SELECT advertisement_id
      FROM contract
      EXCEPT
      (SELECT advertisement_id FROM active_contracts)) AS inactive_contracts
         JOIN advertisement_mass_media
              ON inactive_contracts.advertisement_id = advertisement_mass_media.advertisement_id
         JOIN mass_media ON advertisement_mass_media.mass_media_id = mass_media.mass_media_id
;


-- Данные рекламы в Интернете и связанные контракты
SELECT heading, content, contract_date, placement_date, expiration_date, is_active
FROM contract
         JOIN advertisement ON contract.advertisement_id = advertisement.advertisement_id
         JOIN advertisement_data ON advertisement_data.advertisement_id = advertisement.advertisement_id
WHERE advertisement_type_id =
      (SELECT advertisement_type_id FROM advertisement_type WHERE advertisement_type.type = 'Internet')
;


-- Тексты оповещений, отправленные в Apple
SELECT full_name, message
FROM report
         LEFT JOIN advertiser ON advertiser.advertiser_id = report.advertiser_id
WHERE advertiser.full_name = 'Apple'
;


-- Все данные рекламы, не прошедшей рецензирование
SELECT heading, document, age_limit, content
FROM advertisement_data
         JOIN advertisement_review ON advertisement_data.advertisement_id = advertisement_review.advertisement_id
WHERE NOT acceptance
;


-- Рекламы для радио или в текстовом виде
SELECT heading, content
FROM advertisement
         JOIN advertisement_data ON advertisement.advertisement_id = advertisement_data.advertisement_data_id
WHERE advertisement.advertisement_type_id =
      (SELECT advertisement_type_id FROM advertisement_type WHERE advertisement_type.type = 'Radio')
UNION
SELECT heading, content
FROM advertisement
         JOIN advertisement_data ON advertisement.advertisement_id = advertisement_data.advertisement_data_id
WHERE advertisement.advertisement_type_id =
      (SELECT advertisement_type_id FROM advertisement_type WHERE advertisement_type.type = 'Paper')
;


-- Данные заказчиков в порядке сроков окончания рекламы
SELECT full_name, address, phone, email
FROM advertiser
         JOIN contract ON contract.advertiser_id = advertiser.advertiser_id
ORDER BY expiration_date
;


-- Сгруппировать рекламы по возрастному ограничению
-- и найти группы, где их не менее двух
SELECT age_limit, COUNT(*)
FROM advertisement
         JOIN advertisement_data ON advertisement.advertisement_id = advertisement_data.advertisement_data_id
         JOIN advertisement_review ON advertisement.advertisement_id = advertisement_review.advertisement_id
GROUP BY age_limit
HAVING COUNT(*) >= 2
ORDER BY age_limit
;


-- Среднее число дней от заключения контракта до размещения рекламы
SELECT ROUND(AVG(placement_date - contract.contract_date))
FROM contract
;

-- Названия компаний из СПб (по телефону),
-- длительность и активность их контрактов
SELECT expiration_date - contract.contract_date, full_name, is_active
FROM contract
         JOIN advertiser on contract.advertiser_id = advertiser.advertiser_id
WHERE phone LIKE '%+7812%'
ORDER BY expiration_date - contract.contract_date
;

---------------------------------------------------------------
-- Удаление хранимых представлений (при необходимости)
---------------------------------------------------------------

-- DROP VIEW active_mass_media
-- ;
-- DROP VIEW underage_advertisement
-- ;
-- DROP VIEW active_contracts
-- ;

---------------------------------------------------------------
-- Удаление хранимых функций и процедур (при необходимости)
---------------------------------------------------------------

-- DROP PROCEDURE add_advertisement_review
-- ;
-- DROP FUNCTION get_mass_media_by_type
-- ;
-- DROP FUNCTION add_advertisement
-- ;
-- DROP PROCEDURE add_advertisement_data
-- ;
-- DROP PROCEDURE add_advertisement_type
-- ;
-- DROP FUNCTION add_advertiser
-- ;

---------------------------------------------------------------
-- Удаление хранимых триггеров и связанных обработчиков
-- (при необходимости)
---------------------------------------------------------------

-- DROP TRIGGER contract_sign_report_trigger ON contract
-- ;
-- DROP FUNCTION generate_report()
-- ;
--
-- DROP TRIGGER contract_deletion_trigger ON contract
-- ;
-- DROP FUNCTION contract_deletion_canceling()
-- ;
--
-- DROP TRIGGER advertisement_mass_media_types_trigger ON advertisement_mass_media
-- ;
-- DROP FUNCTION check_advertisement_mass_media_types()
-- ;

---------------------------------------------------------------
-- Удаление индексов (при необходимости)
---------------------------------------------------------------

-- DROP INDEX index_advertisement
-- ;
-- DROP INDEX index_contract
-- ;
-- DROP INDEX index_advertisement_mass_media
-- ;

---------------------------------------------------------------
-- Удаление таблиц и базы данных (при необходимости)
---------------------------------------------------------------

-- DROP TABLE advertisement_data
-- ;
-- DROP TABLE advertisement_review
-- ;
-- DROP TABLE advertisement_mass_media
-- ;
-- DROP TABLE mass_media
-- ;
-- DROP TABLE report
-- ;
-- DROP TABLE contract
-- ;
-- DROP TABLE advertiser
-- ;
-- DROP TABLE advertisement
-- ;
-- DROP TABLE advertisement_type
-- ;

---------------------------------------------------------------
-- Удаление базы данных (при необходимости)
---------------------------------------------------------------

-- DROP DATABASE advertisement_db
-- ;

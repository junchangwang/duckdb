CREATE TABLE "YaleLanguages_1"(
  "BEGIN_PUB_DATE" varchar(4),
  "BIB_FORMAT" varchar(2) NOT NULL,
  "BIB_ID" integer NOT NULL,
  "CALL_NO_TYPE" varchar(1),
  "CHARGE_DATE" timestamp NOT NULL,
  "CLASS_BROAD" varchar(51),
  "CLASS_GROUP" varchar(15),
  "CLASS_LETTER" varchar(3),
  "CLASS_NARROW" varchar(99),
  "DATE" varchar(4),
  "DATE_RANGE_CENTURY" varchar(9),
  "DATE_RANGE_DECADE" varchar(9),
  "DISCHARGE_DATE" timestamp,
  "ID" smallint,
  "ID1" smallint,
  "LANGUAGE" varchar(3) NOT NULL,
  "LC_BROAD" varchar(1),
  "LC_NARROW" varchar(3),
  "MFHD_ID" integer NOT NULL,
  "Number of Records" smallint NOT NULL,
  "PATRON_GROUP_CODE" varchar(9),
  "PATRON_GROUP_DISPLAY" varchar(35),
  "PATRON_GROUP_ID" smallint,
  "PATRON_GROUP_ID1" smallint NOT NULL,
  "PATRON_GROUP_NAME" varchar(23),
  "PATRON_TYPE (Pseudo vs Patron)" varchar(12),
  "PLACE_CODE" varchar(3),
  "Patron Group" varchar(16),
  "RENEWAL_COUNT" smallint NOT NULL,
  "Calculation_1810108111146429" varchar(51) NOT NULL
);

CREATE TABLE "YaleLanguages_2"(
  "BEGIN_PUB_DATE" varchar(4),
  "BIB_FORMAT" varchar(2) NOT NULL,
  "BIB_ID" integer NOT NULL,
  "CALL_NO_TYPE" varchar(1),
  "CHARGE_DATE" timestamp NOT NULL,
  "CLASS_BROAD" varchar(51),
  "CLASS_GROUP" varchar(15),
  "CLASS_LETTER" varchar(3),
  "CLASS_NARROW" varchar(99),
  "DATE" varchar(4),
  "DATE_RANGE_CENTURY" varchar(9),
  "DATE_RANGE_DECADE" varchar(9),
  "DISCHARGE_DATE" timestamp,
  "ID" smallint,
  "ID1" smallint,
  "LANGUAGE" varchar(3) NOT NULL,
  "LC_BROAD" varchar(1),
  "LC_NARROW" varchar(3),
  "MFHD_ID" integer NOT NULL,
  "Number of Records" smallint NOT NULL,
  "PATRON_GROUP_CODE" varchar(9),
  "PATRON_GROUP_DISPLAY" varchar(35),
  "PATRON_GROUP_ID" smallint,
  "PATRON_GROUP_ID1" smallint NOT NULL,
  "PATRON_GROUP_NAME" varchar(23),
  "PATRON_TYPE (Pseudo vs Patron)" varchar(12),
  "PLACE_CODE" varchar(3),
  "Patron Group" varchar(16),
  "RENEWAL_COUNT" smallint NOT NULL,
  "Calculation_1810108111146429" varchar(51) NOT NULL
);

CREATE TABLE "YaleLanguages_4"(
  "BEGIN_PUB_DATE" varchar(4),
  "BIB_FORMAT" varchar(2) NOT NULL,
  "BIB_ID" integer NOT NULL,
  "CALL_NO_TYPE" varchar(1),
  "CHARGE_DATE" timestamp NOT NULL,
  "CLASS_BROAD" varchar(51),
  "CLASS_GROUP" varchar(15),
  "CLASS_LETTER" varchar(3),
  "CLASS_NARROW" varchar(106),
  "DATE" varchar(4),
  "DATE_RANGE_CENTURY" varchar(9),
  "DATE_RANGE_DECADE" varchar(9),
  "DISCHARGE_DATE" timestamp,
  "ID" smallint,
  "ID1" smallint,
  "LANGUAGE" varchar(3) NOT NULL,
  "LC_BROAD" varchar(1),
  "LC_NARROW" varchar(3),
  "MFHD_ID" integer NOT NULL,
  "Number of Records" smallint NOT NULL,
  "PATRON_GROUP_CODE" varchar(9),
  "PATRON_GROUP_DISPLAY" varchar(23),
  "PATRON_GROUP_ID" smallint,
  "PATRON_GROUP_ID1" smallint NOT NULL,
  "PATRON_GROUP_NAME" varchar(23),
  "PATRON_TYPE (Pseudo vs Patron)" varchar(12),
  "PLACE_CODE" varchar(3),
  "Patron Group" varchar(16),
  "RENEWAL_COUNT" smallint NOT NULL,
  "Calculation_6550106154858816" varchar(51) NOT NULL
);

CREATE TABLE "YaleLanguages_3"(
  "BEGIN_PUB_DATE" varchar(4),
  "BIB_FORMAT" varchar(2) NOT NULL,
  "BIB_ID" integer NOT NULL,
  "CALL_NO_TYPE" varchar(1),
  "CHARGE_DATE" timestamp NOT NULL,
  "CLASS_BROAD" varchar(51),
  "CLASS_GROUP" varchar(15),
  "CLASS_LETTER" varchar(3),
  "CLASS_NARROW" varchar(106),
  "DATE" varchar(4),
  "DATE_RANGE_CENTURY" varchar(9),
  "DATE_RANGE_DECADE" varchar(9),
  "DISCHARGE_DATE" timestamp,
  "ID" smallint,
  "ID1" smallint,
  "LANGUAGE" varchar(3) NOT NULL,
  "LC_BROAD" varchar(1),
  "LC_NARROW" varchar(3),
  "MFHD_ID" integer NOT NULL,
  "Number of Records" smallint NOT NULL,
  "PATRON_GROUP_CODE" varchar(9),
  "PATRON_GROUP_DISPLAY" varchar(35),
  "PATRON_GROUP_ID" smallint,
  "PATRON_GROUP_ID1" smallint NOT NULL,
  "PATRON_GROUP_NAME" varchar(23),
  "PATRON_TYPE (Pseudo vs Patron)" varchar(12),
  "PLACE_CODE" varchar(3),
  "Patron Group" varchar(16),
  "RENEWAL_COUNT" smallint NOT NULL,
  "Calculation_3110108110633423" varchar(51) NOT NULL
);

CREATE TABLE "YaleLanguages_5"(
  "BEGIN_PUB_DATE" varchar(4),
  "BIB_FORMAT" varchar(2) NOT NULL,
  "BIB_ID" integer NOT NULL,
  "CALL_NO_TYPE" varchar(1),
  "CHARGE_DATE" timestamp NOT NULL,
  "CLASS_BROAD" varchar(51),
  "CLASS_GROUP" varchar(15),
  "CLASS_LETTER" varchar(3),
  "CLASS_NARROW" varchar(106),
  "DATE" varchar(4),
  "DATE_RANGE_CENTURY" varchar(9),
  "DATE_RANGE_DECADE" varchar(9),
  "DISCHARGE_DATE" timestamp,
  "ID" smallint,
  "ID1" smallint,
  "LANGUAGE" varchar(3) NOT NULL,
  "LC_BROAD" varchar(1),
  "LC_NARROW" varchar(3),
  "MFHD_ID" integer NOT NULL,
  "Number of Records" smallint NOT NULL,
  "PATRON_GROUP_CODE" varchar(9),
  "PATRON_GROUP_DISPLAY" varchar(23),
  "PATRON_GROUP_ID" smallint,
  "PATRON_GROUP_ID1" smallint NOT NULL,
  "PATRON_GROUP_NAME" varchar(23),
  "PATRON_TYPE (Pseudo vs Patron)" varchar(12),
  "PLACE_CODE" varchar(3),
  "Patron Group" varchar(16),
  "RENEWAL_COUNT" smallint NOT NULL,
  "Calculation_6550106154858816" varchar(51) NOT NULL
);


COPY YaleLanguages_1 FROM 'benchmark/publicbi/YaleLanguages_1.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY YaleLanguages_2 FROM 'benchmark/publicbi/YaleLanguages_2.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY YaleLanguages_4 FROM 'benchmark/publicbi/YaleLanguages_4.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY YaleLanguages_3 FROM 'benchmark/publicbi/YaleLanguages_3.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY YaleLanguages_5 FROM 'benchmark/publicbi/YaleLanguages_5.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
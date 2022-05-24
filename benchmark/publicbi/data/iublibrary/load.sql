CREATE TABLE "IUBLibrary_1"(
  "Author" varchar(117),
  "CallNumber" varchar(32) NOT NULL,
  "CallSequence" smallint NOT NULL,
  "CatalogKey" integer NOT NULL,
  "ClasscodeLCSUDOCNLM" varchar(2) NOT NULL,
  "CopyNumber" smallint NOT NULL,
  "DateLastCharged" date NOT NULL,
  "DateofPublication260c" varchar(17),
  "Format" varchar(6) NOT NULL,
  "Inactive" varchar(8),
  "ItemCreatedDate" date NOT NULL,
  "ItemType" varchar(6) NOT NULL,
  "Language" varchar(3),
  "LastActivityDate" date NOT NULL,
  "Library" varchar(7) NOT NULL,
  "MARCkey" integer NOT NULL,
  "OCLC" integer,
  "PubYear" smallint NOT NULL,
  "Sh" varchar(2) NOT NULL,
  "TitleControlNumber" varchar(9) NOT NULL,
  "TitleCreatedDate" date NOT NULL,
  "Title" varchar(118),
  "TotalCharges" smallint NOT NULL,
  "Type" varchar(1) NOT NULL,
  "elvingKey" varchar(53) NOT NULL,
  "Inactive (group)" varchar(8) NOT NULL,
  "Calculation_649925789325832192" varchar(1) NOT NULL
);


COPY IUBLibrary_1 FROM 'benchmark/publicbi/IUBLibrary_1.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
CREATE TABLE "IGlocations2_2"(
  "Number of Records" smallint,
  "caption" varchar(3688) NOT NULL,
  "city" varchar(35) NOT NULL,
  "country" varchar(2) NOT NULL,
  "created_time" timestamp NOT NULL,
  "id" integer NOT NULL,
  "latitude" decimal(10, 8) NOT NULL,
  "like_count" integer NOT NULL,
  "link" varchar(35) NOT NULL,
  "longitude" decimal(11, 8) NOT NULL,
  "media_type" varchar(5) NOT NULL,
  "media_url" varchar(153) NOT NULL,
  "State (copy)" varchar(16) NOT NULL,
  "state" varchar(16) NOT NULL,
  "username" varchar(30) NOT NULL,
  "Calculation_1750724145742463" decimal(5, 2) NOT NULL,
  "Calculation_3650724144057954" varchar(8) NOT NULL,
  "Calculation_4370724142342227" varchar(5),
  "Calculation_8090724143600502" varchar(5) NOT NULL,
  "Calculation_9330724145728972" decimal(4, 2) NOT NULL
);

CREATE TABLE "IGlocations2_1"(
  "Number of Records" smallint,
  "caption" varchar(3688) NOT NULL,
  "city" varchar(35) NOT NULL,
  "country" varchar(2) NOT NULL,
  "created_time" timestamp NOT NULL,
  "id" integer NOT NULL,
  "latitude" decimal(10, 8) NOT NULL,
  "like_count" integer NOT NULL,
  "link" varchar(35) NOT NULL,
  "longitude" decimal(11, 8) NOT NULL,
  "media_type" varchar(5) NOT NULL,
  "media_url" varchar(153) NOT NULL,
  "State (copy)" varchar(16) NOT NULL,
  "state" varchar(16) NOT NULL,
  "username" varchar(30) NOT NULL,
  "Calculation_1750724145742463" decimal(5, 2) NOT NULL,
  "Calculation_3650724144057954" varchar(8) NOT NULL,
  "Calculation_4370724142342227" varchar(5),
  "Calculation_8090724143600502" varchar(5) NOT NULL,
  "Calculation_9330724145728972" decimal(4, 2) NOT NULL
);


COPY IGlocations2_2 FROM 'benchmark/publicbi/IGlocations2_2.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY IGlocations2_1 FROM 'benchmark/publicbi/IGlocations2_1.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
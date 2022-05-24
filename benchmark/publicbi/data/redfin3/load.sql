CREATE TABLE "Redfin3_1"(
  "Number of Records" smallint NOT NULL,
  "avg_sale_to_list" decimal(16, 15),
  "avg_sale_to_list_mom" double,
  "avg_sale_to_list_yoy" double,
  "city" varchar(31),
  "homes_sold" integer,
  "homes_sold_mom" double,
  "homes_sold_yoy" double,
  "inventory" integer,
  "inventory_mom" double,
  "inventory_yoy" double,
  "median_dom" decimal(5, 1),
  "median_dom_mom" decimal(5, 1),
  "median_dom_yoy" decimal(5, 1),
  "median_list_ppsf" double,
  "median_list_ppsf_mom" double,
  "median_list_ppsf_yoy" double,
  "median_list_price" double,
  "median_list_price_mom" double,
  "median_list_price_yoy" double,
  "median_ppsf" double,
  "median_ppsf_mom" double,
  "median_ppsf_yoy" double,
  "median_sale_price" double,
  "median_sale_price_mom" double,
  "median_sale_price_yoy" double,
  "months_of_supply" decimal(5, 1),
  "months_of_supply_mom" double,
  "months_of_supply_yoy" double,
  "new_listings" integer,
  "new_listings_mom" double,
  "new_listings_yoy" double,
  "period_begin" date NOT NULL,
  "period_duration" smallint NOT NULL,
  "period_end" date NOT NULL,
  "price_drops" double,
  "price_drops_mom" double,
  "price_drops_yoy" double,
  "property_type" varchar(25) NOT NULL,
  "region" varchar(75) NOT NULL,
  "region_type" varchar(12) NOT NULL,
  "sold_above_list" double,
  "sold_above_list_mom" double,
  "sold_above_list_yoy" double,
  "state" varchar(14),
  "state_code" varchar(2),
  "table_id" integer
);

CREATE TABLE "Redfin3_2"(
  "Number of Records" smallint NOT NULL,
  "avg_sale_to_list" decimal(16, 15),
  "avg_sale_to_list_mom" double,
  "avg_sale_to_list_yoy" double,
  "city" varchar(31),
  "homes_sold" integer,
  "homes_sold_mom" double,
  "homes_sold_yoy" double,
  "inventory" integer,
  "inventory_mom" double,
  "inventory_yoy" double,
  "median_dom" decimal(5, 1),
  "median_dom_mom" decimal(5, 1),
  "median_dom_yoy" decimal(5, 1),
  "median_list_ppsf" double,
  "median_list_ppsf_mom" double,
  "median_list_ppsf_yoy" double,
  "median_list_price" double,
  "median_list_price_mom" double,
  "median_list_price_yoy" double,
  "median_ppsf" double,
  "median_ppsf_mom" double,
  "median_ppsf_yoy" double,
  "median_sale_price" double,
  "median_sale_price_mom" double,
  "median_sale_price_yoy" double,
  "months_of_supply" decimal(5, 1),
  "months_of_supply_mom" double,
  "months_of_supply_yoy" double,
  "new_listings" integer,
  "new_listings_mom" double,
  "new_listings_yoy" double,
  "period_begin" date NOT NULL,
  "period_duration" smallint NOT NULL,
  "period_end" date NOT NULL,
  "price_drops" double,
  "price_drops_mom" double,
  "price_drops_yoy" double,
  "property_type" varchar(25) NOT NULL,
  "region" varchar(75) NOT NULL,
  "region_type" varchar(12) NOT NULL,
  "sold_above_list" double,
  "sold_above_list_mom" double,
  "sold_above_list_yoy" double,
  "state" varchar(14),
  "state_code" varchar(2),
  "table_id" integer
);


COPY Redfin3_1 FROM 'benchmark/publicbi/Redfin3_1.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
COPY Redfin3_2 FROM 'benchmark/publicbi/Redfin3_2.csv.gz' ( DELIMITER '|', NULL 'null', QUOTE '', ESCAPE '\\n' );
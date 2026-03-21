BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "app_config" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_config" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "dataGatheringSince" timestamp without time zone,
    "chargingEnabled" boolean NOT NULL,
    "sellingEnabled" boolean NOT NULL,
    "pvOnlySelling" boolean NOT NULL,
    "topUpRequested" boolean NOT NULL,
    "alwaysChargePriceThreshold" double precision NOT NULL,
    "minSellPriceThreshold" double precision,
    "batteryCapacityKwh" double precision,
    "batteryCost" double precision,
    "batteryLifecycles" bigint,
    "minSocPercentage" double precision,
    "maxDischargeRateKw" double precision,
    "maxChargeRateKw" double precision,
    "gridConnectionKw" double precision,
    "cityName" text,
    "latitude" double precision,
    "longitude" double precision,
    "priceSource" text,
    "fixedBuyRatePln" double precision,
    "fixedSellRatePln" double precision,
    "planningOnly" boolean NOT NULL,
    "pstrykEnabled" boolean NOT NULL,
    "currency" text
);


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260321144958478', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321144958478', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();


COMMIT;

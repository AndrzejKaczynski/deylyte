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
    "maxDischargeRateKw" double precision
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "optimization_frames" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "generatedAt" timestamp without time zone NOT NULL,
    "hour" timestamp without time zone NOT NULL,
    "command" text NOT NULL,
    "targetSocPercent" double precision,
    "reason" text NOT NULL,
    "estimatedSocAtStart" double precision NOT NULL,
    "expectedNetLoadW" double precision NOT NULL,
    "expectedPvW" double precision NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "optimization_frames_user_hour_idx" ON "optimization_frames" USING btree ("userInfoId", "hour");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260320113207024', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260320113207024', "timestamp" = now();

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

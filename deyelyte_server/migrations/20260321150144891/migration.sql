BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_config" ADD COLUMN "baselineChargingEnabled" boolean;
ALTER TABLE "app_config" ADD COLUMN "baselineSellingEnabled" boolean;
ALTER TABLE "app_config" ADD COLUMN "baselineMaxBuyPrice" double precision;
ALTER TABLE "app_config" ADD COLUMN "baselineMinSellPrice" double precision;
ALTER TABLE "app_config" ADD COLUMN "baselinePriceSource" text;

--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260321150144891', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321150144891', "timestamp" = now();

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

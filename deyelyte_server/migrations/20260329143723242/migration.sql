BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "tier_sync_configs" ADD COLUMN "historyMonths" bigint;

--
-- Seed: beta_free and basic get 1 month of history; pro stays null (unlimited)
--
UPDATE "tier_sync_configs" SET "historyMonths" = 1 WHERE "tier" IN ('beta_free', 'basic');

--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260329143723242', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260329143723242', "timestamp" = now();

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

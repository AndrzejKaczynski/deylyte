BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "tier_sync_configs" DROP COLUMN "historyDurationDays";

--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260324161532582', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324161532582', "timestamp" = now();

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

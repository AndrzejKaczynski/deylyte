BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "devices" ADD COLUMN "syncIntervalSeconds" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "tier_sync_configs" (
    "id" bigserial PRIMARY KEY,
    "tier" text NOT NULL,
    "syncIntervalSeconds" bigint NOT NULL,
    "historyDurationDays" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "tier_sync_configs_tier_idx" ON "tier_sync_configs" USING btree ("tier");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260322133253039', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260322133253039', "timestamp" = now();

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

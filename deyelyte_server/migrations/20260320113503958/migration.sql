BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "outage_reserves" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "note" text
);

-- Indexes
CREATE UNIQUE INDEX "outage_reserves_user_date_idx" ON "outage_reserves" USING btree ("userInfoId", "date");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260320113503958', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260320113503958', "timestamp" = now();

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

BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "price_time_range" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "price_time_range" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "hourStart" bigint NOT NULL,
    "hourEnd" bigint NOT NULL,
    "distributionRatePln" double precision NOT NULL,
    "sellRatePln" double precision
);

-- Indexes
CREATE INDEX "price_time_range_user_idx" ON "price_time_range" USING btree ("userInfoId");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260321130251042', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321130251042', "timestamp" = now();

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

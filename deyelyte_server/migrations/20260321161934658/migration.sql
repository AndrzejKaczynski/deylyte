BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "admin_users" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "admin_users_user_idx" ON "admin_users" USING btree ("userInfoId");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260321161934658', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321161934658', "timestamp" = now();

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

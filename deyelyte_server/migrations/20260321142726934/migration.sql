BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_config" ADD COLUMN "currency" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_telemetry" (
    "id" bigserial PRIMARY KEY,
    "deviceId" text NOT NULL,
    "userId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "batterySOC" double precision NOT NULL,
    "gridPowerW" double precision NOT NULL,
    "pvPowerW" double precision NOT NULL,
    "loadPowerW" double precision NOT NULL,
    "batteryPowerW" double precision NOT NULL
);

-- Indexes
CREATE INDEX "device_telemetry_user_time_idx" ON "device_telemetry" USING btree ("userId", "timestamp");
CREATE INDEX "device_telemetry_device_time_idx" ON "device_telemetry" USING btree ("deviceId", "timestamp");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "devices" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hashedSerial" text NOT NULL,
    "licenseKey" text NOT NULL,
    "lastSeenAt" timestamp without time zone,
    "lastInverterOk" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "devices_user_idx" ON "devices" USING btree ("userId");
CREATE UNIQUE INDEX "devices_serial_idx" ON "devices" USING btree ("hashedSerial");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "license_keys" (
    "id" bigserial PRIMARY KEY,
    "licenseKey" text NOT NULL,
    "userId" bigint NOT NULL,
    "tier" text NOT NULL,
    "stripeSubscriptionId" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone,
    "lastSeenAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "license_keys_key_idx" ON "license_keys" USING btree ("licenseKey");
CREATE INDEX "license_keys_user_idx" ON "license_keys" USING btree ("userId");


--
-- MIGRATION VERSION FOR deyelyte
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('deyelyte', '20260321142726934', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321142726934', "timestamp" = now();

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

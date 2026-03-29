BEGIN;

--
-- Class AdminUser as table admin_users
--
CREATE TABLE "admin_users" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "admin_users_user_idx" ON "admin_users" USING btree ("userInfoId");

--
-- Class AppConfig as table app_config
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
    "energyVatRate" double precision,
    "planningOnly" boolean NOT NULL,
    "pstrykEnabled" boolean NOT NULL,
    "currency" text,
    "inverterModelId" text,
    "baselineChargingEnabled" boolean,
    "baselineSellingEnabled" boolean,
    "baselineMaxBuyPrice" double precision,
    "baselineMinSellPrice" double precision,
    "baselinePriceSource" text
);

--
-- Class AuthKeyMetadata as table auth_key_metadata
--
CREATE TABLE "auth_key_metadata" (
    "id" bigserial PRIMARY KEY,
    "keyId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "auth_key_metadata_key_idx" ON "auth_key_metadata" USING btree ("keyId");

--
-- Class DeviceTelemetry as table device_telemetry
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
-- Class Device as table devices
--
CREATE TABLE "devices" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hashedSerial" text NOT NULL,
    "licenseKey" text NOT NULL,
    "lastSeenAt" timestamp without time zone,
    "lastInverterOk" boolean NOT NULL,
    "syncIntervalSeconds" bigint,
    "modelValidationStatus" text,
    "modelValidationAttempts" bigint NOT NULL,
    "lastIngestAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "devices_user_idx" ON "devices" USING btree ("userId");
CREATE UNIQUE INDEX "devices_serial_idx" ON "devices" USING btree ("hashedSerial");

--
-- Class EnergyPrice as table energy_price
--
CREATE TABLE "energy_price" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "buyPrice" double precision NOT NULL,
    "sellPrice" double precision NOT NULL,
    "currency" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "energy_price_user_timestamp_idx" ON "energy_price" USING btree ("userInfoId", "timestamp");

--
-- Class IntegrationCredentials as table integration_credentials
--
CREATE TABLE "integration_credentials" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "deyeUsername" text,
    "deyePasswordHash" text,
    "deyeDeviceSn" text,
    "solcastApiKey" text,
    "solcastSiteId" text,
    "pstrykToken" text
);

--
-- Class InverterData as table inverter_data
--
CREATE TABLE "inverter_data" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "pvPower" double precision NOT NULL,
    "batteryLevel" double precision NOT NULL,
    "gridPower" double precision NOT NULL,
    "loadPower" double precision NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "inverter_data_user_timestamp_idx" ON "inverter_data" USING btree ("userInfoId", "timestamp");

--
-- Class InverterModel as table inverter_models
--
CREATE TABLE "inverter_models" (
    "id" bigserial PRIMARY KEY,
    "modelId" text NOT NULL,
    "displayName" text NOT NULL,
    "registerMapJson" text NOT NULL,
    "measurePointsFingerprintJson" text
);

-- Indexes
CREATE UNIQUE INDEX "inverter_models_model_idx" ON "inverter_models" USING btree ("modelId");

--
-- Class LicenseKey as table license_keys
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
-- Class OptimizationFrame as table optimization_frames
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
-- Class OutageReserve as table outage_reserves
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
-- Class PriceTimeRange as table price_time_range
--
CREATE TABLE "price_time_range" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "hourStart" bigint NOT NULL,
    "hourEnd" bigint NOT NULL,
    "distributionRatePln" double precision NOT NULL
);

-- Indexes
CREATE INDEX "price_time_range_user_idx" ON "price_time_range" USING btree ("userInfoId");

--
-- Class PvForecast as table pv_forecast
--
CREATE TABLE "pv_forecast" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "expectedYieldWatts" double precision NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "pv_forecast_user_timestamp_idx" ON "pv_forecast" USING btree ("userInfoId", "timestamp");

--
-- Class TierSyncConfig as table tier_sync_configs
--
CREATE TABLE "tier_sync_configs" (
    "id" bigserial PRIMARY KEY,
    "tier" text NOT NULL,
    "syncIntervalSeconds" bigint NOT NULL,
    "historyMonths" bigint
);

-- Indexes
CREATE UNIQUE INDEX "tier_sync_configs_tier_idx" ON "tier_sync_configs" USING btree ("tier");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AuthKey as table serverpod_auth_key
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- Class EmailAuth as table serverpod_email_auth
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- Class EmailReset as table serverpod_email_reset
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- Class UserInfo as table serverpod_user_info
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


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

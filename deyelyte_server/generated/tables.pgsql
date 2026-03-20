--
-- Class AppConfig as table app_config
--

CREATE TABLE "app_config" (
  "id" serial,
  "userInfoId" integer NOT NULL,
  "dataGatheringSince" timestamp without time zone,
  "workModeEnabled" boolean NOT NULL,
  "alwaysChargePriceThreshold" double precision NOT NULL,
  "minSellPriceThreshold" double precision,
  "batteryCapacityKwh" double precision,
  "batteryCost" double precision,
  "batteryLifecycles" integer,
  "minSocPercentage" double precision
);

ALTER TABLE ONLY "app_config"
  ADD CONSTRAINT app_config_pkey PRIMARY KEY (id);


--
-- Class EnergyPrice as table energy_price
--

CREATE TABLE "energy_price" (
  "id" serial,
  "userInfoId" integer NOT NULL,
  "timestamp" timestamp without time zone NOT NULL,
  "buyPrice" double precision NOT NULL,
  "sellPrice" double precision NOT NULL,
  "currency" text NOT NULL
);

ALTER TABLE ONLY "energy_price"
  ADD CONSTRAINT energy_price_pkey PRIMARY KEY (id);


--
-- Class IntegrationCredentials as table integration_credentials
--

CREATE TABLE "integration_credentials" (
  "id" serial,
  "userInfoId" integer NOT NULL,
  "deyeUsername" text,
  "deyePasswordHash" text,
  "deyeAppId" text,
  "solcastApiKey" text,
  "solcastSiteId" text,
  "pstrykToken" text
);

ALTER TABLE ONLY "integration_credentials"
  ADD CONSTRAINT integration_credentials_pkey PRIMARY KEY (id);


--
-- Class InverterData as table inverter_data
--

CREATE TABLE "inverter_data" (
  "id" serial,
  "userInfoId" integer NOT NULL,
  "timestamp" timestamp without time zone NOT NULL,
  "pvPower" double precision NOT NULL,
  "batteryLevel" double precision NOT NULL,
  "gridPower" double precision NOT NULL,
  "loadPower" double precision NOT NULL
);

ALTER TABLE ONLY "inverter_data"
  ADD CONSTRAINT inverter_data_pkey PRIMARY KEY (id);


--
-- Class PvForecast as table pv_forecast
--

CREATE TABLE "pv_forecast" (
  "id" serial,
  "userInfoId" integer NOT NULL,
  "timestamp" timestamp without time zone NOT NULL,
  "expectedYieldWatts" double precision NOT NULL
);

ALTER TABLE ONLY "pv_forecast"
  ADD CONSTRAINT pv_forecast_pkey PRIMARY KEY (id);



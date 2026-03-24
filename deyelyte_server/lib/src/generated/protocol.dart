/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'admin_user.dart' as _i4;
import 'app_config.dart' as _i5;
import 'daily_avg_price.dart' as _i6;
import 'daily_energy_aggregate.dart' as _i7;
import 'device.dart' as _i8;
import 'device_telemetry.dart' as _i9;
import 'energy_price.dart' as _i10;
import 'example.dart' as _i11;
import 'history_day_data.dart' as _i12;
import 'history_period_data.dart' as _i13;
import 'integration_credentials.dart' as _i14;
import 'inverter_data.dart' as _i15;
import 'inverter_model.dart' as _i16;
import 'license_key.dart' as _i17;
import 'optimization_frame.dart' as _i18;
import 'outage_reserve.dart' as _i19;
import 'price_time_range.dart' as _i20;
import 'pv_forecast.dart' as _i21;
import 'tier_sync_config.dart' as _i22;
import 'package:deyelyte_server/src/generated/pv_forecast.dart' as _i23;
import 'package:deyelyte_server/src/generated/optimization_frame.dart' as _i24;
import 'package:deyelyte_server/src/generated/outage_reserve.dart' as _i25;
import 'package:deyelyte_server/src/generated/energy_price.dart' as _i26;
import 'package:deyelyte_server/src/generated/price_time_range.dart' as _i27;
import 'package:deyelyte_server/src/generated/device_telemetry.dart' as _i28;
export 'admin_user.dart';
export 'app_config.dart';
export 'daily_avg_price.dart';
export 'daily_energy_aggregate.dart';
export 'device.dart';
export 'device_telemetry.dart';
export 'energy_price.dart';
export 'example.dart';
export 'history_day_data.dart';
export 'history_period_data.dart';
export 'integration_credentials.dart';
export 'inverter_data.dart';
export 'inverter_model.dart';
export 'license_key.dart';
export 'optimization_frame.dart';
export 'outage_reserve.dart';
export 'price_time_range.dart';
export 'pv_forecast.dart';
export 'tier_sync_config.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'admin_users',
      dartName: 'AdminUser',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'admin_users_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'admin_users_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_users_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'app_config',
      dartName: 'AppConfig',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'app_config_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'dataGatheringSince',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'chargingEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'sellingEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'pvOnlySelling',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'topUpRequested',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'alwaysChargePriceThreshold',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'minSellPriceThreshold',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'batteryCapacityKwh',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'batteryCost',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'batteryLifecycles',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'minSocPercentage',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'maxDischargeRateKw',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'maxChargeRateKw',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'gridConnectionKw',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'cityName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'priceSource',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fixedBuyRatePln',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'energyVatRate',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'planningOnly',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'pstrykEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'inverterModelId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'baselineChargingEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'baselineSellingEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'baselineMaxBuyPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'baselineMinSellPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'baselinePriceSource',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'app_config_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'device_telemetry',
      dartName: 'DeviceTelemetry',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'device_telemetry_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'deviceId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'batterySOC',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'gridPowerW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'pvPowerW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'loadPowerW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'batteryPowerW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'device_telemetry_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'device_telemetry_user_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'device_telemetry_device_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'devices',
      dartName: 'Device',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'devices_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'hashedSerial',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'licenseKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastInverterOk',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'syncIntervalSeconds',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'modelValidationStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'modelValidationAttempts',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastIngestAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'devices_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'devices_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'devices_serial_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'hashedSerial',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'energy_price',
      dartName: 'EnergyPrice',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'energy_price_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'buyPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'sellPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'energy_price_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'energy_price_user_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'integration_credentials',
      dartName: 'IntegrationCredentials',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'integration_credentials_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'deyeUsername',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deyePasswordHash',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deyeDeviceSn',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'solcastApiKey',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'solcastSiteId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'pstrykToken',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'integration_credentials_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'inverter_data',
      dartName: 'InverterData',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'inverter_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'pvPower',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'batteryLevel',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'gridPower',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'loadPower',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'inverter_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'inverter_data_user_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'inverter_models',
      dartName: 'InverterModel',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'inverter_models_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'modelId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'displayName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'registerMapJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'measurePointsFingerprintJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'inverter_models_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'inverter_models_model_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'modelId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'license_keys',
      dartName: 'LicenseKey',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'license_keys_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'licenseKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'tier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stripeSubscriptionId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'license_keys_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'license_keys_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'licenseKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'license_keys_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'optimization_frames',
      dartName: 'OptimizationFrame',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'optimization_frames_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'generatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'hour',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'command',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'targetSocPercent',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'estimatedSocAtStart',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'expectedNetLoadW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'expectedPvW',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'optimization_frames_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'optimization_frames_user_hour_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'hour',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'outage_reserves',
      dartName: 'OutageReserve',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'outage_reserves_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'outage_reserves_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'outage_reserves_user_date_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'date',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'price_time_range',
      dartName: 'PriceTimeRange',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'price_time_range_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'hourStart',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'hourEnd',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'distributionRatePln',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'price_time_range_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'price_time_range_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'pv_forecast',
      dartName: 'PvForecast',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'pv_forecast_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'expectedYieldWatts',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pv_forecast_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'pv_forecast_user_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'tier_sync_configs',
      dartName: 'TierSyncConfig',
      schema: 'public',
      module: 'deyelyte',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'tier_sync_configs_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'tier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'syncIntervalSeconds',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'tier_sync_configs_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'tier_sync_configs_tier_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'tier',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i4.AdminUser) {
      return _i4.AdminUser.fromJson(data) as T;
    }
    if (t == _i5.AppConfig) {
      return _i5.AppConfig.fromJson(data) as T;
    }
    if (t == _i6.DailyAvgPrice) {
      return _i6.DailyAvgPrice.fromJson(data) as T;
    }
    if (t == _i7.DailyEnergyAggregate) {
      return _i7.DailyEnergyAggregate.fromJson(data) as T;
    }
    if (t == _i8.Device) {
      return _i8.Device.fromJson(data) as T;
    }
    if (t == _i9.DeviceTelemetry) {
      return _i9.DeviceTelemetry.fromJson(data) as T;
    }
    if (t == _i10.EnergyPrice) {
      return _i10.EnergyPrice.fromJson(data) as T;
    }
    if (t == _i11.Example) {
      return _i11.Example.fromJson(data) as T;
    }
    if (t == _i12.HistoryDayData) {
      return _i12.HistoryDayData.fromJson(data) as T;
    }
    if (t == _i13.HistoryPeriodData) {
      return _i13.HistoryPeriodData.fromJson(data) as T;
    }
    if (t == _i14.IntegrationCredentials) {
      return _i14.IntegrationCredentials.fromJson(data) as T;
    }
    if (t == _i15.InverterData) {
      return _i15.InverterData.fromJson(data) as T;
    }
    if (t == _i16.InverterModel) {
      return _i16.InverterModel.fromJson(data) as T;
    }
    if (t == _i17.LicenseKey) {
      return _i17.LicenseKey.fromJson(data) as T;
    }
    if (t == _i18.OptimizationFrame) {
      return _i18.OptimizationFrame.fromJson(data) as T;
    }
    if (t == _i19.OutageReserve) {
      return _i19.OutageReserve.fromJson(data) as T;
    }
    if (t == _i20.PriceTimeRange) {
      return _i20.PriceTimeRange.fromJson(data) as T;
    }
    if (t == _i21.PvForecast) {
      return _i21.PvForecast.fromJson(data) as T;
    }
    if (t == _i22.TierSyncConfig) {
      return _i22.TierSyncConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.AdminUser?>()) {
      return (data != null ? _i4.AdminUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AppConfig?>()) {
      return (data != null ? _i5.AppConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.DailyAvgPrice?>()) {
      return (data != null ? _i6.DailyAvgPrice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.DailyEnergyAggregate?>()) {
      return (data != null ? _i7.DailyEnergyAggregate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.Device?>()) {
      return (data != null ? _i8.Device.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DeviceTelemetry?>()) {
      return (data != null ? _i9.DeviceTelemetry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.EnergyPrice?>()) {
      return (data != null ? _i10.EnergyPrice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Example?>()) {
      return (data != null ? _i11.Example.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.HistoryDayData?>()) {
      return (data != null ? _i12.HistoryDayData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.HistoryPeriodData?>()) {
      return (data != null ? _i13.HistoryPeriodData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.IntegrationCredentials?>()) {
      return (data != null ? _i14.IntegrationCredentials.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.InverterData?>()) {
      return (data != null ? _i15.InverterData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.InverterModel?>()) {
      return (data != null ? _i16.InverterModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.LicenseKey?>()) {
      return (data != null ? _i17.LicenseKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.OptimizationFrame?>()) {
      return (data != null ? _i18.OptimizationFrame.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.OutageReserve?>()) {
      return (data != null ? _i19.OutageReserve.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.PriceTimeRange?>()) {
      return (data != null ? _i20.PriceTimeRange.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.PvForecast?>()) {
      return (data != null ? _i21.PvForecast.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.TierSyncConfig?>()) {
      return (data != null ? _i22.TierSyncConfig.fromJson(data) : null) as T;
    }
    if (t == List<_i9.DeviceTelemetry>) {
      return (data as List)
              .map((e) => deserialize<_i9.DeviceTelemetry>(e))
              .toList()
          as T;
    }
    if (t == List<_i10.EnergyPrice>) {
      return (data as List)
              .map((e) => deserialize<_i10.EnergyPrice>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.OptimizationFrame>) {
      return (data as List)
              .map((e) => deserialize<_i18.OptimizationFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i7.DailyEnergyAggregate>) {
      return (data as List)
              .map((e) => deserialize<_i7.DailyEnergyAggregate>(e))
              .toList()
          as T;
    }
    if (t == List<_i6.DailyAvgPrice>) {
      return (data as List)
              .map((e) => deserialize<_i6.DailyAvgPrice>(e))
              .toList()
          as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == List<_i23.PvForecast>) {
      return (data as List).map((e) => deserialize<_i23.PvForecast>(e)).toList()
          as T;
    }
    if (t == List<_i24.OptimizationFrame>) {
      return (data as List)
              .map((e) => deserialize<_i24.OptimizationFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.OutageReserve>) {
      return (data as List)
              .map((e) => deserialize<_i25.OutageReserve>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.EnergyPrice>) {
      return (data as List)
              .map((e) => deserialize<_i26.EnergyPrice>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.PriceTimeRange>) {
      return (data as List)
              .map((e) => deserialize<_i27.PriceTimeRange>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.DeviceTelemetry>) {
      return (data as List)
              .map((e) => deserialize<_i28.DeviceTelemetry>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i4.AdminUser => 'AdminUser',
      _i5.AppConfig => 'AppConfig',
      _i6.DailyAvgPrice => 'DailyAvgPrice',
      _i7.DailyEnergyAggregate => 'DailyEnergyAggregate',
      _i8.Device => 'Device',
      _i9.DeviceTelemetry => 'DeviceTelemetry',
      _i10.EnergyPrice => 'EnergyPrice',
      _i11.Example => 'Example',
      _i12.HistoryDayData => 'HistoryDayData',
      _i13.HistoryPeriodData => 'HistoryPeriodData',
      _i14.IntegrationCredentials => 'IntegrationCredentials',
      _i15.InverterData => 'InverterData',
      _i16.InverterModel => 'InverterModel',
      _i17.LicenseKey => 'LicenseKey',
      _i18.OptimizationFrame => 'OptimizationFrame',
      _i19.OutageReserve => 'OutageReserve',
      _i20.PriceTimeRange => 'PriceTimeRange',
      _i21.PvForecast => 'PvForecast',
      _i22.TierSyncConfig => 'TierSyncConfig',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('deyelyte.', '');
    }

    switch (data) {
      case _i4.AdminUser():
        return 'AdminUser';
      case _i5.AppConfig():
        return 'AppConfig';
      case _i6.DailyAvgPrice():
        return 'DailyAvgPrice';
      case _i7.DailyEnergyAggregate():
        return 'DailyEnergyAggregate';
      case _i8.Device():
        return 'Device';
      case _i9.DeviceTelemetry():
        return 'DeviceTelemetry';
      case _i10.EnergyPrice():
        return 'EnergyPrice';
      case _i11.Example():
        return 'Example';
      case _i12.HistoryDayData():
        return 'HistoryDayData';
      case _i13.HistoryPeriodData():
        return 'HistoryPeriodData';
      case _i14.IntegrationCredentials():
        return 'IntegrationCredentials';
      case _i15.InverterData():
        return 'InverterData';
      case _i16.InverterModel():
        return 'InverterModel';
      case _i17.LicenseKey():
        return 'LicenseKey';
      case _i18.OptimizationFrame():
        return 'OptimizationFrame';
      case _i19.OutageReserve():
        return 'OutageReserve';
      case _i20.PriceTimeRange():
        return 'PriceTimeRange';
      case _i21.PvForecast():
        return 'PvForecast';
      case _i22.TierSyncConfig():
        return 'TierSyncConfig';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminUser') {
      return deserialize<_i4.AdminUser>(data['data']);
    }
    if (dataClassName == 'AppConfig') {
      return deserialize<_i5.AppConfig>(data['data']);
    }
    if (dataClassName == 'DailyAvgPrice') {
      return deserialize<_i6.DailyAvgPrice>(data['data']);
    }
    if (dataClassName == 'DailyEnergyAggregate') {
      return deserialize<_i7.DailyEnergyAggregate>(data['data']);
    }
    if (dataClassName == 'Device') {
      return deserialize<_i8.Device>(data['data']);
    }
    if (dataClassName == 'DeviceTelemetry') {
      return deserialize<_i9.DeviceTelemetry>(data['data']);
    }
    if (dataClassName == 'EnergyPrice') {
      return deserialize<_i10.EnergyPrice>(data['data']);
    }
    if (dataClassName == 'Example') {
      return deserialize<_i11.Example>(data['data']);
    }
    if (dataClassName == 'HistoryDayData') {
      return deserialize<_i12.HistoryDayData>(data['data']);
    }
    if (dataClassName == 'HistoryPeriodData') {
      return deserialize<_i13.HistoryPeriodData>(data['data']);
    }
    if (dataClassName == 'IntegrationCredentials') {
      return deserialize<_i14.IntegrationCredentials>(data['data']);
    }
    if (dataClassName == 'InverterData') {
      return deserialize<_i15.InverterData>(data['data']);
    }
    if (dataClassName == 'InverterModel') {
      return deserialize<_i16.InverterModel>(data['data']);
    }
    if (dataClassName == 'LicenseKey') {
      return deserialize<_i17.LicenseKey>(data['data']);
    }
    if (dataClassName == 'OptimizationFrame') {
      return deserialize<_i18.OptimizationFrame>(data['data']);
    }
    if (dataClassName == 'OutageReserve') {
      return deserialize<_i19.OutageReserve>(data['data']);
    }
    if (dataClassName == 'PriceTimeRange') {
      return deserialize<_i20.PriceTimeRange>(data['data']);
    }
    if (dataClassName == 'PvForecast') {
      return deserialize<_i21.PvForecast>(data['data']);
    }
    if (dataClassName == 'TierSyncConfig') {
      return deserialize<_i22.TierSyncConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.AdminUser:
        return _i4.AdminUser.t;
      case _i5.AppConfig:
        return _i5.AppConfig.t;
      case _i8.Device:
        return _i8.Device.t;
      case _i9.DeviceTelemetry:
        return _i9.DeviceTelemetry.t;
      case _i10.EnergyPrice:
        return _i10.EnergyPrice.t;
      case _i14.IntegrationCredentials:
        return _i14.IntegrationCredentials.t;
      case _i15.InverterData:
        return _i15.InverterData.t;
      case _i16.InverterModel:
        return _i16.InverterModel.t;
      case _i17.LicenseKey:
        return _i17.LicenseKey.t;
      case _i18.OptimizationFrame:
        return _i18.OptimizationFrame.t;
      case _i19.OutageReserve:
        return _i19.OutageReserve.t;
      case _i20.PriceTimeRange:
        return _i20.PriceTimeRange.t;
      case _i21.PvForecast:
        return _i21.PvForecast.t;
      case _i22.TierSyncConfig:
        return _i22.TierSyncConfig.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'deyelyte';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

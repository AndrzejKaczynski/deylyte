abstract class DeviceRepository {
  /// Returns add-on connection status plus inverter model info.
  /// Keys: connected (bool), lastSeenAt (String?), inverterReachable (bool),
  ///       inverterModelId (String?), inverterModelName (String?),
  ///       modelValidationStatus (String? — null | 'pending' | 'ok' | 'failed').
  Future<Map<String, dynamic>> getStatus();

  /// Returns the list of supported inverter models from the server.
  /// Each entry: { 'modelId': String, 'displayName': String }.
  Future<List<Map<String, dynamic>>> listModels();

  /// Saves the user's inverter model choice. Pass null to clear the selection.
  Future<void> setModel(String? modelId);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    this.minSoc = 0.20,
    this.exportSoc = 0.80,
    this.aiEnabled = true,
    this.deye = true,
    this.solcast = true,
    this.pstryk = true,
  });

  final double minSoc;
  final double exportSoc;
  final bool aiEnabled;
  final bool deye;
  final bool solcast;
  final bool pstryk;

  SettingsState copyWith({
    double? minSoc,
    double? exportSoc,
    bool? aiEnabled,
    bool? deye,
    bool? solcast,
    bool? pstryk,
  }) =>
      SettingsState(
        minSoc: minSoc ?? this.minSoc,
        exportSoc: exportSoc ?? this.exportSoc,
        aiEnabled: aiEnabled ?? this.aiEnabled,
        deye: deye ?? this.deye,
        solcast: solcast ?? this.solcast,
        pstryk: pstryk ?? this.pstryk,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setMinSoc(double v) => state = state.copyWith(minSoc: v);
  void setExportSoc(double v) => state = state.copyWith(exportSoc: v);
  void setAiEnabled(bool v) => state = state.copyWith(aiEnabled: v);
  void setDeye(bool v) => state = state.copyWith(deye: v);
  void setSolcast(bool v) => state = state.copyWith(solcast: v);
  void setPstryk(bool v) => state = state.copyWith(pstryk: v);
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

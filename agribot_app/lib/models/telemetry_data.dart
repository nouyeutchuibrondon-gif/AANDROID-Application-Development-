class TelemetryData {
  final double temperature;
  final double humidity;
  final double moisture;
  final double light;
  final int batteryLevel;
  final bool systemActive;
  final String mode;
  final DateTime timestamp;

  TelemetryData({
    required this.temperature,
    required this.humidity,
    required this.moisture,
    required this.light,
    required this.batteryLevel,
    required this.systemActive,
    required this.mode,
    required this.timestamp,
  });

  factory TelemetryData.initial() {
    return TelemetryData(
      temperature: 24.5,
      humidity: 62,
      moisture: 45,
      light: 850,
      batteryLevel: 85,
      systemActive: true,
      mode: 'Auto',
      timestamp: DateTime.now(),
    );
  }

  TelemetryData copyWith({
    double? temperature,
    double? humidity,
    double? moisture,
    double? light,
    int? batteryLevel,
    bool? systemActive,
    String? mode,
    DateTime? timestamp,
  }) {
    return TelemetryData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      moisture: moisture ?? this.moisture,
      light: light ?? this.light,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      systemActive: systemActive ?? this.systemActive,
      mode: mode ?? this.mode,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

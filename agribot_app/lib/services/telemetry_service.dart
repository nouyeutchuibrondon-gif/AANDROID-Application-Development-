import 'dart:async';
import 'dart:math';
import '../models/telemetry_data.dart';

class TelemetryService {
  static final TelemetryService _instance = TelemetryService._internal();
  
  factory TelemetryService() {
    return _instance;
  }
  
  TelemetryService._internal();

  final _dataController = StreamController<TelemetryData>.broadcast();
  late TelemetryData _currentData;
  Timer? _updateTimer;

  Stream<TelemetryData> get dataStream => _dataController.stream;

  TelemetryData get currentData => _currentData;

  void initialize() {
    _currentData = TelemetryData.initial();
    _startSimulation();
  }

  void _startSimulation() {
    _updateTimer = Timer.periodic(Duration(seconds: 5), (_) {
      _simulateDataUpdate();
    });
  }

  void _simulateDataUpdate() {
    final random = Random();
    
    _currentData = _currentData.copyWith(
      temperature: 20 + random.nextDouble() * 10,
      humidity: 40 + random.nextDouble() * 40,
      moisture: 30 + random.nextDouble() * 50,
      light: 600 + random.nextDouble() * 600,
      batteryLevel: max(20, _currentData.batteryLevel - random.nextInt(3)),
      timestamp: DateTime.now(),
    );
    
    _dataController.add(_currentData);
  }

  Future<TelemetryData> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _simulateDataUpdate();
    return _currentData;
  }

  void dispose() {
    _updateTimer?.cancel();
    _dataController.close();
  }
}

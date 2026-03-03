import 'package:flutter_riverpod/flutter_riverpod.dart';

final riskEngineProvider = Provider((ref) => RiskEngineService());

class RiskEngineService {
  Future<String> getPrimaryThreat(double latitude, double longitude) async {
    // TODO: Connect to Ambee or Google Environmental APIs
    // For now, simulate network delay and return a mock threat.
    await Future.delayed(const Duration(seconds: 2));

    // Simple logic based on mock coordinates just for demonstration
    if (latitude > 20) {
      return "High Flood Risk";
    } else {
      return "Earthquake Zone (Zone 4)";
    }
  }
}

class RiskAssessment {
  final RiskLevel level;
  final String message;

  RiskAssessment({required this.level, required this.message});
}

enum RiskLevel { low, medium, severe }

class RiskService {
  /// Resolves risk purely based on mock logic to demonstrate functionality.
  Future<RiskAssessment> getRiskForLocation(
    double latitude,
    double longitude,
    String locality,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock logic based on latitude modulo to rotate randomly on different devices
    final val = (latitude.abs() + longitude.abs()).toInt() % 10;

    if (val < 4) {
      return RiskAssessment(
        level: RiskLevel.low,
        message: 'Safe zone. No immediate alerts in \$locality.',
      );
    } else if (val < 7) {
      return RiskAssessment(
        level: RiskLevel.medium,
        message: 'Moderate Risk: Heavy rainfall expected in \$locality.',
      );
    } else {
      return RiskAssessment(
        level: RiskLevel.severe,
        message: 'High Risk: Active flood warning for \$locality.',
      );
    }
  }
}

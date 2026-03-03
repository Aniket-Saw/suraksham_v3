import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/location_service.dart';
import '../data/risk_service.dart';

final locationServiceProvider = Provider((ref) => LocationService());
final riskServiceProvider = Provider((ref) => RiskService());

class LocationRiskState {
  final bool isLoading;
  final String? error;
  final String? locality;
  final RiskAssessment? assessment;

  LocationRiskState({
    this.isLoading = false,
    this.error,
    this.locality,
    this.assessment,
  });

  LocationRiskState copyWith({
    bool? isLoading,
    String? error,
    String? locality,
    RiskAssessment? assessment,
  }) {
    return LocationRiskState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      locality: locality ?? this.locality,
      assessment: assessment ?? this.assessment,
    );
  }
}

class LocationRiskNotifier extends Notifier<LocationRiskState> {
  @override
  LocationRiskState build() {
    // Kick off the async fetch right after initialization
    Future.microtask(() => fetchRiskData());
    return LocationRiskState();
  }

  Future<void> fetchRiskData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final locData = await ref
          .read(locationServiceProvider)
          .getCurrentLocation();
      final risk = await ref
          .read(riskServiceProvider)
          .getRiskForLocation(
            locData.position.latitude,
            locData.position.longitude,
            locData.locality,
          );
      state = state.copyWith(
        isLoading: false,
        locality: locData.locality,
        assessment: risk,
      );
    } catch (e) {
      String errorMessage = 'Failed to fetch location data.';
      if (e is LocationServiceException) {
        errorMessage = e.message;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }
}

final locationRiskProvider =
    NotifierProvider<LocationRiskNotifier, LocationRiskState>(() {
      return LocationRiskNotifier();
    });

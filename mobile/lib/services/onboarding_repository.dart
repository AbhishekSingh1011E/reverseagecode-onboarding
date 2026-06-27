import "../models/onboarding_model.dart";
import "local_storage_service.dart";
import "onboarding_service.dart";

class OnboardingRepository {
  final OnboardingService _service;
  final LocalStorageService _localStorage;

  OnboardingRepository({
    OnboardingService? service,
    LocalStorageService? localStorage,
  }) : _service = service ?? OnboardingService(),
       _localStorage = localStorage ?? LocalStorageService();

  Future<String> saveProfile(OnboardingModel model) async {
    try {
      final id = await _service.createProfile(model);
      await _localStorage.clearPending();
      return id;
    } on NetworkUnavailableException {
      await _localStorage.savePending(model);
      rethrow;
    }
  }

  Future<OnboardingModel> fetchProfile(String id) {
    return _service.getProfile(id);
  }

  Future<String?> retryPendingProfile() async {
    final pending = await _localStorage.getPending();
    if (pending == null) return null;

    try {
      final id = await _service.createProfile(pending);
      await _localStorage.clearPending();
      return id;
    } on NetworkUnavailableException {
      return null;
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reverseagecode_onboarding/models/onboarding_model.dart';
import 'package:reverseagecode_onboarding/services/local_storage_service.dart';
import 'package:reverseagecode_onboarding/services/onboarding_repository.dart';
import 'package:reverseagecode_onboarding/services/onboarding_service.dart';

class _FakeOnboardingService implements OnboardingService {
  bool isOnline;
  int createCalls = 0;

  _FakeOnboardingService({this.isOnline = false});

  @override
  Future<String> createProfile(OnboardingModel model) async {
    createCalls++;
    if (!isOnline) throw NetworkUnavailableException();
    return 'server-id-123';
  }

  @override
  Future<OnboardingModel> getProfile(String id) {
    throw UnimplementedError();
  }
}

void main() {
  late OnboardingModel profile;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    profile = OnboardingModel(
      name: 'John Doe',
      dob: DateTime(1995, 6, 18),
      gender: 'Male',
      lifestyle: 'Moderately Active',
      weight: 72,
      height: 175,
    );
  });

  test('saveProfile stores the submission locally when offline, then retry succeeds once back online', () async {
    final service = _FakeOnboardingService(isOnline: false);
    final localStorage = LocalStorageService();
    final repository = OnboardingRepository(service: service, localStorage: localStorage);

    await expectLater(repository.saveProfile(profile), throwsA(isA<NetworkUnavailableException>()));

    final pending = await localStorage.getPending();
    expect(pending?.name, 'John Doe');

    service.isOnline = true;
    final retriedId = await repository.retryPendingProfile();

    expect(retriedId, 'server-id-123');
    expect(service.createCalls, 2);
    expect(await localStorage.getPending(), isNull);
  });

  test('retryPendingProfile is a no-op when nothing is pending', () async {
    final service = _FakeOnboardingService(isOnline: true);
    final repository = OnboardingRepository(service: service, localStorage: LocalStorageService());

    final result = await repository.retryPendingProfile();

    expect(result, isNull);
    expect(service.createCalls, 0);
  });

  test('retryPendingProfile leaves the pending submission in place if still offline', () async {
    final service = _FakeOnboardingService(isOnline: false);
    final localStorage = LocalStorageService();
    final repository = OnboardingRepository(service: service, localStorage: localStorage);

    await expectLater(repository.saveProfile(profile), throwsA(isA<NetworkUnavailableException>()));

    final retriedId = await repository.retryPendingProfile();

    expect(retriedId, isNull);
    expect(await localStorage.getPending(), isNotNull);
  });
}

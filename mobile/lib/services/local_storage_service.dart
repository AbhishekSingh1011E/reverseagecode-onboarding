import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_model.dart';

class LocalStorageService {
  static const _key = 'pending_onboarding_profile';

  Future<void> savePending(OnboardingModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(model.toJson()));
  }

  Future<OnboardingModel?> getPending() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return OnboardingModel.fromJson(jsonDecode(raw));
  }

  Future<void> clearPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

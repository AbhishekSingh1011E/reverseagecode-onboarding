import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../models/onboarding_model.dart';
import '../services/onboarding_repository.dart';
import '../services/onboarding_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final OnboardingRepository _repository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  OnboardingProvider({OnboardingRepository? repository})
    : _repository = repository ?? OnboardingRepository() {
    _retryPendingSubmission();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (!results.contains(ConnectivityResult.none)) {
        _retryPendingSubmission();
      }
    });
  }

  int currentStep = 0;

  String? name;
  DateTime? dob;
  String? gender;
  String? lifestyle;
  String? weight;
  String? height;

  bool isSubmitting = false;
  String? errorMessage;
  String? lastSyncedOfflineId;

  void goToNextStep() {
    if (currentStep < 2) {
      currentStep++;
      notifyListeners();
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setDob(DateTime value) {
    dob = value;
    notifyListeners();
  }

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setLifestyle(String value) {
    lifestyle = value;
    notifyListeners();
  }

  void setWeight(String value) {
    weight = value;
    notifyListeners();
  }

  void setHeight(String value) {
    height = value;
    notifyListeners();
  }

  Future<void> _retryPendingSubmission() async {
    final id = await _repository.retryPendingProfile();
    if (id != null) {
      lastSyncedOfflineId = id;
      notifyListeners();
    }
  }

  Future<String?> submit() async {
    if (name == null ||
        dob == null ||
        gender == null ||
        lifestyle == null ||
        weight == null ||
        height == null) {
      errorMessage = 'Please complete all fields';
      notifyListeners();
      return null;
    }

    final parsedWeight = double.tryParse(weight!.trim());
    final parsedHeight = double.tryParse(height!.trim());
    if (parsedWeight == null || parsedHeight == null) {
      errorMessage = 'Invalid weight or height';
      notifyListeners();
      return null;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final model = OnboardingModel(
        name: name!,
        dob: dob!,
        gender: gender!,
        lifestyle: lifestyle!,
        weight: parsedWeight,
        height: parsedHeight,
      );
      final id = await _repository.saveProfile(model);
      return id;
    } on NetworkUnavailableException {
      errorMessage =
          "No internet — saved on your device, we'll submit it automatically once "
          "you're back online.";
      return null;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

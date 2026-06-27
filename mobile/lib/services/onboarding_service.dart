import "dart:convert";
import "package:http/http.dart" as http;
import "../models/onboarding_model.dart";

class NetworkUnavailableException implements Exception {
  @override
  String toString() => "No internet connection";
}

class OnboardingService {
  static String get _baseUrl {
    const host = "10.122.193.154";
    return "http://$host:5000/api/onboarding";
  }

  Future<String> createProfile(OnboardingModel model) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );
    } catch (_) {
      throw NetworkUnavailableException();
    }

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data["success"] == true) {
      return data["id"] ?? "";
    } else if (response.statusCode == 400) {
      final errors = data["errors"];
      throw Exception(errors is List ? errors.join(", ") : "Validation failed");
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }

  Future<OnboardingModel> getProfile(String id) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse("$_baseUrl/$id"));
    } catch (_) {
      throw NetworkUnavailableException();
    }

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return OnboardingModel.fromJson(data["data"]);
    } else if (response.statusCode == 404) {
      throw Exception("Profile not found");
    } else {
      throw Exception(data["message"] ?? "Could not fetch profile");
    }
  }
}

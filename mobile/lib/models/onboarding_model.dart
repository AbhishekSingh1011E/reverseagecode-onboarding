class OnboardingModel {
  final String name;
  final DateTime dob;
  final String gender;
  final String lifestyle;
  final double weight;
  final double height;

  OnboardingModel({
    required this.name,
    required this.dob,
    required this.gender,
    required this.lifestyle,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "dob":
          "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
      "gender": gender,
      "lifestyle": lifestyle,
      "weight": weight,
      "height": height,
    };
  }

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      name: json["name"] ?? "",
      dob: DateTime.parse(json["dob"]),
      gender: json["gender"] ?? "",
      lifestyle: json["lifestyle"] ?? "",
      weight: (json["weight"] as num).toDouble(),
      height: (json["height"] as num).toDouble(),
    );
  }
}

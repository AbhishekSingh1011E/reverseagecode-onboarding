class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? dob(DateTime? value) {
    if (value == null) {
      return 'Please select your date of birth';
    }
    if (value.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }

  static String? gender(String? value) {
    const validGenders = ['Male', 'Female', 'Other'];
    if (value == null || value.isEmpty || !validGenders.contains(value)) {
      return 'Please select a gender';
    }
    return null;
  }

  static String? lifestyle(String? value) {
    const validLifestyles = [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
    ];
    if (value == null || value.isEmpty || !validLifestyles.contains(value)) {
      return 'Please select a lifestyle';
    }
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your weight';
    }

    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 20 || parsed > 300) {
      return 'Weight must be between 20kg and 300kg';
    }

    return null;
  }

  static String? height(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your height';
    }

    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 50 || parsed > 250) {
      return 'Height must be between 50cm and 250cm';
    }

    return null;
  }
}

import 'package:flutter/material.dart';

class LifestyleDropdown extends StatelessWidget {
  static const options = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
  ];

  final String? value;
  final String? errorText;
  final void Function(String) onChanged;

  const LifestyleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lifestyle',
          style: TextStyle(fontSize: 14, color: Color(0xFF6E8198)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          hint: const Text('Select from the list'),
          decoration: InputDecoration(errorText: errorText),
          items: options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}

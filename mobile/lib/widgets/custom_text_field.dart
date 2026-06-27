import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.validator,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6E8198)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(hintText: hint),
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

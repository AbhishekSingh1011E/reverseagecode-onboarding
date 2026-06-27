import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  static const options = ['Male', 'Female', 'Other'];

  final String? value;
  final String? errorText;
  final void Function(String) onChanged;

  const GenderSelector({
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
          'Gender',
          style: TextStyle(fontSize: 14, color: Color(0xFF6E8198)),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            final selected = value == option;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: option == options.last ? 0 : 10,
                ),
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF0683C6) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF0683C6)
                            : const Color(0xFFD9DEE3),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xFF1F2933),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

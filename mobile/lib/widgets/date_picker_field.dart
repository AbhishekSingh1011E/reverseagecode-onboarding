import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final String? errorText;
  final void Function(DateTime) onChanged;

  const DatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = value == null
        ? null
        : '${value!.day.toString().padLeft(2, '0')}/${value!.month.toString().padLeft(2, '0')}/${value!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6E8198)),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              errorText: errorText,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            ),
            child: Text(
              text ?? 'DD/MM/YYYY',
              style: TextStyle(
                color: text == null ? const Color(0xFFA7B0BD) : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

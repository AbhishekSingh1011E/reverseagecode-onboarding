import 'package:flutter/material.dart';

class ProgressIndicatorBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  static const _teal = Color(0xFF0D9488);
  static const _track = Color(0xFFE3E6EA);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final segment = width / totalSteps;
        final fillWidth = segment * (currentStep + 1);

        return SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 4,
                width: width,
                decoration: BoxDecoration(
                  color: _track,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 4,
                width: fillWidth,
                decoration: BoxDecoration(
                  color: _teal,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              for (var i = 0; i < totalSteps; i++)
                Positioned(
                  left: (segment * (i + 1) - 8).clamp(0, width - 16),
                  child: _StepDot(active: i == currentStep),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;

  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFFCBD2D9),
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: ProgressIndicatorBar._teal, width: 3),
      ),
    );
  }
}

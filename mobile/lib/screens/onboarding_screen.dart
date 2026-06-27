import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/onboarding_provider.dart';
import '../utils/bmi_calculator.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/gender_selector.dart';
import '../widgets/lifestyle_dropdown.dart';
import '../widgets/primary_button.dart';
import '../widgets/progress_indicator_bar.dart';
import 'success_screen.dart';

const _teal = Color(0xFF0D9488);
const _navy = Color(0xFF0B2340);
const _slate = Color(0xFF708AA9);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _touched = <String>{};

  String? _handledSyncId;

  bool _isFormValid(OnboardingProvider provider) {
    return Validators.name(provider.name) == null &&
        Validators.dob(provider.dob) == null &&
        Validators.gender(provider.gender) == null &&
        Validators.lifestyle(provider.lifestyle) == null &&
        Validators.weight(provider.weight) == null &&
        Validators.height(provider.height) == null;
  }

  Future<void> _handleNext(OnboardingProvider provider) async {
    final id = await provider.submit();
    if (!mounted) return;

    if (id != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SuccessScreen()),
      );
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final canProceed = _isFormValid(provider);
    final screenWidth = MediaQuery.of(context).size.width;
    final swooshScale = screenWidth / 440;

    final syncedId = provider.lastSyncedOfflineId;
    if (syncedId != null && syncedId != _handledSyncId) {
      _handledSyncId = syncedId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: -60 * swooshScale,
              right: -60 * swooshScale,
              bottom: -36,
              child: Center(
                child: Container(
                  width: 560 * swooshScale,
                  height: 110 * swooshScale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2FBFA),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(280 * swooshScale, 55 * swooshScale),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -54,
              child: Center(
                child: Container(
                  width: 440 * swooshScale,
                  height: 88 * swooshScale,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDEEF1),
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(220 * swooshScale, 44 * swooshScale),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: const Icon(Icons.chevron_left, color: _navy),
                      ),
                      const Text(
                        'STEP 1 OF 3',
                        style: TextStyle(
                          color: _teal,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProgressIndicatorBar(currentStep: 0),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildForm(provider),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: PrimaryButton(
                    label: 'Next',
                    isLoading: provider.isSubmitting,
                    onPressed: canProceed ? () => _handleNext(provider) : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i == 0;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? _teal : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(OnboardingProvider provider) {
    final bmi = BmiCalculator.calculate(provider.weight ?? '');

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About you',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Help us personalise your hydration goal',
            style: TextStyle(color: _slate),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Full name',
            hint: 'Enter your name',
            initialValue: provider.name,
            validator: Validators.name,
            onChanged: provider.setName,
          ),
          const SizedBox(height: 18),
          DatePickerField(
            label: 'Date of birth',
            value: provider.dob,
            errorText: _touched.contains('dob')
                ? Validators.dob(provider.dob)
                : null,
            onChanged: (value) {
              _touched.add('dob');
              provider.setDob(value);
            },
          ),
          const SizedBox(height: 18),
          GenderSelector(
            value: provider.gender,
            errorText: _touched.contains('gender')
                ? Validators.gender(provider.gender)
                : null,
            onChanged: (value) {
              _touched.add('gender');
              provider.setGender(value);
            },
          ),
          const SizedBox(height: 18),
          LifestyleDropdown(
            value: provider.lifestyle,
            errorText: _touched.contains('lifestyle')
                ? Validators.lifestyle(provider.lifestyle)
                : null,
            onChanged: (value) {
              _touched.add('lifestyle');
              provider.setLifestyle(value);
            },
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Weight (kg)',
                  hint: '00',
                  initialValue: provider.weight,
                  keyboardType: TextInputType.number,
                  validator: Validators.weight,
                  onChanged: provider.setWeight,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Height (cm)',
                  hint: '00',
                  initialValue: provider.height,
                  keyboardType: TextInputType.number,
                  validator: Validators.height,
                  onChanged: provider.setHeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            bmi != null
                ? 'BMI : ${bmi.toStringAsFixed(1)}'
                : 'Will be used to calculate your personalised daily goal',
            style: TextStyle(
              color: bmi != null ? _teal : _slate,
              fontWeight: bmi != null ? FontWeight.w700 : FontWeight.w400,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

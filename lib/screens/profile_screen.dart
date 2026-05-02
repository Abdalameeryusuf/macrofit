import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/calo_app_bar.dart';
import '../widgets/number_input.dart';
import '../widgets/primary_button.dart';
import 'activity_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.goal});

  final Goal goal;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _weightKg = 70;
  int _heightCm = 170;
  int _ageYears = 25;
  Sex _sex = Sex.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CaloAppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Profile', style: AppTextStyles.screenTitle),
              const SizedBox(height: 28),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tell us your current weight',
                        style: AppTextStyles.sectionLabel,
                      ),
                      const SizedBox(height: 12),
                      NumberInput(
                        value: _weightKg,
                        unit: 'kg',
                        min: 30,
                        max: 250,
                        onChanged: (int v) => setState(() => _weightKg = v),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'And your height?',
                        style: AppTextStyles.sectionLabel,
                      ),
                      const SizedBox(height: 12),
                      NumberInput(
                        value: _heightCm,
                        unit: 'cm',
                        min: 100,
                        max: 230,
                        onChanged: (int v) => setState(() => _heightCm = v),
                      ),
                      const SizedBox(height: 28),
                      Text('Your age', style: AppTextStyles.sectionLabel),
                      const SizedBox(height: 12),
                      NumberInput(
                        value: _ageYears,
                        unit: 'yrs',
                        min: 14,
                        max: 90,
                        onChanged: (int v) => setState(() => _ageYears = v),
                      ),
                      const SizedBox(height: 28),
                      Text('Sex', style: AppTextStyles.sectionLabel),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SexPill(
                              label: 'Male',
                              selected: _sex == Sex.male,
                              onTap: () => setState(() => _sex = Sex.male),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SexPill(
                              label: 'Female',
                              selected: _sex == Sex.female,
                              onTap: () => setState(() => _sex = Sex.female),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Next',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ActivityScreen(
                        goal: widget.goal,
                        weightKg: _weightKg,
                        heightCm: _heightCm,
                        ageYears: _ageYears,
                        sex: _sex,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SexPill extends StatelessWidget {
  const _SexPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.selectedTint : AppColors.background,
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected
                  ? AppColors.cardBorderSelected
                  : AppColors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.pillLabel.copyWith(
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/macro_result.dart';
import '../models/user_profile.dart';
import '../services/macro_calculator.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/macro_bar.dart';
import '../widgets/primary_button.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.profile});

  final UserProfile profile;

  String _subtitleForGoal(Goal goal) {
    switch (goal) {
      case Goal.loseWeight:
        return "Here's what you need to lose weight safely";
      case Goal.maintainWeight:
        return "Here's what you need to maintain your weight";
      case Goal.buildMuscle:
        return "Here's what you need to build muscle";
      case Goal.gainWeight:
        return "Here's what you need to gain weight steadily";
    }
  }

  String _formatNumber(int n) {
    final String s = n.toString();
    final StringBuffer out = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final int fromEnd = s.length - i;
      out.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) {
        out.write(',');
      }
    }
    return out.toString();
  }

  @override
  Widget build(BuildContext context) {
    final MacroResult result = MacroCalculator.calculate(profile);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your daily targets', style: AppTextStyles.screenTitle),
              const SizedBox(height: 8),
              Text(
                _subtitleForGoal(profile.goal),
                style: AppTextStyles.screenSubtitle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CaloriesCard(calories: result.dailyCalories, formatter: _formatNumber),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              value: '${_formatNumber(result.bmr)} kcal',
                              label: 'Basal Metabolic Rate',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              value: '${_formatNumber(result.tdee)} kcal',
                              label: 'Total Daily Energy',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _MacroBreakdownCard(result: result),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Start Over',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.calories, required this.formatter});

  final int calories;
  final String Function(int) formatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.selectedTint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryGreen, width: 2),
      ),
      child: Column(
        children: [
          Text(
            '${formatter(calories)} kcal/day',
            style: AppTextStyles.heroNumber,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Daily Calorie Target',
            style: AppTextStyles.statLabel.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTextStyles.statNumber),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.statLabel),
        ],
      ),
    );
  }
}

class _MacroBreakdownCard extends StatelessWidget {
  const _MacroBreakdownCard({required this.result});

  final MacroResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Macro Breakdown', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          MacroBar(
            proteinPercent: result.proteinPercent.toDouble(),
            carbsPercent: result.carbsPercent.toDouble(),
            fatPercent: result.fatPercent.toDouble(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MacroColumn(
                  color: AppColors.macroProtein,
                  grams: result.proteinGrams,
                  percent: result.proteinPercent,
                  label: 'Protein',
                ),
              ),
              Expanded(
                child: _MacroColumn(
                  color: AppColors.macroCarbs,
                  grams: result.carbsGrams,
                  percent: result.carbsPercent,
                  label: 'Carbs',
                ),
              ),
              Expanded(
                child: _MacroColumn(
                  color: AppColors.macroFat,
                  grams: result.fatGrams,
                  percent: result.fatPercent,
                  label: 'Fat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroColumn extends StatelessWidget {
  const _MacroColumn({
    required this.color,
    required this.grams,
    required this.percent,
    required this.label,
  });

  final Color color;
  final int grams;
  final int percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Text('${grams}g', style: AppTextStyles.macroValue),
        const SizedBox(height: 2),
        Text('$percent%', style: AppTextStyles.macroLabel),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.macroLabel),
      ],
    );
  }
}

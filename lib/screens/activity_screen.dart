import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/calo_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/selectable_card.dart';
import 'results_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({
    super.key,
    required this.goal,
    required this.weightKg,
    required this.heightCm,
    required this.ageYears,
    required this.sex,
  });

  final Goal goal;
  final int weightKg;
  final int heightCm;
  final int ageYears;
  final Sex sex;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ActivityLevel? _selected;

  static const List<_ActivityOption> _options = [
    _ActivityOption(
      level: ActivityLevel.sedentary,
      title: 'Sedentary',
      description: 'You spend most of your day sitting with little to no exercise',
      emoji: '💻',
    ),
    _ActivityOption(
      level: ActivityLevel.lightlyActive,
      title: 'Lightly Active',
      description: 'You do light daily activities or 1-2 light workouts a week',
      emoji: '🚶',
    ),
    _ActivityOption(
      level: ActivityLevel.veryActive,
      title: 'Very Active',
      description: 'On your feet most of the day or you moderately exercise 3-5x weekly',
      emoji: '🏃‍♀️',
    ),
    _ActivityOption(
      level: ActivityLevel.highlyActive,
      title: 'Highly Active',
      description: 'Physically demanding job or intense exercise 5+ times weekly',
      emoji: '🏋️‍♀️',
    ),
  ];

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
              Text('How active are you?', style: AppTextStyles.screenTitle),
              const SizedBox(height: 8),
              Text(
                'Consider both daily activities and workouts',
                style: AppTextStyles.screenSubtitle,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (_, int i) {
                    final _ActivityOption option = _options[i];
                    return SelectableCard(
                      title: option.title,
                      description: option.description,
                      emoji: option.emoji,
                      selected: _selected == option.level,
                      onTap: () => setState(() => _selected = option.level),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Calculate',
                onPressed: _selected == null
                    ? null
                    : () {
                        final UserProfile profile = UserProfile(
                          weightKg: widget.weightKg,
                          heightCm: widget.heightCm,
                          ageYears: widget.ageYears,
                          sex: widget.sex,
                          goal: widget.goal,
                          activityLevel: _selected!,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ResultsScreen(profile: profile),
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

class _ActivityOption {
  const _ActivityOption({
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
  });

  final ActivityLevel level;
  final String title;
  final String description;
  final String emoji;
}

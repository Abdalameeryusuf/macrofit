import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/calo_app_bar.dart';
import '../widgets/primary_button.dart';
import '../widgets/selectable_card.dart';
import 'profile_screen.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  Goal? _selected;

  static const List<_GoalOption> _options = [
    _GoalOption(
      goal: Goal.loseWeight,
      title: 'Lose Weight',
      description: 'Safe and healthy rate of weight loss',
      emoji: '🏃',
    ),
    _GoalOption(
      goal: Goal.maintainWeight,
      title: 'Maintain Weight',
      description: 'Stay in shape with the right calories',
      emoji: '🧘',
    ),
    _GoalOption(
      goal: Goal.buildMuscle,
      title: 'Build Muscle',
      description: 'Gain strength while minimizing fat gain',
      emoji: '🏋️',
    ),
    _GoalOption(
      goal: Goal.gainWeight,
      title: 'Gain Weight',
      description: 'Safe and healthy rate of weight gain',
      emoji: '💪',
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
              Text("What's your goal?", style: AppTextStyles.screenTitle),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (_, int i) {
                    final _GoalOption option = _options[i];
                    return SelectableCard(
                      title: option.title,
                      description: option.description,
                      emoji: option.emoji,
                      selected: _selected == option.goal,
                      onTap: () => setState(() => _selected = option.goal),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Next',
                onPressed: _selected == null
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ProfileScreen(goal: _selected!),
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

class _GoalOption {
  const _GoalOption({
    required this.goal,
    required this.title,
    required this.description,
    required this.emoji,
  });

  final Goal goal;
  final String title;
  final String description;
  final String emoji;
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  void _decrement() {
    if (value > min) onChanged(value - 1);
  }

  void _increment() {
    if (value < max) onChanged(value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(
          icon: Icons.remove,
          onTap: value > min ? _decrement : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$value',
                    style: AppTextStyles.numberInput,
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 1,
                  color: AppColors.cardBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Text(unit, style: AppTextStyles.unitLabel),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _StepperButton(
          icon: Icons.add,
          onTap: value < max ? _increment : null,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return Material(
      color: enabled
          ? AppColors.primaryGreen
          : AppColors.primaryGreen.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

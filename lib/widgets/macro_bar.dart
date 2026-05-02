import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    this.height = 14,
  });

  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double total = proteinPercent + carbsPercent + fatPercent;
    final double safeTotal = total <= 0 ? 1 : total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              flex: ((proteinPercent / safeTotal) * 1000).round(),
              child: Container(color: AppColors.macroProtein),
            ),
            Expanded(
              flex: ((carbsPercent / safeTotal) * 1000).round(),
              child: Container(color: AppColors.macroCarbs),
            ),
            Expanded(
              flex: ((fatPercent / safeTotal) * 1000).round(),
              child: Container(color: AppColors.macroFat),
            ),
          ],
        ),
      ),
    );
  }
}

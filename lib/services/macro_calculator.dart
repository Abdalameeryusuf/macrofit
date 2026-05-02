import '../models/macro_result.dart';
import '../models/user_profile.dart';

class MacroCalculator {
  const MacroCalculator._();

  static double calculateBMR({
    required int weightKg,
    required int heightCm,
    required int ageYears,
    required Sex sex,
  }) {
    final double base = (10 * weightKg) + (6.25 * heightCm) - (5 * ageYears);
    return sex == Sex.male ? base + 5 : base - 161;
  }

  static double calculateTDEE({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    return bmr * activityLevel.multiplier;
  }

  static double calculateDailyCalories({
    required double tdee,
    required Goal goal,
  }) {
    return tdee + goal.calorieDelta;
  }

  static MacroResult calculate(UserProfile profile) {
    final double bmr = calculateBMR(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      ageYears: profile.ageYears,
      sex: profile.sex,
    );
    final double tdee = calculateTDEE(
      bmr: bmr,
      activityLevel: profile.activityLevel,
    );
    final double calories = calculateDailyCalories(
      tdee: tdee,
      goal: profile.goal,
    );

    final MacroSplit split = profile.goal.macroSplit;
    final double proteinG = (calories * split.proteinPercent) / 4;
    final double carbsG = (calories * split.carbsPercent) / 4;
    final double fatG = (calories * split.fatPercent) / 9;

    return MacroResult(
      bmr: bmr.round(),
      tdee: tdee.round(),
      dailyCalories: calories.round(),
      proteinGrams: proteinG.round(),
      carbsGrams: carbsG.round(),
      fatGrams: fatG.round(),
      proteinPercent: (split.proteinPercent * 100).round(),
      carbsPercent: (split.carbsPercent * 100).round(),
      fatPercent: (split.fatPercent * 100).round(),
    );
  }
}

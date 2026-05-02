import 'package:flutter_test/flutter_test.dart';
import 'package:macrofit/models/macro_result.dart';
import 'package:macrofit/models/user_profile.dart';
import 'package:macrofit/services/macro_calculator.dart';

void main() {
  group('MacroCalculator.calculateBMR', () {
    test('Mifflin-St Jeor for male: 25y, 75kg, 175cm => 1723.75', () {
      final double bmr = MacroCalculator.calculateBMR(
        weightKg: 75,
        heightCm: 175,
        ageYears: 25,
        sex: Sex.male,
      );
      expect(bmr, closeTo(1723.75, 0.01));
    });

    test('Mifflin-St Jeor for female: 30y, 60kg, 165cm => 1320.25', () {
      final double bmr = MacroCalculator.calculateBMR(
        weightKg: 60,
        heightCm: 165,
        ageYears: 30,
        sex: Sex.female,
      );
      expect(bmr, closeTo(1320.25, 0.01));
    });
  });

  group('MacroCalculator.calculate (full pipeline)', () {
    test('25y male, 75kg, 175cm, lightly active, build muscle', () {
      const UserProfile profile = UserProfile(
        weightKg: 75,
        heightCm: 175,
        ageYears: 25,
        sex: Sex.male,
        goal: Goal.buildMuscle,
        activityLevel: ActivityLevel.lightlyActive,
      );

      final MacroResult r = MacroCalculator.calculate(profile);

      expect(r.bmr, 1724);
      expect(r.tdee, 2370);
      expect(r.dailyCalories, 2620);
      expect(r.proteinGrams, 197);
      expect(r.carbsGrams, 328);
      expect(r.fatGrams, 58);
      expect(r.proteinPercent + r.carbsPercent + r.fatPercent, 100);
    });

    test('Goal calorie deltas are applied correctly', () {
      const base = UserProfile(
        weightKg: 70,
        heightCm: 170,
        ageYears: 30,
        sex: Sex.male,
        goal: Goal.maintainWeight,
        activityLevel: ActivityLevel.sedentary,
      );

      final int maintain = MacroCalculator.calculate(base).dailyCalories;
      final int lose = MacroCalculator.calculate(
        base.copyWith(goal: Goal.loseWeight),
      ).dailyCalories;
      final int gain = MacroCalculator.calculate(
        base.copyWith(goal: Goal.gainWeight),
      ).dailyCalories;

      expect(lose, maintain - 500);
      expect(gain, maintain + 500);
    });
  });
}

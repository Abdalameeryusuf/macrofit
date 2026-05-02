enum Sex { male, female }

enum Goal { loseWeight, maintainWeight, buildMuscle, gainWeight }

enum ActivityLevel { sedentary, lightlyActive, veryActive, highlyActive }

extension ActivityMultiplier on ActivityLevel {
  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.veryActive:
        return 1.55;
      case ActivityLevel.highlyActive:
        return 1.725;
    }
  }
}

extension GoalCalorieAdjustment on Goal {
  int get calorieDelta {
    switch (this) {
      case Goal.loseWeight:
        return -500;
      case Goal.maintainWeight:
        return 0;
      case Goal.buildMuscle:
        return 250;
      case Goal.gainWeight:
        return 500;
    }
  }
}

class MacroSplit {
  const MacroSplit({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
  });

  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
}

extension GoalMacroSplit on Goal {
  MacroSplit get macroSplit {
    switch (this) {
      case Goal.loseWeight:
        return const MacroSplit(
          proteinPercent: 0.35,
          carbsPercent: 0.40,
          fatPercent: 0.25,
        );
      case Goal.maintainWeight:
        return const MacroSplit(
          proteinPercent: 0.25,
          carbsPercent: 0.50,
          fatPercent: 0.25,
        );
      case Goal.buildMuscle:
        return const MacroSplit(
          proteinPercent: 0.30,
          carbsPercent: 0.50,
          fatPercent: 0.20,
        );
      case Goal.gainWeight:
        return const MacroSplit(
          proteinPercent: 0.25,
          carbsPercent: 0.55,
          fatPercent: 0.20,
        );
    }
  }
}

class UserProfile {
  const UserProfile({
    required this.weightKg,
    required this.heightCm,
    required this.ageYears,
    required this.sex,
    required this.goal,
    required this.activityLevel,
  });

  final int weightKg;
  final int heightCm;
  final int ageYears;
  final Sex sex;
  final Goal goal;
  final ActivityLevel activityLevel;

  UserProfile copyWith({
    int? weightKg,
    int? heightCm,
    int? ageYears,
    Sex? sex,
    Goal? goal,
    ActivityLevel? activityLevel,
  }) {
    return UserProfile(
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      ageYears: ageYears ?? this.ageYears,
      sex: sex ?? this.sex,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}

# MacroFit

A Calo-style macro calculator that turns a quick onboarding flow into a personalised daily calorie and macronutrient target.

![Results screen](screenshots/results.png)

## Why I built this

I'm putting together a portfolio piece for a Calo internship application. I wanted something that lived end-to-end in the same world Calo's product does — a clean, single-purpose mobile flow that takes a few inputs and gives back a number you'd actually use. It also gave me an excuse to ship a small Flutter app and implement the nutrition math by hand instead of leaning on a library.

## Features

- 5-screen onboarding flow: welcome → goal → profile → activity → results
- Mifflin-St Jeor BMR, activity-multiplier TDEE, goal-adjusted daily calories
- Macro split tailored to the chosen goal, shown as grams + percent + a stacked bar
- Calo-inspired visual design: green primary, light selected-state tint, rounded cards, circular icon buttons
- No backend, no persistence, no API calls — everything is computed locally on-device

## Calculation methodology

**BMR — Mifflin-St Jeor**

```
Male:   BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) + 5
Female: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) − 161
```

**TDEE** = BMR × activity multiplier (Sedentary 1.2, Lightly Active 1.375, Very Active 1.55, Highly Active 1.725).

**Daily calories** = TDEE adjusted by goal: −500 (lose), 0 (maintain), +250 (build muscle), +500 (gain).

**Macro split** is fixed per goal and converted to grams using 4 kcal/g for protein and carbs, 9 kcal/g for fat:

| Goal          | Protein | Carbs | Fat |
|---------------|---------|-------|-----|
| Lose Weight   | 35%     | 40%   | 25% |
| Maintain      | 25%     | 50%   | 25% |
| Build Muscle  | 30%     | 50%   | 20% |
| Gain Weight   | 25%     | 55%   | 20% |

All of this lives in [`lib/services/macro_calculator.dart`](lib/services/macro_calculator.dart) as pure functions, with unit tests in [`test/macro_calculator_test.dart`](test/macro_calculator_test.dart).

## How I built it

I scaffolded the project with Claude Code from a written spec and a folder of Calo screenshots, then refined it manually. The structure (theme + widgets + models + services + screens), the math, and the visual design were all driven by the spec; the screenshots were the source of truth for spacing, card shape, button style, and the overall green palette.

Things I customised after the first pass:
- Bumped the welcome screen's hero copy to match Calo's actual app instead of the generic spec text
- Tightened the macro-bar colours to read cleanly at small sizes (purple / orange / blue)
- Added an extra unit test covering the goal-delta math, since the +250/−500 logic is the part most likely to silently regress

## Run it

```bash
flutter pub get
flutter run
```

Tested on iOS Simulator and Android Emulator. Runs on Flutter 3.41 / Dart 3.11.

```bash
flutter test       # runs the macro-calculator unit tests
flutter analyze    # static analysis, should report no issues
```

## Screenshots

| Welcome | Goal | Profile | Activity | Results |
|---------|------|---------|----------|---------|
| ![Welcome](screenshots/welcome.png) | ![Goal](screenshots/goal.png) | ![Profile](screenshots/profile.png) | ![Activity](screenshots/activity.png) | ![Results](screenshots/results.png) |

> Screenshots are added after running the app on a simulator. Drop the captures into `screenshots/` with the filenames above.

## What I'd do next

- **Persist the profile** locally (shared_preferences / Hive) so reopening the app skips the flow
- **History view** showing past targets when weight/activity change over time
- **Meal logging** with progress bars against the daily target — the obvious next product step for a Calo-style app
- **Refine the formula**: support imperial units, add body-fat-percentage (Katch-McArdle) as an alternative BMR source
- **Goal recommendations** — surface "you'd hit your target weight in ~12 weeks at this rate" instead of just a number
- **Accessibility pass**: dynamic type, semantic labels on the icon buttons, sufficient hit targets on the stepper buttons

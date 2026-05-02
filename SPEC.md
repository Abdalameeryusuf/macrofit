# Calo-Style Macro Calculator — Build Spec

## Project Overview

A standalone Flutter app that calculates a user's daily calorie and macronutrient targets based on their profile, activity level, and fitness goal. Designed as a proof-of-work portfolio piece styled to match the Calo (calo.app) brand identity.

**Stack:** Flutter (Dart), no backend, no persistence, no external APIs.

**Target output:** A multi-screen onboarding flow ending in a results screen showing BMR, TDEE, daily calories, and a macro breakdown (protein/carbs/fat in grams and percentages).

---

## User Flow (5 screens)

1. **Welcome / Start** — branded intro screen with a "Get Started" button
2. **Goal Selection** — pick one: Lose Weight / Maintain / Build Muscle / Gain Weight
3. **Profile** — current weight (kg) and height (cm)
4. **Activity Level** — Sedentary / Lightly Active / Very Active / Highly Active
5. **Results** — BMR, TDEE, daily calorie target, macro split (g + %)

Navigation: forward via "Next"/"Continue" button, backward via top-left back arrow. Top-right has a headphones icon (decorative, for visual parity with Calo — non-functional).

---

## Design System (match Calo exactly)

### Colors
- Primary green: `#28C76F` (buttons, selected state borders, checkmarks)
- Selected card background tint: `#E8F8EF` (very light green)
- Background: `#FFFFFF` (pure white)
- Text primary: `#1A1A1A` (near-black)
- Text secondary: `#6B7280` (medium gray for descriptions)
- Card border (unselected): `#E5E7EB` (light gray)
- Card border (selected): `#28C76F` (primary green, ~2px)

### Typography
- Use a clean sans-serif. `Inter` from Google Fonts is the closest match. Fall back to system default.
- Screen title (e.g., "What's your goal?"): 28–32px, bold, near-black
- Subtitle/description: 15–16px, regular, gray
- Card title: 17–18px, semibold
- Card description: 14–15px, regular, gray
- Button text: 16px, semibold, white

### Layout
- Horizontal padding: 24px on screen edges
- Card padding: 20px internal
- Card corner radius: 16px
- Card spacing (vertical between cards): 12–16px
- Button corner radius: 12px (rectangular, full-width, 56px tall)
- Top app bar: circular gray (#F3F4F6) buttons for back arrow (left) and headphones (right), ~44px diameter

### Card structure (used on Goal and Activity screens)
- Rounded white card with thin border
- Title + description text on the left
- Emoji on the right (large, ~40–48px)
- Tap target: entire card
- Selected state: green border (2px) + slight green-tinted background

### Number input (used on Profile and any numeric input)
- Green minus button (square, rounded corners) on the left
- White text field in the middle showing the number with unit (e.g., "85" with "kg" right-aligned inside)
- Green plus button (square, rounded corners) on the right
- Increment/decrement: 1 unit per tap

### Bottom button
- Full-width, primary green, white text, semibold
- 56px height, 12px corner radius
- 24px horizontal margin from screen edges
- 24px from bottom safe area

---

## Screen-by-Screen Spec

### Screen 1: Welcome
- Centered Calo-style logo placeholder (use a simple text "MacroFit" or similar in green, bold, large)
- Tagline below: "Find your perfect daily macros"
- Bottom: green "Get Started" button

### Screen 2: Goal Selection
- App bar: back arrow + headphones icon
- Title: "What's your goal?" (large, bold)
- 4 selectable cards (one selected at a time):
  - **Lose Weight** — "Safe and healthy rate of weight loss" — 🏃
  - **Maintain Weight** — "Stay in shape with the right calories" — 🧘
  - **Build Muscle** — "Gain strength while minimizing fat gain" — 🏋️
  - **Gain Weight** — "Safe and healthy rate of weight gain" — 💪
- Bottom: "Next" button (disabled until a goal is selected)

### Screen 3: Profile
- App bar: back arrow + headphones icon
- Title: "Your Profile" (large, bold)
- Section label: "Tell us your current weight"
- Number input: weight in kg, default 70, range 30–250
- Section label: "And your height?"
- Number input: height in cm, default 170, range 100–230
- Section label: "Your age"
- Number input: age in years, default 25, range 14–90
- Section label: "Sex" (required for BMR formula)
- Two pill-style toggle buttons: Male / Female (single select, green when selected)
- Bottom: "Next" button (always enabled since defaults are valid)

### Screen 4: Activity Level
- App bar: back arrow + headphones icon
- Title: "How active are you?"
- Subtitle: "Consider both daily activities and workouts"
- 4 selectable cards:
  - **Sedentary** — "You spend most of your day sitting with little to no exercise" — 💻 (multiplier: 1.2)
  - **Lightly Active** — "You do light daily activities or 1-2 light workouts a week" — 🚶 (multiplier: 1.375)
  - **Very Active** — "On your feet most of the day or you moderately exercise 3-5x weekly" — 🏃‍♀️ (multiplier: 1.55)
  - **Highly Active** — "Physically demanding job or intense exercise 5+ times weekly" — 🏋️‍♀️ (multiplier: 1.725)
- Bottom: "Calculate" button

### Screen 5: Results
- App bar: back arrow + headphones icon
- Title: "Your daily targets"
- Subtitle: short message based on goal, e.g., "Here's what you need to build muscle"
- **Calories card** (large, prominent): big number (e.g., "2,486 kcal/day") with label "Daily Calorie Target"
- **Stats row** (two small cards side by side):
  - BMR: "1,750 kcal" — label "Basal Metabolic Rate"
  - TDEE: "2,712 kcal" — label "Total Daily Energy"
- **Macro breakdown card**:
  - Stacked horizontal bar (purple for protein, orange for carbs, blue for fat — matches Calo's macro bar in screenshot 1)
  - Three columns below the bar showing: grams + percentage + label
    - Example: "186g (30%) Protein" / "311g (50%) Carbs" / "55g (20%) Fat"
- Bottom: "Start Over" button (returns to Welcome screen, resets state)

---

## Calculation Logic

### BMR (Mifflin-St Jeor formula)
```
Male:   BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) + 5
Female: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age) − 161
```

### TDEE
```
TDEE = BMR × activity_multiplier
```
Multipliers: Sedentary 1.2, Lightly Active 1.375, Very Active 1.55, Highly Active 1.725

### Daily Calorie Target (based on goal)
```
Lose Weight:    TDEE − 500   (≈0.5 kg/week deficit)
Maintain:       TDEE
Build Muscle:   TDEE + 250   (lean surplus)
Gain Weight:    TDEE + 500
```

### Macro Split (% of daily calories)
| Goal          | Protein | Carbs | Fat |
|---------------|---------|-------|-----|
| Lose Weight   | 35%     | 40%   | 25% |
| Maintain      | 25%     | 50%   | 25% |
| Build Muscle  | 30%     | 50%   | 20% |
| Gain Weight   | 25%     | 55%   | 20% |

### Grams from calories
- Protein: 4 kcal/g → grams = (calories × protein%) / 4
- Carbs: 4 kcal/g → grams = (calories × carbs%) / 4
- Fat: 9 kcal/g → grams = (calories × fat%) / 9

Round all final displayed values to the nearest whole number.

---

## File Structure

```
lib/
  main.dart                     — app entry, theme, routing
  models/
    user_profile.dart           — holds weight, height, age, sex, goal, activity
    macro_result.dart           — holds BMR, TDEE, calories, protein_g, carbs_g, fat_g
  services/
    macro_calculator.dart       — pure functions: calculateBMR, calculateTDEE, calculateMacros
  screens/
    welcome_screen.dart
    goal_screen.dart
    profile_screen.dart
    activity_screen.dart
    results_screen.dart
  widgets/
    calo_app_bar.dart           — reusable top bar with back + headphones
    selectable_card.dart        — reusable card for goal/activity selection
    number_input.dart           — reusable +/- number input
    primary_button.dart         — reusable green bottom button
    macro_bar.dart              — horizontal stacked bar for macros
  theme/
    app_colors.dart             — color constants
    app_text_styles.dart        — typography constants
```

State management: simple — pass the `UserProfile` object forward through Navigator route arguments. No Provider/Riverpod/Bloc needed for a 5-screen flow.

---

## Implementation Notes

- Use `google_fonts` package for Inter font
- Use Flutter's built-in `Navigator` with named routes or push/pop with arguments
- All emojis: use as plain text characters in `Text` widgets (no asset images)
- Keep all calculation logic in `services/macro_calculator.dart` as pure functions — easy to unit test, easy to point to in the README as "look, real logic"
- Add at least 3 unit tests in `test/macro_calculator_test.dart` covering: BMR for male, BMR for female, full pipeline for a known input
- Make the results screen screenshot-friendly — it's what will appear in the GitHub README

---

## README Requirements (for the GitHub repo)

The README should include:
1. **Header** — project name, one-line description, screenshot of the results screen
2. **Why I built this** — short paragraph: portfolio piece for a Calo internship application, demonstrates Flutter UI work and nutrition algorithm implementation
3. **Features** — bullet list of what it does
4. **Calculation methodology** — Mifflin-St Jeor reference + brief explanation of macro splits
5. **How I built it** — honest note: scaffolded with Claude Code, then refined manually. Mention what you customized or fixed.
6. **Run instructions** — `flutter pub get` + `flutter run`
7. **Screenshots** — all 5 screens
8. **What I'd do next** — short list of improvements (saving history, comparing meals against targets, sex/age refinement, etc.) — shows you can think beyond the demo

---

## Definition of Done

- All 5 screens build and navigate correctly
- Calculations produce sensible numbers (sanity-check: 25-year-old male, 75kg, 175cm, lightly active, build muscle → ~2,800 kcal/day, ~210g protein)
- Visual design matches Calo's screenshots within reasonable margin
- App runs on iOS simulator and Android emulator without errors
- Unit tests pass
- README is complete with screenshots
- Repo is public on GitHub with a clean commit history

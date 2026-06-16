# Flutter Project Guidelines

## Architecture

* State Management: Bloc
* Routing: GoRouter
* Dependency Injection: GetIt
* Theme System: AppTheme

Always follow the existing architecture.
Do not introduce alternative patterns unless explicitly requested.

---

# Reusable Components

## Buttons

Use existing button components only.

* PrimaryButton
  path: `lib/core/base/components/primary_button.dart`
  variants:

  * filled
  * outlined
  * iconFilled
  * iconOutlined

* SecondaryButton
  path: `lib/core/base/components/secondary_button.dart`

* TertiaryButton
  path: `lib/core/base/components/tertiary_button.dart`

### Rules

* Never use ElevatedButton.
* Never create custom buttons if an existing button variant satisfies the requirement.
* Prefer extending existing button variants over creating new button components.

---

## Text

Use:

* PrimaryText
* AppTextStyles

paths:

* `lib/core/base/components/primary_text.dart`
* `lib/core/base/themes/app_text_style.dart`

### Rules

* Never use Text directly.
* Never hardcode TextStyle.
* Always use predefined styles from AppTextStyles.
* Only introduce new text styles when absolutely necessary.

---

## Input

Use:

* PrimaryTextField

path:

* `lib/core/base/components/primary_text_field.dart`

### Rules

* Reuse existing input widgets whenever possible.
* Avoid creating duplicated form field implementations.

---

## Colors

Use:

* AppColors

path:

* `lib/core/base/themes/app_colors.dart`

### Rules

* Never hardcode colors.
* Never use Color(0x...) directly in UI.
* Add new colors into AppColors if required.

---

## Spacing & Dimensions

Use:

* AppSpacing.vertical(...)
* AppSpacing.horizontal(...)

path:

* `lib/core/base/themes/app_spacing.dart`

### Rules

* Never hardcode spacing values.
* Prefer spacing utilities over SizedBox(height: xx).
* Icon sizes should prioritize predefined values from AppDimensions.
* Only introduce new dimension constants if reused multiple times.

---

## Containers & Cards

Use:

### PrimaryFrame

path:

`lib/core/base/components/primary_frame.dart`

Use as the default replacement for Container.

### PrimaryCard

path:

`lib/core/base/components/primary_card.dart`

Use for elevated and interactive card-like surfaces.

### Rules

* Avoid using raw Container unless absolutely necessary.
* Prefer PrimaryFrame for basic layouts.
* Prefer PrimaryCard for tappable cards.

---

## Pressable Widgets

Use:

* PrimaryAnimatedPressableWidget

path:

`lib/core/base/components/primary_animated_pressable_widget.dart`

### Rules

* Reuse this component for touch feedback.
* Avoid duplicating animation behaviors.

---

## App Bar

Use:

* PrimaryAppBar

path:

`lib/core/base/components/primary_app_bar.dart`

### Rules

* Avoid custom AppBar implementations unless required by a unique design.

---

# List Rules

* Prefer ListView.separated() over ListView.builder().
* Use reusable list item widgets.
* Separate item widgets into their own files.
* Support empty states when appropriate.

---

# Bloc Guidelines

All states must use Bloc.

## State

* Use a single State class per Bloc.
* State must use freezed.
* Store all UI-related data inside the State.
* Update state using copyWith.

## Event

* Create an abstract Event base class.
* Implement separate subclasses for each event.

Example:

abstract class ExampleEvent {}

class InitEvent extends ExampleEvent {}

class RefreshEvent extends ExampleEvent {}

## Bloc

* Register Bloc as @lazySingleton.
* Retrieve Bloc using getIt.get().
* Never use BlocProvider.
* Expose public methods inside Bloc.

Example:

bloc.init();
bloc.refresh();

Do NOT trigger events directly from UI:

❌ bloc.add(...)

Use:

✅ bloc.init();
✅ bloc.refresh();

Internally, those methods may dispatch events.

## UI

* UI should remain as dumb as possible.
* Business logic belongs inside Bloc.
* Avoid placing decision-making logic inside Widgets.

---

# Widget Structure

* Keep Widgets small and focused.
* Extract reusable sections into separate files.
* Prefer composition over large monolithic Widgets.
* Avoid files with excessive line counts.
* Avoid Widgets with too many parameters.
* Group related Widgets under feature folders.

## Widget Independence Rules

* Widgets should be as independent as possible.
* Minimize constructor parameters.
* Do not pass Bloc or State objects through widget trees.
* Widgets should retrieve their own Bloc instances via `getIt.get()` when appropriate.
* Avoid passing entire state objects.
* Only pass the minimal data required.
* Prefer selecting the exact state needed within the widget itself.
* Avoid excessive callback forwarding.
* Re-evaluate widget boundaries when parameter counts become large.
* Favor maintainability and low coupling over convenience.

Target guideline:

* Prefer files under ~300 lines.
* Refactor large screens into smaller components.

---

# Localization

All user-facing strings must support localization.

Rules:

* Never hardcode display strings.
* Define translations in `vi.json`.
* Use key-based translations.

Example:

vi.json:

{
"medical_history": "Lịch sử khám"
}

UI:

"medical_history".tr()

* Translation keys should be descriptive and reusable.
* Prefer snake_case naming.

---

# Mock Data Guidelines

For prototype features:

* Use mock models and mock data.
* Simulate interaction flows only.
* Do not implement APIs unless requested.
* Keep the UI production-ready while using fake data.

---

# Performance Guidelines

Prefer immutable and compile-time constants.

## Const Usage

* Always use `const` whenever possible.
* Prefer const constructors.
* Prefer const Widgets.
* Prefer const collections.
* Prefer extracting repeated const widgets.

Examples:

✅ const SizedBox()
✅ const Icon(...)
✅ const PrimaryText(...)
✅ const EdgeInsets.all(...)

Avoid:

❌ creating identical non-const widgets repeatedly.

Only omit `const` when values depend on runtime data.

## Rebuild Optimization

* Minimize unnecessary widget rebuilds.
* Extract frequently rebuilt areas into dedicated Widgets.
* Avoid rebuilding large widget trees unnecessarily.
* Keep build methods lightweight.

---

# Code Reuse Principles

Before creating anything new:

Ask yourself:

1. Does a similar implementation already exist?
2. Can an existing component be reused?
3. Can an existing Bloc be extended?
4. Can an existing style satisfy the requirement?

Priority order:

Reuse Existing
→ Extend Existing
→ Create New

Avoid duplicate implementations.

---

# Before Submitting Changes

Always:

* Run `flutter analyze`.
* Fix newly introduced issues.
* Remove unused imports.
* Remove dead code.
* Verify localization keys exist.
* Ensure the implementation follows these guidelines.
* Summarize modified files and explain the reason for each change.

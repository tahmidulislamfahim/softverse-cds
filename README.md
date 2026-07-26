# Softverse CDS

A Flutter app for Softverse's **Customer Display System (CDS)** — the customer-facing
screen that pairs with a POS terminal and mirrors the current order, bill breakdown,
and payment status in real time.

Built with **GetX** for state management/routing and **flutter_screenutil** for
responsive sizing.

## App flow

```
Splash  →  Pair  →  CDS Home
```

- **Splash** — logo screen, then automatically forwards to Pair after a short delay.
- **Pair** — lets the device pair to a POS as **Softverse CDS** (shows device name / IP
  for pairing).
- **CDS Home** — the main display. It's a single screen driven by connection/order
  state (`CdsConnectionState` in `CdsHomeController`), covering three states:
  - **active** — order banner, bill amounts (subtotal/tax/total/change), and the
    purchase-item list
  - **idle** — same layout with placeholder dashes/zeros while waiting for the next
    order
  - **disconnected** — a "Currently Disconnected" prompt with a **Reconnect** action

> `lib/features/home/` is the original GetX/counter starter screen. It's still in the
> codebase but isn't part of the current navigation flow above.

## Tech stack

| | |
|---|---|
| State management / routing | [get](https://pub.dev/packages/get) (GetX) |
| Responsive sizing | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) |
| Fonts | [google_fonts](https://pub.dev/packages/google_fonts) |
| Icons | [iconsax_flutter](https://pub.dev/packages/iconsax_flutter) |
| Local storage | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Networking | [http](https://pub.dev/packages/http) |
| Env config | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |
| Loading states | [skeletonizer](https://pub.dev/packages/skeletonizer) |

## Project structure

```
lib/
  core/
    bindings/        # ControllerBinder — registers every GetxController
    common/
      styles/        # getTextStyle(...) — the one place text styles are built
      widgets/       # Reusable, cross-feature widgets (buttons, fields, cards, gauges...)
    controller/      # App-wide controllers (e.g. ThemeController)
    models/          # Shared models
    services/        # StorageService, NetworkCaller, ...
    utils/
      constants/     # AppColors, API constants — single source of truth for colors
      theme/         # Light/dark ThemeData + AppColorsExtension
      helpers/
  features/
    <feature_name>/
      controller/    # GetxController(s) for this feature
      views/screens/ # Routed screens
      widgets/       # Widgets used only by this feature
      models/        # Models used only by this feature
  routes/
    app_routes.dart  # Route name constants + GetPage list
  app.dart           # GetMaterialApp, ScreenUtilInit, theme wiring
  main.dart          # Entry point (env load, storage init, system UI)
```

Every screen/widget is a `StatelessWidget`; state lives in a `GetxController` and is
consumed via `Obx` / `GetX<T>` / `GetView<T>`. Colors are never hardcoded inline —
they're declared once in `AppColors` (`lib/core/utils/constants/colors.dart`) or, for
light/dark-aware values, in `AppColorsExtension` and accessed via `context.appColors`.

Full conventions for adding new features live in [`.claude/CLAUDE.md`](.claude/CLAUDE.md).

## Getting started

**Prerequisites:** Flutter SDK (Dart ^3.11.1) and a configured iOS/Android toolchain.

```bash
# 1. Install dependencies
flutter pub get

# 2. Set up environment variables
cp .env.example .env   # then fill in BASE_URL, etc.

# 3. Run
flutter run
```

### Verifying changes

```bash
flutter analyze   # static analysis
flutter test      # unit/widget tests
```

## Environment variables

Config is loaded from a `.env` file at the project root via `flutter_dotenv` (see
`main.dart`). At minimum it defines:

```
BASE_URL=...
```

`.env` is not committed — copy it from whoever owns the project config before running.

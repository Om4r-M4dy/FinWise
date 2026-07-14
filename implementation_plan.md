# Implementation Plan - Fix Onboarding Stuck Issue

This plan addresses the issue where running the application gets stuck on the onboarding screen or behaves responsively stuck on launch.

## Proposed Changes

We identified that `DevicePreview` is wrapped around the application in debug mode but is not correctly integrated into `MaterialApp.router` in `lib/main.dart`. Without setting `useInheritedMediaQuery: true`, `locale: DevicePreview.locale(context)`, and chaining `builder` with `DevicePreview.appBuilder`, the app frame does not scale correctly, does not accept touch inputs properly, and can render as a frozen/black screen.

We also propose to make the PageView children in the onboarding flow dynamically list `onBoardingPages` instead of hardcoding.

---

### main.dart

#### [MODIFY] [main.dart](file:///c:/Users/eedf4/Programing/Programing%20Disk%20Top/Practice/Flutter/FinWise/lib/main.dart)

Integrate `DevicePreview` correctly into `MaterialApp.router` in `MainApp`:
- Add `useInheritedMediaQuery: true`
- Set `locale: DevicePreview.locale(context)`
- Chain `DevicePreview.appBuilder` within the custom `builder` function.

---

### on_boarding.dart

#### [MODIFY] [on_boarding.dart](file:///c:/Users/eedf4/Programing/Programing%20Disk%20Top/Practice/Flutter/FinWise/lib/features/on_boarding/page/on_boarding.dart)

Dynamically generate `PageView` children based on the `onBoardingPages` list to make it robust and extensible:
- Replace `children: [buildPageContent(0), buildPageContent(1)]` with `children: List.generate(onBoardingPages.length, (index) => buildPageContent(index))`

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure there are no compilation or syntax errors.

### Manual Verification
- Launch the application on simulated/target device and verify that the onboarding screen renders correctly inside `DevicePreview`.
- Swiping through the onboarding pages works smoothly.
- Tapping "Next" and "Get Started" transitions successfully to the Auth choice screen.

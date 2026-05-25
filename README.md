<div align="center">
  <br/>
  <img src="assets/logo/logo.svg" alt="FamilySide Logo" width="120"/>
  <br/>
  <br/>

# FamilySide

### A Family-Oriented Discovery & Lifestyle Platform

Connecting parents with local child-friendly services, activities, events, and gift ideas — while empowering service providers to reach the right audience.

<br/>

![Flutter](https://img.shields.io/badge/Flutter-3.41-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Linux%20%7C%20Windows-brightgreen)
![State Management](https://img.shields.io/badge/State-Riverpod-764ABC?logo=riverpod)
![License](https://img.shields.io/badge/License-Proprietary-red)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Features](#features)
  - [For Families (Parents)](#for-families-parents)
  - [For Service Providers](#for-service-providers)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Run](#run)
  - [Build](#build)
  - [Test](#test)
- [Configuration](#configuration)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**FamilySide** is a dual-role cross-platform application built with Flutter that bridges the gap between families seeking enriching local experiences and the service providers who offer them. The platform features two distinct interfaces:

- **👨‍👩‍👧‍👦 Family Mode** — Parents discover and book activities, events, and gifts for their children, manage child profiles, and receive personalized recommendations.
- **🏪 Provider Mode** — Local businesses and service providers create and manage their listings, track engagement through analytics, and handle subscriptions and payments.

---

## Screenshots

<!-- Replace with actual screenshots -->
<!--
<div align="center">
  <img src="screenshots/onboarding.png" width="200" alt="Onboarding"/>
  <img src="screenshots/home.png" width="200" alt="Home Feed"/>
  <img src="screenshots/explorer.png" width="200" alt="Explorer"/>
  <img src="screenshots/provider_home.png" width="200" alt="Provider Dashboard"/>
</div>
-->

---

## Features

### For Families (Parents)

| Feature | Description |
|---|---|
| **Onboarding** | 4-page carousel with parallax effects and role selection (Parent / Provider) |
| **Authentication** | Email/password sign-in & sign-up, OTP verification, social login (Apple / Google), forgot/reset password |
| **Child Profiles** | Add multiple children (name, DOB, gender), "Expecting" option with due date, interest tags, photo upload |
| **Home Feed** | Category filter chips (Health, Schools, Events, Outdoor, Sports), recommended items carousel, events near you, sub-category grid |
| **Explorer** | 3-tab browsing (Activities, Events, Gifts) with filtering, search bar, and map toggle |
| **Gift Management** | Browse gifts, create & manage gift lists, bookmark favorites, share via gift cards |
| **Interactive Map** | Google Maps integration showing nearby activities, events, and gift locations |
| **Search** | Quick-access categories and full-text browse |
| **Notifications** | Grouped notification center (Today, This Week, Last Month) |
| **Profile & Settings** | Profile stats, reviews, edit profile, change password, child info management, privacy policy, contact support, suggestions, logout |

### For Service Providers

| Feature | Description |
|---|---|
| **Dashboard** | Overview of upcoming events and activities as card-based listings |
| **Create Listings** | Create activities (photo, location, category, tags), events, and gifts with rich form inputs |
| **Manage Listings** | Edit or delete existing listings with bottom sheets and confirmation dialogs |
| **Analytics** | Interactive charts and metrics for listing performance (`fl_chart`) |
| **Profile** | Edit business profile, change password, subscription plans, payment management |
| **Support** | In-app privacy policy, contact support, suggestions form |

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Language** | [Dart](https://dart.dev/) ^3.11.3 |
| **Framework** | [Flutter](https://flutter.dev/) (v3.41.5, managed via FVM) |
| **State Management** | [Riverpod](https://riverpod.dev/) (`flutter_riverpod`) |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) ^17.2.3 |
| **Responsive UI** | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) ^5.9.3 (design base: 440×956) |
| **Maps** | [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) ^2.17.0 + [geolocator](https://pub.dev/packages/geolocator) |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) ^0.70.2 |
| **Image Handling** | image_picker, image_cropper, photo_view, cached_network_image, flutter_image_compress, wechat_assets_picker |
| **SVG** | [flutter_svg](https://pub.dev/packages/flutter_svg) ^2.3.0 |
| **Local Storage** | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| **OTP** | [pinput](https://pub.dev/packages/pinput) ^6.0.2 |
| **Environment** | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) |
| **Typography** | Poppins (18 weights) + Quando (display) |
| **UI Extras** | dotted_border, cupertino_icons |

---

## Architecture

FamilySide follows a **feature-first folder structure** with a clear separation of concerns between the two user roles.

### Data Flow

```
UI (Screens/Widgets)
    ↕ Riverpod Providers
    ↕ (Future: API Service Layer)
    ↕ (Future: REST Backend)
```

Currently the app operates as a **frontend-only prototype** — all data is hardcoded/mocked within the screens. The placeholder `ApiConstant` class in `lib/core/constants/` is ready to be wired to a backend.

### Routing

GoRouter handles navigation with ~50 defined routes. The flow starts at:

1. **`/`** → Splash screen
2. **Onboarding** → 4-page carousel
3. **Role Selection** → Family or Service Provider
4. Each role has its own auth flow and shell navigation (bottom tabs)

Route configuration objects are passed via `state.extra` for typed parameters between screens.

---

## Project Structure

```
familyside/
├── android/                        # Android platform (Kotlin DSL)
├── ios/                            # iOS platform (Swift)
├── web/                            # Web platform
├── macos/                          # macOS platform (Swift)
├── linux/                          # Linux platform (C++/CMake)
├── windows/                        # Windows platform
├── assets/
│   ├── fonts/
│   │   ├── Poppins/                # 18 font weight variants
│   │   └── Quando/                 # Quando-Regular.ttf
│   ├── icon/                       # SVG icons
│   ├── image/                      # Onboarding images, illustrations
│   └── logo/                       # App logos and icons (SVG)
├── lib/
│   ├── main.dart                   # App entry point (ProviderScope)
│   ├── env.dart                    # Environment variable accessor
│   ├── core/
│   │   ├── router/                 # GoRouter config & route paths
│   │   ├── theme/                  # AppColors, AppTheme (light/dark)
│   │   └── constants/              # API constants (reserved for backend)
│   ├── model/                      # Data models (onboarding, gift_item, search_data)
│   ├── provider/                   # Riverpod state providers
│   ├── utils/                      # Utilities (form_validator, image_picker, image_viewer)
│   ├── view/
│   │   ├── onboarding/             # Splash + onboarding carousel
│   │   ├── family/
│   │   │   ├── auth/               # Login, signup, OTP, forgot/reset password
│   │   │   ├── home/               # Home feed, recommendations, sub-categories
│   │   │   ├── explorer/           # Tabbed browsing (activities/events/gifts), map, details
│   │   │   ├── search/             # Search with quick-access and browse categories
│   │   │   ├── gift/               # Gift browsing, gift lists, gift details
│   │   │   ├── notification/       # Grouped notification center
│   │   │   └── profile/            # Profile, settings, child info, support
│   │   └── service_provider/
│   │       ├── auth/               # Login, signup, OTP, forgot/reset password
│   │       ├── home/               # Provider dashboard with event listings
│   │       ├── create_section/     # Create activities, events, gifts
│   │       ├── manage/             # Manage existing listings (edit/delete)
│   │       ├── analytics/          # Charts and analytics
│   │       └── profile/            # Profile, subscriptions, payments, support
│   └── widgets/                    # 13 shared reusable widgets
├── test/                           # Widget tests
├── .env                            # Environment variables
├── .fvmrc                          # Flutter version pin (3.41.5)
├── analysis_options.yaml           # Lint rules
├── pubspec.yaml                    # Dependencies & project config
└── README.md
```

---

## Getting Started

### Prerequisites

- **Flutter SDK** ^3.11.3 (see `.fvmrc`; [FVM](https://fvm.app/) recommended)
- **Dart SDK** ^3.11.3
- A **Google Maps API Key** with the Maps SDK enabled
- An IDE (VS Code, Android Studio, or IntelliJ)

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/familyside.git
cd familyside

# If using FVM, set the correct Flutter version
fvm use

# Install dependencies
flutter pub get

# Configure environment variables
cp .env.example .env
# Edit .env and add your Google Maps API key:
# GOOGLE_MAPS_API_KEY=your_api_key_here
```

### Run

```bash
# Run on a connected device or emulator
flutter run

# Run on a specific platform
flutter run -d chrome          # Web
flutter run -d ios             # iOS Simulator
flutter run -d android         # Android Emulator
```

### Build

```bash
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build ios              # iOS (requires macOS + Xcode)
flutter build web              # Web (HTML renderer)
flutter build macos            # macOS
flutter build linux            # Linux
flutter build windows          # Windows
```

### Test

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## Configuration

All environment variables are managed via `.env` files and loaded at runtime using `flutter_dotenv`.

| Variable | Required | Description |
|---|---|---|
| `GOOGLE_MAPS_API_KEY` | ✅ Yes | Google Maps API key for map rendering and geolocation |

---

## Roadmap

- [ ] **Backend API integration** — Replace mocked data with REST API responses
- [ ] **Real authentication** — Wire up Firebase/Auth0 for production auth
- [ ] **Push notifications** — Firebase Cloud Messaging integration
- [ ] **Booking & payments** — In-app booking flow and payment gateway
- [ ] **Reviews & ratings** — User review system for providers and listings
- [ ] **Localization** — Multi-language support
- [ ] **CI/CD pipeline** — Automated builds and testing
- [ ] **End-to-end tests** — Integration and smoke test suites

---

## Contributing

This project is currently in active development. Contributions, issues, and feature requests are welcome.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the project's linting rules (`flutter analyze` passes with no issues).

---

## License

Proprietary. All rights reserved. This project is not open-source and should not be published to public registries.

---

<div align="center">
  Built with ❤️ for families and local communities
  <br/>
  <a href="mailto:support@familyside.app">Contact Support</a>
</div>

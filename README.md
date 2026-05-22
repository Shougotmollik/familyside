# FamilySide

A family-oriented discovery and lifestyle platform that helps parents find local services, activities, events, and gift ideas for their children.

## Features

- **Onboarding** — 4-page intro carousel with role selection (Parent / Service Provider)
- **Authentication** — Sign in, sign up, OTP verification, social login (Apple/Google), forgot password flow
- **Child Profiles** — Add multiple children with name, DOB, gender; interest selection and photo upload
- **Home Feed** — Category filters (Health, Schools, Events, Outdoor, Sports), recommended items, events near you, sub-category browsing
- **Explorer** — Tabbed browsing of activities, events, and gifts with map view and filtering
- **Gift Management** — Browse gifts, create gift lists, bookmark, share, and add to lists
- **Interactive Map** — Google Maps integration for discovering family-friendly places nearby
- **Notifications** — Grouped notification center (Today, This Week, Last Month)
- **Profile** — Stats, reviews, settings (edit profile, change password, child info, privacy, support)

## Tech Stack

| Technology | Usage |
|---|---|
| **Flutter / Dart** | Cross-platform UI framework |
| **Riverpod** | State management |
| **GoRouter** | Declarative routing |
| **flutter_screenutil** | Responsive sizing (440×956 design) |
| **Google Maps Flutter** | Map integration |
| **flutter_svg** | SVG asset rendering |
| **cached_network_image** | Image caching |
| **image_picker / image_cropper** | Photo capture and editing |
| **shared_preferences** | Local persistence |
| **Poppins + Quando** | Typography |

## Getting Started

### Prerequisites

- Flutter SDK ^3.11.3
- Dart SDK ^3.11.3

### Setup

```bash
# Clone the repository
git clone https://github.com/your-org/familyside.git
cd familyside

# Install dependencies
flutter pub get

# Set up environment variables
cp .env.example .env
# Add your Google Maps API key to .env:
# GOOGLE_MAPS_API_KEY=your_key_here

# Run the app
flutter run
```

### Build

```bash
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── router/                  # GoRouter config & route paths
│   └── theme/                   # Colors, ThemeData (light/dark)
├── model/                       # Data models
├── provider/                    # Riverpod state providers
├── utils/                       # Form validators, image utilities
└── view/
    ├── onboarding/              # Splash & onboarding screens
    ├── family/
    │   ├── auth/                # Login, signup, forgot password
    │   ├── home/                # Home feed, recommendations
    │   ├── explorer/            # Explorer tabs & map
    │   ├── search/              # Search screen
    │   ├── gift/                # Gift browsing & lists
    │   ├── notification/        # Notifications
    │   └── profile/             # Profile & settings
    └── widgets/                 # Shared reusable widgets
provider/                       # Riverpod state providers
    └── child_info_provider.dart # Child info form state
```

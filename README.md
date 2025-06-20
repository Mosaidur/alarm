Alarm App
A Flutter-based mobile application designed for a job interview task assessment. The app features onboarding screens, location permission handling, and alarm/notification functionality, built according to the provided Figma design.
Project Overview
The Alarm App guides users through an onboarding process, requests location permissions, and allows users to set and manage alarms with notifications. The app is built with clean architecture, responsive UI, and proper state management, following the design specifications provided.
Features

Onboarding Screens: Three screens introducing the app's concept (syncing with nature, effortless syncing, and relaxation).
Location Access: Requests and displays the user's location after onboarding.
Alarm Setting: Allows users to set alarms with a time and date picker, displaying a list of alarms.
Notifications: Uses flutter_local_notifications to trigger notifications when alarms go off.
Responsive UI: Adapts to various screen sizes with a pixel-perfect implementation of the Figma design.
Error Handling: Gracefully handles permissions and errors.

Project Setup Instructions

Prerequisites:

Flutter SDK (version 3.22.2 or later)
Dart (version 3.4.3 or later)
Android Studio or VS Code with Flutter plugins
A device/emulator with Android or iOS


Clone the Repository:
git clone https://github.com/Mosaidur/alarm.git
cd alarm


Install Dependencies:Run the following command to install all required packages:
flutter pub get


Run the App:Connect a device or emulator and run:
flutter run


Build APK:To generate an APK:
flutter build apk --release

The APK can be found in build/app/outputs/flutter-apk/app-release.apk.


Tools and Packages Used

Flutter: Framework for building the cross-platform app.
flutter_local_notifications: For scheduling and displaying local notifications.
geolocator: For requesting and fetching user location.
provider: For state management.
intl: For formatting date and time.
shared_preferences (optional): For local storage of alarms.
flutter_datetime_picker: For the time and date picker widget.

Screenshots
Below are some screenshots of the app:

Onboarding Screen 1:
Onboarding Screen 2:
Onboarding Screen 3:
Location Screen:
Alarm Setting Screen:

APK and Demo Video

APK: Download the release APK from Google Drive.
Demo Video: Watch the app in action via the demo video in the same Google Drive folder.

Folder Structure
alarm/
├── android/                    # Android-specific files
├── ios/                        # iOS-specific files
├── lib/                        # Main source code
│   ├── models/                 # Data models
│   ├── screens/                # UI screens (onboarding, location, alarm)
│   ├── widgets/                # Reusable UI components
│   ├── services/               # Services (location, notifications)
│   ├── providers/              # State management
│   └── main.dart               # App entry point
├── assets/                     # Images and other static assets
├── test/                       # Unit and widget tests
├── pubspec.yaml                # Dependencies and configuration
└── README.md                   # This file

Notes

The app follows the Figma design provided: Figma Link.
Clean architecture principles are followed with separation of concerns (UI, business logic, and data).
The app handles edge cases like permission denials and invalid inputs.
Local storage is implemented using shared_preferences for simplicity (optional feature).

Feedback
For any feedback or questions, please reach out via the submission form: Google Form.
Thank you for reviewing my submission! 🚀

# Taskify – Smart Task Manager

A Flutter task management app built for Week 6 of my Flutter Developer Internship. The main focus was migrating from `setState` to **Riverpod** for state management, integrating Firebase as a real-time backend, and shipping something that actually looks and feels like a proper app.

---

## What It Does

Taskify lets you create, prioritize, complete, and delete tasks — with everything synced to Firebase in real time. Filter by status, get daily reminders via local notifications, and receive push alerts through FCM. The UI updates instantly with no page reloads or manual refreshes.

---

## Features

**Task Management**
- Add tasks with a title, description, and priority (High / Medium / Low)
- Mark complete, delete, or swipe to dismiss
- Filter by All, Pending, or Completed
- Live pending and completed counters on the dashboard

**State Management**
- Fully migrated from `setState` to Riverpod
- Business logic lives in providers, screens only listen and render
- Real-time UI updates via `ConsumerWidget`

**Firebase**
- Realtime Database for cloud sync across sessions
- Firebase Cloud Messaging for push notifications

**Notifications**
- Daily task reminders via `flutter_local_notifications`
- Scheduled productivity alerts

**UI & Animations**
- Material 3 with Poppins font and a purple (`#6C63FF`) theme
- Animated splash screen with fade and scale transitions
- `AnimatedList` for task additions and removals
- `AnimatedSwitcher` on live counters
- Swipe-to-delete with `Dismissible`
- Strikethrough animation on task completion

---

## Screenshots

(<img width="1080" height="2436" alt="1000127598" src="https://github.com/user-attachments/assets/b1e22d0d-59b3-47cb-8c94-44b8e1eef5be" />
)
(<img width="1080" height="2436" alt="1000127600" src="https://github.com/user-attachments/assets/f6651636-4814-4385-91a0-50f466c0fd58" />
) 
(<img width="1080" height="2436" alt="1000127601" src="https://github.com/user-attachments/assets/c5744074-0905-4c58-9528-5aff24858626" />
) 
(<img width="1080" height="2436" alt="1000127599" src="https://github.com/user-attachments/assets/ac338fc7-7efd-4261-97ce-f213518906e8" />
) 

---

## Demo

https://github.com/user-attachments/assets/af1732aa-397b-4bee-be13-e5a69f2898d7

---

## Tech Stack

| What | Why |
|------|-----|
| Flutter + Dart | Cross-platform UI |
| Riverpod | State management |
| Firebase Realtime Database | Cloud sync |
| Firebase Cloud Messaging | Push notifications |
| `flutter_local_notifications` | Scheduled reminders |
| Google Fonts (Poppins) | Typography |
| `intl` | Date and time formatting |

---

## Project Structure

```
lib/
├── models/
│   └── task_model.dart              # Task data class with priority and status
├── providers/
│   └── task_provider.dart           # All state logic — add, delete, toggle, filter
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   └── add_task_screen.dart
├── services/
│   ├── firebase_service.dart        # Realtime Database read/write
│   └── notification_service.dart    # FCM + local notification setup
├── widgets/
│   ├── task_card.dart
│   ├── empty_state.dart
│   └── custom_button.dart
├── utils/
│   └── app_theme.dart               # Material 3 theme and color constants
└── main.dart
```

---

## Firebase Setup

**1.** Create a project at [console.firebase.google.com](https://console.firebase.google.com) and enable **Realtime Database** and **Cloud Messaging**.

**2.** Register your Android app with package name `com.example.taskify`, download `google-services.json`, and place it in `android/app/`.

**3.** Set Realtime Database rules for authenticated access:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```

---

## Running the App

```bash
git clone https://github.com/yourusername/taskify.git
cd taskify
flutter pub get
flutter run
```

Make sure `google-services.json` is in place before running.

---

## Dependencies

```yaml
dependencies:
  flutter_riverpod:
  firebase_core:
  firebase_database:
  firebase_messaging:
  flutter_local_notifications:
  google_fonts:
  intl:
```

---

## What I Learned

The biggest shift this week was understanding *why* Riverpod exists. Once the app had multiple screens all needing the same task list, passing state around with `setState` became messy fast. Riverpod solved that cleanly — providers hold the data, screens just watch it.

A few other things that clicked:
- `ConsumerWidget` vs `StatefulWidget` — knowing when to use each
- Structuring Firebase Realtime Database vs Firestore and why the data model matters
- Local notifications need careful setup on Android (channels, permissions, background handlers)
- Animations are a lot smoother when the state layer is clean — `AnimatedList` worked great once Riverpod was handling the list properly

---

## About

Built by **Syed Mohsin Raza** — Week 6 task for a Flutter Developer Internship.

---

## License

Created for educational and internship purposes.

# 🏋️‍♂️ Fitness-App

A SwiftUI-based iOS fitness application that allows users to track workouts, view leaderboards, and monitor progress using real-time location tracking and Firebase integration.

## 📱 Features

- **User Authentication:** Login/signup flow with Firebase Authentication.
- **Workout Tracking:** Log workouts with type, duration, and date.
- **Exercise Listing:** Fetch exercises from a public API.
- **Run Tracking:** Self-run map tracking using GPS and `MapKit`.
- **Leaderboard:** Real-time user leaderboard with Firebase Firestore backend.
- **Profile & Progress:** User profiles with avatars and progress overview.
- **Beautiful UI:** Custom tab navigation, themed assets, and icons.

## 🧱 Tech Stack

- **Language:** Swift 5
- **Framework:** SwiftUI
- **Backend:** Firebase (Authentication + Firestore)
- **Location Services:** CoreLocation, MapKit
- **API:** Custom `ExerciseAPI.swift` fetches public exercise data

## 🚀 Getting Started

### Prerequisites

- Xcode 13 or later
- Cocoapods (if any pods used)
- Firebase Project set up (download your `GoogleService-Info.plist`)

### Setup Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/RisheendraReddy/Fitness-App.git
   cd Fitness-App
   ```

2. **Open the Project:**
   - Open `FitnessApp1.xcodeproj` in Xcode.

3. **Firebase Setup:**
   - Ensure `GoogleService-Info.plist` is properly configured.
   - Set up Firebase in your Apple Developer account.
   - Enable authentication and Firestore in Firebase Console.

4. **Build & Run:**
   - Select a simulator or connect a physical device.
   - Press ⌘R to run.

## 📂 Project Structure

```
FitnessApp1/
├── AuthenticationView.swift
├── LoginView.swift
├── InitialView.swift
├── HomeView.swift
├── ProfileView.swift
├── Workout.swift
├── WorkoutLoggingView.swift
├── WorkoutVM.swift
├── ExerciseAPI.swift
├── ExerciseList.swift
├── ExerciseVM.swift
├── LeaderboardView.swift
├── LeaderboardVM.swift
├── MapViewSelfRunTracking.swift
├── RunStartStopVM.swift
├── FirebaseServices.swift
├── MainTab.swift
├── FitnessApp1App.swift
├── Assets.xcassets/
├── Info.plist
├── GoogleService-Info.plist
└── ...
```

## ✅ Testing

The project includes both unit and UI testing targets.

- Unit tests in `FitnessApp1Tests/`
- UI tests in `FitnessApp1UITests/`

## 👨‍💼 Author

- **Risheendra Reddy** – [Github Profile](https://github.com/RisheendraReddy)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

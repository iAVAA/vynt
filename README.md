# Vynt - Music Social Media App

Vynt is a dynamic social media application centered around music, allowing users to share their favorite tracks, discover new artists, and connect with fellow music enthusiasts. Built with Flutter, Vynt provides a seamless and engaging experience for music lovers.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Features
- **User Profiles:** Create and customize profiles showcasing your music tastes.
- **Music Sharing:** Share your favorite tracks and albums with your followers.
- **Discover Music:** Explore trending songs, playlists, and discover new artists.
- **Engagement:** Like, comment, and interact with posts from other users.
- **Notifications:** Stay updated with real-time notifications for likes and comments.
- **Firebase Integration:** Secure user authentication and data storage.


### Prerequisites
- Flutter SDK (version 3.24.4)
- Dart SDK
- Node.js
- Firebase CLI
- Android SDK
- Xcode (for iOS development)
- An IDE (like Android Studio or Visual Studio Code)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/vynt.git
2. Navigate to the project directory:
    ```bash
    cd vynt
3. Install the required dependencies:
    ```bash
    flutter pub get
4. Install Firebase CLI:
    ```bash
    npm install -g firebase-tools
5. Login to Firebase:
    ```bash
    firebase login

### Usage

1. Run the application:
    ```bash
    flutter run
2. Build the application for Android:

To build the APK you must modify the android/gradle.properties file and **modify** the following line:
```
org.gradle.java.home=YOUR_JAVA_HOME
```
Then you can build it for android.

### License
Copyright (C) Vynt - All Rights Reserved

This source code is protected under international copyright law. All rights are reserved by the copyright holders.

This file is confidential and intended only for authorized individuals who have received explicit permission from the copyright holders.

If you have found this file and do not possess the appropriate permissions, please contact the copyright holders immediately and delete this file from your system.
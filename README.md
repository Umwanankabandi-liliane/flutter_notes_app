# Flutter Notes App

A mini Flutter mobile app that allows users to sign up, log in, and manage notes using Firebase.

## Features

* Firebase Authentication (Email & Password)
* Cloud Firestore for storing user notes
* Full CRUD operations (Create, Read, Update, Delete)
* Clean architecture (Data, Domain, Presentation layers)
* State management using Cubit (flutter\_bloc)
* Snackbar feedback and loading indicators

## Folder Structure

* `lib/data`: Firebase and repository logic
* `lib/domain`: Service interfaces
* `lib/presentation`: UI, screens, and Cubits
* `lib/utils`: Helpers like snackbar utilities and dialogs

## How to Run

1. Clone the repo:
   `git clone https://github.com/Umwanankabandi-liliane/flutter_notes_app.git`

2. Navigate to the project folder:
   `cd flutter_notes_app`

3. Install dependencies:
   `flutter pub get`

4. Add your `google-services.json` file to `android/app`

5. Link Firebase:
   `flutterfire configure`

6. Run the app:
   `flutter run`

## Requirements

* Dart SDK compatible with the current dependencies
* Firebase project with Authentication and Firestore enabled
* Android emulator or device with minSdkVersion set to 23

## Note

Make sure to configure Firebase correctly. The `google-services.json` file must be placed inside `android/app`. This file is excluded from the repository for security reasons.




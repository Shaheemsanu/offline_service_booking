# 🛠️ Offline Service Booking App

A powerful Flutter application to manage offline service bookings such as electricians, plumbers, and other professionals. It provides robust local storage using SQLite, integrates Firebase Cloud Messaging for push notifications, and uses local notifications to remind users of upcoming bookings. Built using Domain-Driven Design (DDD) principles, BLoC state management, and layered architecture for scalability and maintainability.

---

## 📋 Table of Contents

- [🛠️ Offline Service Booking App](#️-offline-service-booking-app)
  - [📋 Table of Contents](#-table-of-contents)
  - [📌 Features](#-features)
  - [📦 Technologies \& Dependencies](#-technologies--dependencies)
  - [🏗️ Project Structure](#️-project-structure)

---

## 📌 Features

- 🧾 Manage a local list of service providers
- ➕ Add or delete service providers
- 📅 Schedule offline service bookings
- 🔔 Receive local notification reminders
- ☁️ Get push notifications via Firebase Cloud Messaging
- 📴 Fully functional offline with SQLite
- 🧱 Domain-Driven Design architecture
- 🧠 BLoC pattern for scalable state management
- 🧪 Unit, widget, and bloc tests included

---

## 📦 Technologies & Dependencies

| Purpose                | Packages Used |
|------------------------|----------------|
| **State Management**   | flutter_bloc, equatable, formz |
| **Local Database**     | sqflite, path, path_provider |
| **Push Notifications** | firebase_core, firebase_messaging |
| **Local Notifications**| flutter_local_notifications, timezone |
| **Dependency Injection** | get_it, injectable |
| **Code Generation**    | build_runner, json_serializable |
| **Testing**            | flutter_test, bloc_test, mocktail, mockito |

---

## 🏗️ Project Structure

lib/
│
├── app/                             # App-level configuration
│   └── app.dart                     # Root widget, route generation, and theme setup
│
├── main.dart                        # App entry point – runs the app and sets up DI
│
├── src/
│
│   ├── application/                 # Business logic layer (BLoC & state management)
│   │   ├── booking_list/            # Booking feature BLoC
│   │   │   ├── booking_list_bloc.dart   # Main logic for booking events → state
│   │   │   ├── booking_list_event.dart  # Events triggered by user/actions
│   │   │   └── booking_list_state.dart  # UI-reactive states (loading, loaded, error)
│   │   ├── provider_list/           # Service provider feature BLoC
│   │   │   ├── provider_list_bloc.dart   # Logic for provider events → state
│   │   │   ├── provider_list_event.dart  # Events like load/add/delete provider
│   │   │   └── provider_list_state.dart  # States: loading, loaded, error
│   │   └── core/
│   │       └── status.dart          # Enum or class defining common request statuses
│
│   ├── domain/                      # Abstract layer defining data contracts and models
│   │   └── core/
│   │       └── model/
│   │           ├── booking_model.dart    # Model class for a service booking
│   │           └── provider_model.dart   # Model class for a service provider
│
│   ├── infrastructure/             # Implementation of abstract domain logic
│   │   └── core/
│   │       ├── database_service.dart        # SQLite service for local CRUD operations
│   │       └── fcm_service/
│   │           ├── fcm_navigation_service.dart   # Handles navigation from FCM messages
│   │           ├── fcm_service.dart               # Handles Firebase Cloud Messaging setup
│   │           └── local_notification_service.dart # Manages local notifications (e.g., alerts)
│
│   └── presentation/               # UI layer (screens, widgets, and UI logic)
│       ├── view/
│       │   ├── booking_list_screen/
│       │   │   └── booking_list_screen.dart   # UI to list all service bookings
│       │   ├── home_screen/
│       │   │   └── home_screen.dart           # Landing screen with navigation
│       │   ├── splash_screen/
│       │   │   └── splash_screen.dart         # Intro screen with app logo/loading
│       │   └── widget/
│       │       ├── bottom_sheet.dart          # Reusable bottom sheet UI for actions
│       │       └── delete_button.dart         # Reusable delete button widget
│       └── core/                              # Reserved for shared UI helpers/styles

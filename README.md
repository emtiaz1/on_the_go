# On The Go - Mobile Application

**On The Go** is a Flutter-based mobile application designed to provide users with a seamless experience for managing their daily activities. The app includes features such as a newsfeed, live tracking, and user profile management, all powered by Firebase for backend services like authentication, Firestore database, and real-time updates.

---

## 📱 Features

### **User Authentication**
- Login and registration functionality using Firebase Authentication.
- Secure user authentication with email and password.

### **Newsfeed**
- Displays posts fetched from Firebase Firestore.
- Users can react to posts with emojis (like, angry, sad), updated in real-time.
- Posts include:
  - Content
  - Images
  - Tags
  - Location
  - User details

### **Live Tracking**
- Real-time location tracking using the `location` package.
- Displays the user's current location on a map via `flutter_map`.

### **User Profile**
- Users can view and edit their profile information.
- Profile data is stored and retrieved from Firebase Firestore.

### **Firebase Integration**
- **Firebase Authentication**: For user login and registration.
- **Firestore**: For storing posts, user data, and reactions.
- **Firebase Storage**: For saving user profile images.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Firebase project setup for Authentication, Firestore, and Storage.
- Android Studio or Xcode for building and testing the app.

### Installation
Clone the repository:
   ```bash
   git clone https://github.com/emtiaz1/on_the_go.git
   cd on_the_go```

🛠️ Technologies Used
Flutter: Cross-platform mobile app development.
Firebase: Backend services.
Firebase Authentication
Firebase Firestore
Firebase Storage
flutter_map: For map rendering and live location tracking.
location: For accessing real-time location data.

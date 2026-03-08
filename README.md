#  Kigali City Services & Places Directory
 Kigali City Services & Places Directory is a flutter mobile application that will help Kigali residents locate and navigate to essential public services as well as leisure and lifestyle locations such as hospitals, police stations, public libraries, utility offices, restaurants, cafés, parks, and tourist attractions.
 ## Features
 -**User Authentication**: Sign up, Log in, log out email verification using Firebase Authentication.
 
 -**CRUD Operations**: Create, Read, Update, Delete listings created by the authenticated user.
 
 -**Search & Filter**: Search for listings by name and filter results based on category.
 
 -**Map Intergration**: View location on the map with marks for  all location in your application.
 
 -**Navigation**: BottomNavigationBar with at all the following screens Directory, My Listings, Map, Settings.
 
 -**User listing**: Every user will manage the own listings separately.
 
 -**Settings**: It will show the authenticated user's profile information and include a toggle for enabling or disabling location-based notifications.

 ## State Management

 This application uses the provider as its state management. And the logic and UI are separated.

 -**Listing Provider**: Manages listing state, search and filter operations.
 
 -**Auth Service**: Handles authenticationstate.
 
 -**FireStore Service**: It is for all the Firestore Operations.

 ## Firestore Structure
 ### Collections
 
 ```
{
  uid: String,
  name: String,
  email: String
}
```

#### `services`
```
{
  name: String,
  category: String,
  address: String,
  contact: String,
  description: String,
  latitude: Double,
  longitude: Double,
  createdBy: String (User UID),
  timestamp: Timestamp
}
```

## Project Structure

```
lib/
├── models/
│   └── listing_model.dart          # Listing data model
├── providers/
│   └── listing_provider.dart       # State management for listings
├── screens/
│   ├── add_edit_listing_screen.dart
│   ├── detail_screen.dart
│   ├── directory_screen.dart
│   ├── kigali_directory.dart       # Main navigation
│   ├── login.dart
│   ├── map_view_screen.dart
│   ├── my_listings_screen.dart
│   ├── settings_screen.dart
│   ├── signup.dart
│   └── verify_email_screen.dart
├── services/
│   ├── auth_services.dart          # Authentication service
│   └── firestore_service.dart      # Firestore CRUD operations
├── firebase_options.dart
└── main.dart
```
## Setup Instructions
### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/Yvette334/kigali-services.git
   cd Kigali-services.kigali
   ```
2. Install dependecies
    ```bash
   flutter pub get
   ```
3. Run the app:
    ```bash
   flutter run
   ```
## Categories
-Hospital

-Police Station

-Library

-Restaurant

-Café

-Park

-Tourist Attraction

-other

## Navigation Structure
These are the BottomNavigation and their four main screens

1.**Directory**: Shows all the listings with search and filters.

2.**My listings**: manage and view the listings .

3.**Map**: Shows all the locations on the map.

4.**Settings**: View the profile and toggles.

## Key technologies
-**Flutter**: Cross-platform mobile framework

-**Firebase Authentication**: For user authentication with email verification

-**Cloud Firestore**: NoSQL database

-**Provider**: State management

-**Open Street Map**: Map Integration


   

 
 
 
 
 
 
 
 
 
 

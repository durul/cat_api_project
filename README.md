# Cat API Project Architecture

## 1. Data Management

### CatDataManager (`/lib/data/cat_data_manager.dart`)

The `CatDataManager` is the core component responsible for managing cat breed data and application state. It utilizes the Provider pattern for state management.

#### Key Features:
- Fetches cat breed data from the API
- Manages loading states and pagination
- Handles error scenarios
- Notifies listeners of data changes
- Supports offline data access

#### Main Methods:
- `getCatData()`: Fetches cat breeds, handles pagination
- `getCatSpecificData(String catId)`: Retrieves details for a specific breed
- `reloadBreeds()`: Refreshes the breed list

## 2. API Integration

### CatAPI (`/lib/api/cats_api.dart`)

The `CatAPI` class handles communication with the external Cat API.

#### Key Methods:
- `getCatBreeds()`: Fetches a list of cat breeds
- `getCatBreed(String breedId)`: Retrieves details for a specific breed

## 3. UI Components

### CatBreedsPage (`/lib/screens/cat_breeds.dart`)

Main screen displaying the list of cat breeds.

### CatInfo (`/lib/screens/cat_info.dart`)

Detailed view for a specific cat breed.

### BreedCard (`/lib/components/cat_breed_card.dart`)

Reusable widget for displaying individual breed information in a card format.

## 4. Offline Support

### Local Data Storage (`/assets/cats.json`)

A JSON file containing breed data for offline access.

## 5. Network Connectivity

### ConnectivityMonitor (`/lib/network/connectivity_monitor.dart`)

Monitors network status and notifies the app of connectivity changes.

### NoInternetScreen (`/lib/network/screens/no_internet_screen.dart`)

Displayed when there's no internet connection, providing a retry option.

## 6. Project Configuration

### pubspec.yaml

Defines project dependencies, assets, and Flutter-specific configurations.

## Data Flow

1. The UI requests data through the `CatDataManager`.
2. `CatDataManager` checks network connectivity using `ConnectivityMonitor`.
3. If online, it fetches data from the API using `CatAPI`.
4. If offline, it loads data from the local JSON file.
5. The UI is updated with the fetched data, showing either the breed list or detailed information.
6. Error states and loading indicators are managed by `CatDataManager` and reflected in the UI.

This architecture ensures a separation of concerns, making the app more maintainable and scalable. It also provides a smooth user experience with offline support and efficient state management.


┌─────────────────────────────────┐
│         1. API Layer             │
└─────────────────────────────────┘
┌─────────────────┐
│   CatAPI        │
│ ─────────────── │
│ - getCatBreeds()│ ───> (calls) ───────────────────────────────>   Uses: ConnectivityMonitor
│ - getCatBreed() │               (to check connectivity)  
├─────────────────┘
┌───────────────────────────────────────────────────────────┐
> │ ApiHelper Class (not explicitly shown, but implied)        │
┌──────────────────┐  │ Handles GET requests. Used by CatAPI.                     │
│ Calls Cat API    │  │ - Sends requests to: https://api.thecatapi.com/v1          │
└──────────────────┘  └───────────────────────────────────────────────────────────┘
│
┌─────────────────┘
│
┌─────────────────────────────────┐
│         2. Data Models           │                (structured around the API response)
└─────────────────────────────────┘

┌───────────────┬──────────────┬──────────────┬───────────────┐
│     Cat       │   CatBreed   │   Breed      │ BreedList     │
└───────────────┴──────────────┴──────────────┴───────────────┘

- These models are JSON-serializable.
- They map the API-response data into structured Dart objects.


┌─────────────────────────────────┐
│         3. State Management      │    (Interacts with the UI, holds loading/error states)
└─────────────────────────────────┘

┌───────────────┐                 ┌──────────────────┐
│CatDataManager │                 │ Uses: ChangeNotifier │ -> Notifies listeners of state changes
│  (holds state) │◀ Call getCatBreed() or getCatData() ┘
│                │  
│
├ Methods: ────────────────────────────> Calls CatAPI to fetch breeds
│ - getCatData()        ────────────────> Updates breeds list
│ - getCatSpecificData()    Handles errors and loading states
│ - reloadBreeds()
└───────────────────────────────────────┘

┌─────────────────────────────────┐
│         4. Offline Support       │
└─────────────────────────────────┘
┌───────────────┐
│ cats.json     │ ───> Provides offline data when no internet connection
└───────────────┘
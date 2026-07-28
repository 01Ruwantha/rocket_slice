# <p align="center"><img src="https://github.com/01Ruwantha/rocket_slice/blob/ad551cdc2cf8f8e9bdd205339efb79bc67d592fd/assets/icon/icon.png" alt="App Logo" width="200"/></p><p align="center"><img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/assets/images/branding.png?raw=true" alt="branding png" width="400"/></p> <p align="center">Your Ultimate Pizza & Food Delivery App</p>

A Flutter-based product catalogue and ordering application for gourmet pizzas with modern UI, persistent storage, and smooth user experience.

---

## 📋 Project Overview

**Rocket Slice** is a Flutter product catalogue application that allows users to browse a catalog of pizzas, view detailed product information, search and filter products, and save favorite items. The app features a clean, responsive UI with support for both light and dark themes, persistent data storage using Hive, and smooth navigation powered by GoRouter.

### Core Features Implemented:
- **Product List Screen**: Grid display with product images, names, prices, categories, and favorite indicators
- **Product Details Screen**: Detailed view with larger image, full description, and favorite toggle
- **Search Functionality**: Real-time search with substring matching on product names
- **Favorites Management**: Add/remove favorites with synchronized state across list and details screens
- **State Management**: Provider-based reactive state management
- **Light/Dark Themes**: Full theming support with persistent user preference
- **Loading & Error States**: Proper loading indicators, error messages with retry, and empty states
- **Persistent Storage**: Favorites and theme preferences saved locally using Hive

### Additional Features (Beyond Core):
- Shopping cart functionality with quantity management
- Product customization (size, crust, toppings)
- Promo code application
- User profile management with avatar selection
- Promotional banners

---

## ⚙️ Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### 1. Clone the Repository
```bash
git clone <repository-url>
cd rocket_slice
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Project
```bash
flutter run
```

### 4. Build APK
```bash
flutter build apk --release
```

### 5. Build iOS (macOS only)
```bash
flutter build ios --release
```

---

## 🏗️ Architecture

### Folder Structure
```
rocket_slice/
├── android/                 # Android specific files
├── assets/                  # Images, icons, fonts
├── ios/                     # iOS specific files
├── lib/
│   ├── app/
│   │   ├── router/          # GoRouter configuration & route names
│   │   └── theme/           # Light/Dark theme definitions
│   ├── core/
│   │   ├── services/        # ThemeProvider (theme management)
│   │   └── widgets/         # Reusable widgets (Skelton, AppBottomNavBar)
│   ├── features/
│   │   ├── cart/            # Cart feature (model, service, view, widgets)
│   │   ├── favourite/       # Favorites feature (service, view)
│   │   ├── home/            # Home feature (model, service, view, widgets)
│   │   ├── profile/         # Profile feature (service, view)
│   │   └── splash/          # Splash screen
│   └── main.dart            # App entry point
├── pubspec.yaml             # Dependencies
└── README.md                # This file
```

### State-Management Approach
- **Provider**: Used for reactive state management across the app
- **ChangeNotifier**: All providers extend `ChangeNotifier` for efficient UI updates
- **Hive**: Local persistent storage for cart, favorites, profile, and theme settings
- **Singleton Pattern**: Each provider is instantiated once and shared via `MultiProvider`

#### Key Providers:
- `ThemeProvider`: Manages light/dark theme mode (persisted in Hive)
- `PizzaProvider`: Fetches and filters pizza catalog, manages search/sort/filter
- `CartProvider`: Manages cart items, quantities, promo codes, and order totals
- `FavoritesProvider`: Manages favorite product IDs (persisted in Hive)
- `ProfileProvider`: Manages user profile data (name, email, address, avatar)
- `PromoProvider`: Fetches promotional banners (simulated API call)

### API Integration Approach
- **Simulated API**: The app uses simulated network delays (`Future.delayed`) to mimic API calls
- **Static Data**: Product catalog and promo data are defined as static constants
- **Error Handling**: Basic error handling with fallback UI (placeholder images, empty states)
- **Future/Async**: All data fetching uses `Future` and `async/await` patterns

---

## 📝 Assumptions

1. **No Backend**: The app does not connect to a real backend API; all data is static or simulated.
2. **Product Data**: Product catalog, toppings, and prices are hardcoded as sample data.
3. **Promo Codes**: Only a few predefined promo codes are valid for demonstration.
4. **Delivery Address**: User must manually input delivery address; no geolocation integration.
5. **Payment Methods**: Payment methods are UI-only; no real payment processing.
6. **Order History**: Order history is not implemented (placeholder only).
7. **Images**: All images are loaded from external URLs with fallback placeholders.
8. **Splash Screen**: Splash screen is shown for 4 seconds before navigating to home.
9. **Persistence**: All user data (cart, favorites, profile, theme) is stored locally using Hive.
10. **No Authentication**: The app does not require login/signup; profile data is stored locally.

---

## ⚠️ Challenges Encountered

### 1. **State Management Complexity**
   - **Issue**: Managing multiple providers with interdependent state (cart, favorites, theme) required careful coordination.
   - **Solution**: Used `MultiProvider` with `ChangeNotifierProvider` and ensured proper listener cleanup to avoid memory leaks.

### 2. **Navigation with GoRouter and BottomNavigationBar**
   - **Issue**: Maintaining bottom navigation bar state while handling deep navigation (product details).
   - **Solution**: Implemented `ShellRoute` with a custom `ScaffoldWithBottomNavBar` and `PageView` for tab switching, with manual route synchronization.

### 3. **Persistent Storage with Hive**
   - **Issue**: Storing complex objects (CartItem, Product, ProductOption) required custom serialization.
   - **Solution**: Created `toMap()` and `fromMap()` methods for each model class, storing them as `Map` in Hive boxes.

### 4. **Image Loading Performance**
   - **Issue**: External images caused occasional loading delays and missing assets.
   - **Solution**: Added `errorBuilder` to display fallback widgets (emoji) and used `FadeInImage` for smoother transitions.

### 5. **Theme Switching**
   - **Issue**: Keeping theme state consistent across all screens and persisted.
   - **Solution**: Stored theme preference in Hive and used `Consumer<ThemeProvider>` to rebuild widgets on theme change.

### 6. **Favorites Synchronization**
   - **Issue**: Ensuring favorite status updates correctly on both product list and details screens.
   - **Solution**: Used a centralized `FavoritesProvider` with `ChangeNotifier` to propagate state changes to all listeners.

### 7. **Search Implementation**
   - **Issue**: Implementing real-time search without performance issues.
   - **Solution**: Used `setState` with debouncing and filtered the product list using `contains()` for substring matching.

---

## 🚀 Future Improvements

1. **Real Backend API Integration** – Connect to a RESTful API for dynamic product data, user authentication, and order processing.
2. **User Authentication** – Implement login/signup with Firebase Auth to associate favorites and profile data with user accounts.
3. **Order History & Tracking** – Add order history screen with real‑time tracking and notifications.
4. **Push Notifications** – Notify users about order status, promotions, and special offers.
5. **Payment Integration** – Integrate with Stripe for real payment processing.
6. **Advanced Search & Filters** – Add filters by ingredients, dietary preferences, and voice search.
7. **Internationalization (i18n)** – Support multiple languages and locales.
8. **Dynamic Promotions** – Fetch promo codes and discounts from the server dynamically.
9. **Offline Mode** – Allow browsing catalog and managing cart without internet connectivity.
10. **Performance Optimization** – Implement caching, lazy loading, and reduce rebuilds.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross‑platform mobile framework |
| **Provider** | State management |
| **GoRouter** | Navigation & routing |
| **Hive** | Local persistent storage |
| **CarouselSlider** | Promotional banners |
| **ImagePicker** | Profile avatar selection |
| **Shimmer** | Loading skeleton animations |

---

## 📱 Screenshots

**Light Mode**
<div align="center">

| Splash Screen | Animation page | Skelton Loading | Home page | Filter bottom Sheet | Details screen |
|-------------|-----------------|------|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/01.jpg?raw=true" alt="Splash Screen" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/02.jpg?raw=true" alt="Start Animation page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/03.jpg?raw=true" alt="Skelton Loading" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/04.jpg?raw=true" alt="Home page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/05.jpg?raw=true" alt="Filter bottom Sheet" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/06.jpg?raw=true" alt="Details screen" width="150" height="300"> |

| Cart Screen | Favorite page | Profile page | Change profile pic | Edit profile info | Drawer screen |
|-------------|-----------------|------|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/07.jpg?raw=true" alt="Cart Screen" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/08.jpg?raw=true" alt="Favorite page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/09.jpg?raw=true" alt="Profile page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/10.jpg?raw=true" alt="Change profile pic" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/11.jpg?raw=true" alt="Edit profile info" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/light_mode/12.jpg?raw=true" alt="Drawer screen" width="150" height="300"> |

</div>

**Dark Mode**
<div align="center">

| Splash Screen | Animation page | Skelton Loading | Home page | Filter bottom Sheet | Details screen |
|-------------|-----------------|------|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/01.jpg?raw=true" alt="Splash Screen" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/02.jpg?raw=true" alt="Start Animation page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/03.jpg?raw=true" alt="Skelton Loading" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/04.jpg?raw=true" alt="Home page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/05.jpg?raw=true" alt="Filter bottom Sheet" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/06.jpg?raw=true" alt="Details screen" width="150" height="300"> |

| Cart Screen | Favorite page | Profile page | Change profile pic | Edit profile info | Drawer screen |
|-------------|-----------------|------|--------|-----------|---------|
| <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/07.jpg?raw=true" alt="Cart Screen" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/08.jpg?raw=true" alt="Favorite page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/09.jpg?raw=true" alt="Profile page" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/10.jpg?raw=true" alt="Change profile pic" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/11.jpg?raw=true" alt="Edit profile info" width="150" height="300"> | <img src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/screenshots/dark_mode/12.jpg?raw=true" alt="Drawer screen" width="150" height="300"> |

</div>

---

## 🎥 Demo Video

<p align="center">
  <img 
  src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/video/video.gif?raw=true" 
  alt="App Demo" 
  width="150" 
  height="300"
/>
</p>

---

## 📄 License

This project is developed for educational purposes. All rights reserved.

---

## 👨‍💻 Author

**Rocket Slice Team - Ruwantha Madhushan**

---

## 🙏 Acknowledgments

- Unsplash for product images
- Flutter community for amazing packages and documentation

---
<div align="center">
<p align="center">
  <img 
  src="https://github.com/01Ruwantha/rocket_slice/blob/dev/submission/images/post_image.png" 
  alt="Rocket Slice Post Image" 
  width="1080" 
  height="720"
/>
</p>

**Made with ❤️ and ☕ by Ruwantha Madhushan**

*From the oven to your door—Rocket Slice delivers more!*

</div>


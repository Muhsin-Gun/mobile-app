# Services Marketplace App

A Flutter-based local services marketplace where tutors, designers, developers, and freelancers can connect with clients. Features include service browsing, provider profiles, bookings, ratings, and M-Pesa payment integration.

## 📱 Features

- **Service Browsing**: Browse services by category (Tutoring, Design, Development, Freelance)
- **Provider Profiles**: View detailed provider information with ratings and reviews
- **Bookings**: Request services with custom dates and requirements
- **Ratings & Reviews**: Rate and review completed services
- **M-Pesa Integration**: Secure payment processing via M-Pesa (Daraja API)
- **Authentication**: Google Sign-In and Firebase Authentication
- **Dark Mode**: Full dark theme support with theme persistence

## 🏗 Project Structure

```
lib/
├── main.dart                          # App entry point
├── constants/
│   └── app_colors.dart               # Color scheme and theming
├── models/
│   ├── service_provider.dart         # Service provider model
│   ├── service.dart                  # Service listing model
│   ├── booking.dart                  # Booking record model
│   └── review.dart                   # Review/rating model
├── providers/
│   ├── auth_provider.dart            # Authentication management
│   ├── theme_provider.dart           # Dark/light mode management
│   └── marketplace_provider.dart     # Services & bookings management
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── marketplace/
│       ├── marketplace_home_screen.dart      # Main home with categories
│       ├── browse_services_screen.dart       # Filtered services list
│       ├── provider_profile_screen.dart      # Provider details & reviews
│       ├── booking_screen.dart               # Service booking form
│       └── payment_screen.dart               # M-Pesa payment flow
└── widgets/
    └── (Reusable UI components)
```

## 🔧 Tech Stack

- **Framework**: Flutter
- **State Management**: Provider (ChangeNotifier)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Authentication**: Google Sign-In
- **Payment**: M-Pesa via Daraja API (TODO)
- **UI Libraries**: 
  - `iconly` - Icons
  - `flutter_rating_bar` - Rating widgets
  - `smooth_page_indicator` - Carousel indicators
  - `image_picker` - Profile photo upload

## 📊 Database Schema

### Firestore Collections

#### `serviceProviders/`
```
{
  id: String,
  userId: String,
  name: String,
  email: String,
  phone: String,
  profileImage: String,
  category: String (tutor|designer|developer|freelancer),
  bio: String,
  specialization: String,
  hourlyRate: Double,
  rating: Double,
  reviewsCount: Int,
  completedJobs: Int,
  isVerified: Boolean,
  skills: [String],
  createdAt: Timestamp
}
```

#### `services/`
```
{
  id: String,
  providerId: String,
  title: String,
  description: String,
  category: String,
  price: Double,
  deliveryDays: Int,
  images: [String],
  rating: Double,
  ordersCount: Int,
  createdAt: Timestamp
}
```

#### `bookings/`
```
{
  id: String,
  serviceId: String,
  providerId: String,
  clientId: String,
  clientName: String,
  clientEmail: String,
  totalPrice: Double,
  status: String (pending|accepted|in_progress|completed|cancelled),
  description: String,
  startDate: Timestamp,
  completedDate: Timestamp,
  paymentId: String,
  paymentStatus: String (pending|completed|failed),
  createdAt: Timestamp
}
```

#### `reviews/`
```
{
  id: String,
  bookingId: String,
  providerId: String,
  clientId: String,
  clientName: String,
  rating: Int (1-5),
  comment: String,
  createdAt: Timestamp
}
```

## 🔐 Authentication Flow

1. User opens app
2. AuthGate checks if user is logged in
3. If not, show Login/Register screens
4. Support for Google Sign-In and Email/Password authentication
5. User authenticated → Show MarketplaceHomeScreen

## 💳 Payment Flow

1. User selects service and proceeds to booking
2. Enters requirements and preferred date
3. Proceeds to payment screen
4. Selects M-Pesa as payment method
5. Enters M-Pesa phone number
6. API calls Daraja to initiate STK Push
7. User enters M-Pesa PIN on phone
8. Payment confirmed → Booking created in Firestore
9. Provider notified of new booking

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest)
- Firebase project setup
- M-Pesa Daraja API credentials (for payment integration)

### Installation

1. **Clone and setup**
```bash
cd mobile-app-2
flutter pub get
```

2. **Configure Firebase**
- Create Firebase project
- Add Android and iOS configurations
- Update `google-services.json` and `GoogleService-Info.plist`

3. **Configure Google Sign-In Web**
- Add Client ID to `web/index.html` meta tag:
```html
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID">
```

4. **M-Pesa Setup** (TODO)
- Get Daraja API credentials
- Add to `.env` or Firebase Remote Config
- Implement `initiateMpesaPayment()` in marketplace_provider.dart

### Running

```bash
# Development
flutter run

# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📝 Models Overview

### ServiceProvider
Main model for service providers. Includes all user profile data, skills, ratings, and verification status.

**Key Methods**:
- `toMap()` - Convert to Firestore document
- `fromMap()` - Create from Firestore document

### Service
Individual service offerings by providers.

**Key Methods**:
- `toMap()` - Convert to Firestore document
- `fromMap()` - Create from Firestore document

### Booking
Booking records linking clients to services.

**States**: pending → accepted → in_progress → completed
**Payment States**: pending → completed/failed

### Review
Client reviews and ratings for completed services.

## 🎨 UI Components

### Marketplace Home Screen
- Category grid (2x2 layout)
- Featured services carousel
- Top-rated providers list
- Search bar with gradient header

### Browse Services Screen
- Filtered services by category
- Sort options (rating, price)
- Service cards with provider info
- Click to view provider profile

### Provider Profile Screen
- Provider stats (rating, completed jobs, reviews)
- Bio and specialization
- Skills tags
- Contact information
- Recent reviews
- Book service button

### Booking Screen
- Service summary
- Quantity selector
- Date picker
- Additional requirements text
- Price breakdown with fees
- Continue to payment button

### Payment Screen
- Order summary
- Payment method selection (M-Pesa primary)
- Phone number input for M-Pesa
- Security information
- Pay button with loading state

## 🔄 State Management

### MarketplaceProvider
Manages all marketplace data:
- Services and providers
- Bookings and reviews
- Loading and error states

**Key Methods**:
- `fetchServices(category?)` - Get services (filtered by category)
- `fetchProviders(category?)` - Get providers (filtered by category)
- `createBooking()` - Create new booking
- `updateBookingStatus()` - Update booking status
- `addReview()` - Add review after completion
- `getProviderReviews()` - Get all reviews for provider

### ThemeProvider
Manages dark/light mode with persistence.

### AuthProvider
Handles user authentication (existing implementation).

## 🛠 Future Enhancements

1. **Provider Dashboard**
   - View all bookings
   - Accept/reject bookings
   - Mark as completed
   - Respond to reviews

2. **Advanced Search**
   - Full-text search
   - Filter by skills, availability
   - Sort by distance (geolocation)

3. **Messaging System**
   - In-app messaging between clients and providers
   - Message notifications

4. **Ratings Analytics**
   - Provider analytics dashboard
   - Service performance metrics

5. **Payment Integration**
   - M-Pesa Daraja API integration
   - Webhook handlers for payment confirmation
   - Transaction history

6. **Real-time Updates**
   - Live booking status updates
   - Notifications on booking changes
   - Provider availability updates

## 🐛 Known Issues & TODO

- [ ] M-Pesa payment API integration (currently mocked)
- [ ] Provider dashboard screens
- [ ] Messaging system
- [ ] Geolocation-based filtering
- [ ] Image upload to Firebase Storage (currently placeholder)
- [ ] Notification system
- [ ] Admin panel for verification

## 📄 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  firebase_storage: ^11.0.0
  google_sign_in: ^6.0.0
  image_picker: ^0.8.0
  iconly: ^1.0.0
  flutter_rating_bar: ^4.0.0
  smooth_page_indicator: ^1.1.0
  shared_preferences: ^2.0.0
```

## 📞 Support

For issues or questions, please refer to the Flutter and Firebase documentation.

## 📄 License

This project is part of a personal learning exercise in Flutter and Firebase development.

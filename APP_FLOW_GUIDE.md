# 🗺️ App Flow & Navigation Guide

## Complete User Journey Map

### 🏠 Main App Flow

```
┌─────────────────┐
│  App Launches   │
└────────┬────────┘
         │
    Check Auth
         │
    ┌────┴────┐
    │          │
  NO          YES
    │          │
    ▼          ▼
┌─────┐   ┌──────────────────┐
│Login│   │Marketplace Home  │
├─────┤   ├──────────────────┤
│Register  │ Categories Grid │
└─────┘   │ Featured Services│
          │ Top Providers    │
          └──────────────────┘
```

---

## 📱 Screen Hierarchy

```
AuthGate (Root)
├── Login/Register (Not Authenticated)
│   ├── Email/Password
│   └── Google Sign-In
│
└── Marketplace (Authenticated)
    └── MarketplaceHomeScreen
        ├── Categories Grid (Tutoring, Design, Dev, Freelance)
        │   └── BrowseServicesScreen
        │       ├── Service Cards
        │       ├── Filter by Category
        │       └── Sort Options
        │           └── ProviderProfileScreen
        │               ├── Provider Details
        │               ├── Reviews List
        │               └── Book Service Button
        │                   └── BookingScreen
        │
        ├── Featured Services Carousel
        │   └── ProviderProfileScreen
        │
        └── Top Providers List
            └── ProviderProfileScreen
                └── BookingScreen
                    └── PaymentScreen
                        └── M-Pesa Payment
```

---

## 💼 User Roles & Flows

### 👤 Client Flow

```
Client Signs In
      ↓
Marketplace Home
      ↓
   ┌──┴──┬──┬──┐
   ▼      ▼  ▼  ▼
 Browse Featured Top View
 by Cat Carousel Providers Profile
   ↓      ↓      ↓      ↓
   └──────┴──┬───┴──────┘
             ▼
      Provider Profile
        ├── View Bio
        ├── Check Skills
        ├── See Reviews
        ├── Check Rating
        └── Click "Book Service"
             ▼
        Booking Screen
        ├── Select Quantity
        ├── Pick Date
        ├── Add Details
        └── Review Price
             ▼
        Payment Screen
        ├── Choose M-Pesa
        ├── Enter Phone
        └── Pay
             ▼
        ✅ Booking Confirmed
             ▼
        Waiting for Provider
        Response...
```

### 🛠️ Provider Flow (Future Feature)

```
Provider Signs In
      ↓
Provider Dashboard (TO BUILD)
      ├── View Profile
      ├── Manage Services
      │   ├── Create
      │   ├── Update
      │   └── Delete
      ├── View Bookings
      │   ├── Pending
      │   ├── Accepted
      │   ├── In Progress
      │   ├── Completed
      │   └── Cancelled
      ├── Accept/Reject Bookings
      ├── Mark Complete
      └── View Reviews
```

---

## 🎨 Screen Details

### 1️⃣ Marketplace Home Screen

```
┌──────────────────────────────────┐
│         SERVICES MARKETPLACE     │
├──────────────────────────────────┤
│  🔍  Search services...          │
├──────────────────────────────────┤
│ Categories (2x2 Grid):           │
│ ┌─────────────┬─────────────┐   │
│ │ 📚 Tutoring │ 🎨 Design   │   │
│ │  5 Services │  8 Services │   │
│ └─────────────┴─────────────┘   │
│ ┌─────────────┬─────────────┐   │
│ │ 💻 Dev      │ 🎯 Freelance│  │
│ │ 12 Services │  6 Services │   │
│ └─────────────┴─────────────┘   │
├──────────────────────────────────┤
│ Featured Services (Carousel):    │
│ ┌──────────────────────────────┐ │
│ │ Service Title        $50     │ │
│ │ ⭐ 4.8 (24 reviews)          │ │
│ │ 3 days delivery              │ │
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│ Top Rated Providers:            │
│ 👤 John Doe        ⭐ 4.9       │
│    Full Stack Dev   $50/hr       │
│ 👤 Jane Smith      ⭐ 4.8       │
│    UI/UX Designer   $45/hr       │
│ 👤 Mike Johnson    ⭐ 4.7       │
│    Data Scientist   $60/hr       │
└──────────────────────────────────┘
```

### 2️⃣ Browse Services Screen

```
┌──────────────────────────────────┐
│        TUTORING SERVICES         │
├──────────────────────────────────┤
│ 🔍 Search...  [Sort: Rating ⏷]  │
├──────────────────────────────────┤
│ Service Card:                    │
│ ┌──────────────────────────────┐ │
│ │ [Service Image Placeholder]  │ │
│ ├──────────────────────────────┤ │
│ │ Math Tutoring - Advanced     │ │
│ │ Help master advanced calc    │ │
│ │ $25  •  3 days  •  ⭐4.9     │ │
│ │          [View] →             │ │
│ └──────────────────────────────┘ │
│ ┌──────────────────────────────┐ │
│ │ [Service Image Placeholder]  │ │
│ ├──────────────────────────────┤ │
│ │ Physics Tutoring             │ │
│ │ One-on-one physics sessions  │ │
│ │ $30  •  2 days  •  ⭐4.8     │ │
│ │          [View] →             │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
```

### 3️⃣ Provider Profile Screen

```
┌──────────────────────────────────┐
│      PROVIDER PROFILE            │
├──────────────────────────────────┤
│           [Avatar]               │
│        John Doe ✓                │
│        DEVELOPER                 │
├──────────────────────────────────┤
│  ⭐ 4.9       💼 156      💬 24  │
│  Rating      Completed   Reviews │
├──────────────────────────────────┤
│ About:                           │
│ Experienced full-stack developer │
│ with 5+ years expertise          │
├──────────────────────────────────┤
│ Specialization: Full Stack       │
├──────────────────────────────────┤
│ Skills:                          │
│ [Flutter] [Dart] [Firebase]      │
│ [UI/UX] [Node.js]                │
├──────────────────────────────────┤
│ Contact:                         │
│ 📧 john@example.com              │
│ 📱 +254 712 345 678              │
├──────────────────────────────────┤
│ Recent Reviews:                  │
│ Sarah M. ⭐⭐⭐⭐⭐              │
│ "Excellent work!"                │
│ John D. ⭐⭐⭐⭐ ½              │
│ "Great results!"                 │
├──────────────────────────────────┤
│ [        BOOK SERVICE       ]    │
└──────────────────────────────────┘
```

### 4️⃣ Booking Screen

```
┌──────────────────────────────────┐
│      BOOK SERVICE                │
├──────────────────────────────────┤
│ Service Summary:                 │
│ Math Tutoring - Advanced        │
│ Price: $25/unit                  │
├──────────────────────────────────┤
│ Quantity:                        │
│ [  -  |  1  |  +  ]             │
├──────────────────────────────────┤
│ Preferred Start Date:            │
│ 📅 [Select date]                 │
├──────────────────────────────────┤
│ Additional Details:              │
│ ┌──────────────────────────────┐ │
│ │ Tell provider about your...  │ │
│ │                              │ │
│ │                              │ │
│ └──────────────────────────────┘ │
├──────────────────────────────────┤
│ Order Summary:                   │
│ Subtotal (1 x $25)  ........$25  │
│ Platform Fee (10%)  ........$2.50│
│                     ────────────  │
│ Total          ........$27.50    │
├──────────────────────────────────┤
│ [    CONTINUE TO PAYMENT    ]    │
└──────────────────────────────────┘
```

### 5️⃣ Payment Screen

```
┌──────────────────────────────────┐
│      PAYMENT METHOD              │
├──────────────────────────────────┤
│ Order Summary:                   │
│ Total Amount: $27.50             │
├──────────────────────────────────┤
│ Select Payment Method:           │
│ ⦿ M-Pesa                        │
│   Pay via M-Pesa                 │
│ ○ Credit Card                   │
│   Coming soon                    │
├──────────────────────────────────┤
│ M-Pesa Phone Number:             │
│ ┌──────────────────────────────┐ │
│ │ 📱 Enter phone number...    │ │
│ └──────────────────────────────┘ │
│ You'll receive STK prompt        │
├──────────────────────────────────┤
│ 🔒 Secure & Encrypted           │
├──────────────────────────────────┤
│ [     PAY $27.50            ]    │
└──────────────────────────────────┘
```

---

## 🔄 Payment Flow Sequence

```
1. User enters phone number
   ↓
2. App calls backend API
   ↓
3. Backend initiates M-Pesa STK Push
   ↓
4. User receives STK push prompt
   ↓
5. User enters M-Pesa PIN
   ↓
6. M-Pesa confirms payment
   ↓
7. Callback webhook received
   ↓
8. Booking status updated to "accepted"
   ↓
9. Provider notified
   ↓
10. Client sees confirmation
```

---

## 🎯 Category Selection Flow

```
User taps "Tutoring"
         ↓
Navigate to BrowseServicesScreen
    with category="tutoring"
         ↓
MarketplaceProvider.fetchServices(
  category: "tutoring"
)
         ↓
Load from Firestore:
services where category == "tutoring"
         ↓
Display in grid with:
- Title
- Price
- Rating
- Delivery time
- Provider name
         ↓
User taps service
         ↓
Navigate to ProviderProfileScreen
with providerId
         ↓
Show full provider details
& reviews
         ↓
User taps "Book Service"
         ↓
Navigate to BookingScreen
```

---

## 📊 Data Flow

```
UI Layer (Screens)
    ↓
Provider Layer (MarketplaceProvider)
    ↓
Firestore (Real-time listeners)
    ↓
Collections:
├── services/
├── serviceProviders/
├── bookings/
└── reviews/
```

---

## ✨ Key Interactions

### 1. Category Grid Taps
- User taps category emoji
- Screen navigates with category parameter
- Services filtered in real-time

### 2. Service Card Taps
- Shows provider profile
- User can see full details before booking
- Reviews provide trust signals

### 3. Booking Date Selection
- Calendar picker
- Disabled past dates
- Shows delivery time

### 4. Payment Processing
- Phone number validation
- STK push initiated
- Real-time status polling
- Success/failure handling

---

## 🔐 Authentication Gates

```
┌─────────────────────────────────┐
│   App Initialization            │
├─────────────────────────────────┤
│ AuthProvider checks:             │
│ - Is user logged in?             │
│ - Is auth token valid?           │
│ - Is user verified?              │
└─────────────────────────────────┘
         ↓ If No
    ┌─────────────┐
    │ Login/Reg   │
    └──────┬──────┘
         ↓ If Yes
    ┌──────────────────┐
    │ Marketplace Home │
    └──────────────────┘
```

---

## 🚀 Performance Considerations

### Optimizations Implemented:
- ✅ Consumer pattern for selective rebuilds
- ✅ Firestore real-time listeners
- ✅ Image caching placeholders
- ✅ Lazy loading for lists
- ✅ Async payment processing

### Future Optimizations:
- [ ] Pagination for service lists
- [ ] Search debouncing
- [ ] Image CDN integration
- [ ] Offline caching
- [ ] Push notifications

---

## 📋 State Management Flow

```
User Action
    ↓
Screen calls Provider method
    ↓
Provider updates state (_services, _providers, etc.)
    ↓
Consumer rebuilds with new data
    ↓
UI updates with new values
    ↓
Firestore listener updates
    ↓
Real-time sync across devices
```

---

**This visualization helps understand the complete user journey from authentication through payment!** 🎯

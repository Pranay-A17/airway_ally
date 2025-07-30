# Firestore Integration Setup Guide

## Overview
The Airway Ally app now uses Firebase Firestore as the backend database for storing user data, help requests, and trip information. This guide explains how to set up and use the Firestore integration.

## Database Structure

### Collections

#### 1. `users`
Stores user profile information and preferences.

**Document Structure:**
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "name": "User Name",
  "role": "seeker|navigator",
  "profileImageUrl": "optional_url",
  "rating": 4.5,
  "completedTrips": 10,
  "badges": ["Badge1", "Badge2"],
  "preferences": {},
  "createdAt": "timestamp",
  "lastActive": "timestamp"
}
```

#### 2. `help_requests`
Stores help requests from seekers to navigators.

**Document Structure:**
```json
{
  "id": "auto_generated",
  "seekerId": "user_id",
  "seekerName": "Seeker Name",
  "airport": "JFK Airport",
  "date": "timestamp",
  "time": "14:30",
  "description": "Help description",
  "status": "pending|accepted|completed|cancelled",
  "navigatorId": "optional_navigator_id",
  "navigatorName": "optional_navigator_name",
  "seekerRating": 4.8,
  "createdAt": "timestamp",
  "acceptedAt": "optional_timestamp",
  "completedAt": "optional_timestamp"
}
```

#### 3. `trips`
Stores user trip and flight information.

**Document Structure:**
```json
{
  "id": "auto_generated",
  "userId": "user_id",
  "flightNumber": "AA123",
  "fromAirport": "JFK",
  "toAirport": "LHR",
  "departureDate": "timestamp",
  "departureTime": "14:30",
  "arrivalTime": "06:30",
  "status": "upcoming|in_progress|completed|cancelled",
  "gate": "A12",
  "terminal": "8",
  "flightStatus": {},
  "createdAt": "timestamp",
  "completedAt": "optional_timestamp"
}
```

## Setup Instructions

### 1. Firebase Project Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing project
3. Enable Firestore Database
4. Set up security rules (see Security Rules section below)

### 2. Security Rules
Add these Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Help requests - users can create, navigators can read pending ones
    match /help_requests/{requestId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
      allow update: if request.auth != null && 
        (resource.data.seekerId == request.auth.uid || 
         resource.data.navigatorId == request.auth.uid);
    }
    
    // Trips - users can read/write their own trips
    match /trips/{tripId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
  }
}
```

### 3. Sample Data Population
The app includes an Admin Panel to populate sample data:

1. Run the app
2. Navigate to the Admin Panel (available in the home screen)
3. Click "Populate Sample Data" to add test data
4. Use "Clear Sample Data" to remove all test data

## Features Implemented

### Real-time Data
- **Help Requests**: Navigators see real-time updates of new help requests
- **User Profiles**: Real-time user data updates
- **Trips**: Real-time trip status updates

### State Management
- **Riverpod**: Used for state management and data providers
- **Streams**: Real-time data streams from Firestore
- **Error Handling**: Comprehensive error handling for all operations

### Data Models
- **UserModel**: User profile and preferences
- **HelpRequestModel**: Help request data and status
- **TripModel**: Trip and flight information

## Usage Examples

### Creating a Help Request
```dart
final request = HelpRequestModel(
  id: '', // Auto-generated
  seekerId: currentUser.id,
  seekerName: currentUser.name,
  airport: 'JFK Airport',
  date: selectedDate,
  time: '14:30',
  description: 'Need help with customs',
  status: 'pending',
  createdAt: DateTime.now(),
);

await ref.read(helpRequestProvider.notifier).createHelpRequest(request);
```

### Accepting a Help Request
```dart
await ref.read(helpRequestProvider.notifier).acceptHelpRequest(
  requestId,
  navigatorId,
  navigatorName,
);
```

### Creating a Trip
```dart
final trip = TripModel(
  id: '', // Auto-generated
  userId: currentUser.id,
  flightNumber: 'AA123',
  fromAirport: 'JFK',
  toAirport: 'LHR',
  departureDate: selectedDate,
  departureTime: '14:30',
  status: 'upcoming',
  createdAt: DateTime.now(),
);

await ref.read(tripProvider.notifier).createTrip(trip);
```

## Testing

### Sample Data
The app includes comprehensive sample data:
- 5 users (3 seekers, 2 navigators)
- 4 help requests (3 pending, 1 accepted)
- 4 trips (3 upcoming, 1 completed)

### Test Scenarios
1. **Navigator View**: Switch to Navigator role and view help requests
2. **Seeker View**: Switch to Seeker role and view trips
3. **Real-time Updates**: Accept help requests and see status changes
4. **Error Handling**: Test with network issues or invalid data

## Next Steps

### Potential Enhancements
1. **Chat System**: Real-time messaging between seekers and navigators
2. **Push Notifications**: Notify users of new requests or status changes
3. **Payment Integration**: Handle payments for premium services
4. **Analytics**: Track user behavior and app usage
5. **Offline Support**: Cache data for offline usage

### Performance Optimization
1. **Pagination**: Implement pagination for large datasets
2. **Caching**: Add local caching for frequently accessed data
3. **Indexing**: Optimize Firestore indexes for queries
4. **Compression**: Compress data for faster transfers

## Troubleshooting

### Common Issues
1. **Permission Denied**: Check Firestore security rules
2. **Network Errors**: Verify internet connection and Firebase configuration
3. **Data Not Loading**: Check if sample data is populated
4. **Authentication Issues**: Ensure Firebase Auth is properly configured

### Debug Tips
1. Check Firebase Console for error logs
2. Use Flutter Inspector to debug UI issues
3. Add print statements in data providers for debugging
4. Test with different user roles and scenarios 
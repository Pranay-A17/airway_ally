import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/help_request_model.dart';
import '../models/trip_model.dart';
import '../utils/logger.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    try {
      Logger.info('Creating user in Firestore: ${user.email}');
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      Logger.success('User created successfully in Firestore');
    } catch (e) {
      Logger.error('Failed to create user in Firestore', e);
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      Logger.info('Updating user in Firestore: ${user.email}');
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      Logger.success('User updated successfully in Firestore');
    } catch (e) {
      Logger.error('Failed to update user in Firestore', e);
      rethrow;
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      Logger.info('Getting user from Firestore: $userId');
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!, doc.id);
        Logger.success('User retrieved successfully from Firestore');
        return user;
      } else {
        Logger.warning('User not found in Firestore: $userId');
        return null;
      }
    } catch (e) {
      Logger.error('Failed to get user from Firestore', e);
      rethrow;
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    Logger.info('Setting up user stream for: $userId');
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            Logger.debug('User stream updated for: $userId');
            return UserModel.fromMap(doc.data()!, doc.id);
          } else {
            Logger.warning('User stream: user not found for: $userId');
            return null;
          }
        });
  }

  // Help request operations
  Future<String> createHelpRequest(HelpRequestModel request) async {
    try {
      Logger.info('Creating help request in Firestore');
      final docRef = await _firestore.collection('help_requests').add(request.toMap());
      Logger.success('Help request created successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      Logger.error('Failed to create help request in Firestore', e);
      rethrow;
    }
  }

  Future<void> updateHelpRequest(HelpRequestModel request) async {
    try {
      Logger.info('Updating help request in Firestore: ${request.id}');
      await _firestore.collection('help_requests').doc(request.id).update(request.toMap());
      Logger.success('Help request updated successfully');
    } catch (e) {
      Logger.error('Failed to update help request in Firestore', e);
      rethrow;
    }
  }

  Stream<List<HelpRequestModel>> getHelpRequestsForNavigator() {
    Logger.info('Setting up help requests stream for navigators');
    return _firestore
        .collection('help_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<HelpRequestModel>> getHelpRequestsForSeeker(String seekerId) {
    Logger.info('Setting up help requests stream for seeker: $seekerId');
    return _firestore
        .collection('help_requests')
        .where('seekerId', isEqualTo: seekerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HelpRequestModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> acceptHelpRequest(String requestId, String navigatorId, String navigatorName) async {
    try {
      Logger.info('Accepting help request: $requestId by navigator: $navigatorId');
      await _firestore.collection('help_requests').doc(requestId).update({
        'status': 'accepted',
        'navigatorId': navigatorId,
        'navigatorName': navigatorName,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      Logger.success('Help request accepted successfully');
    } catch (e) {
      Logger.error('Failed to accept help request', e);
      rethrow;
    }
  }

  Future<void> completeHelpRequest(String requestId) async {
    try {
      Logger.info('Completing help request: $requestId');
      await _firestore.collection('help_requests').doc(requestId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
      Logger.success('Help request completed successfully');
    } catch (e) {
      Logger.error('Failed to complete help request', e);
      rethrow;
    }
  }

  // Trip operations
  Future<String> createTrip(TripModel trip) async {
    try {
      Logger.info('Creating trip in Firestore');
      final docRef = await _firestore.collection('trips').add(trip.toMap());
      Logger.success('Trip created successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      Logger.error('Failed to create trip in Firestore', e);
      rethrow;
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    try {
      Logger.info('Updating trip in Firestore: ${trip.id}');
      await _firestore.collection('trips').doc(trip.id).update(trip.toMap());
      Logger.success('Trip updated successfully');
    } catch (e) {
      Logger.error('Failed to update trip in Firestore', e);
      rethrow;
    }
  }

  Stream<List<TripModel>> getUserTrips(String userId) {
    Logger.info('Setting up trips stream for user: $userId');
    return _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .orderBy('departureDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<TripModel?> getTrip(String tripId) async {
    try {
      Logger.info('Getting trip from Firestore: $tripId');
      final doc = await _firestore.collection('trips').doc(tripId).get();
      if (doc.exists) {
        final trip = TripModel.fromMap(doc.data()!, doc.id);
        Logger.success('Trip retrieved successfully from Firestore');
        return trip;
      } else {
        Logger.warning('Trip not found in Firestore: $tripId');
        return null;
      }
    } catch (e) {
      Logger.error('Failed to get trip from Firestore', e);
      rethrow;
    }
  }

  Future<void> updateFlightStatus(String tripId, Map<String, dynamic> flightStatus) async {
    try {
      Logger.info('Updating flight status for trip: $tripId');
      await _firestore.collection('trips').doc(tripId).update({
        'flightStatus': flightStatus,
      });
      Logger.success('Flight status updated successfully');
    } catch (e) {
      Logger.error('Failed to update flight status', e);
      rethrow;
    }
  }

  // Utility methods
  Future<void> updateUserLastActive(String userId) async {
    try {
      Logger.debug('Updating last active for user: $userId');
      await _firestore.collection('users').doc(userId).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Logger.error('Failed to update user last active', e);
      // Don't rethrow for this utility method
    }
  }

  // Search and filtering
  Stream<List<HelpRequestModel>> searchHelpRequests({
    String? airport,
    DateTime? date,
    String? status,
  }) {
    Query query = _firestore.collection('help_requests');
    
    if (airport != null && airport.isNotEmpty) {
      query = query.where('airport', isEqualTo: airport);
    }
    
    if (date != null) {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      query = query.where('date', isGreaterThanOrEqualTo: startOfDay)
                   .where('date', isLessThan: endOfDay);
    }
    
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HelpRequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
} 
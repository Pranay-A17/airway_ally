import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/help_request_model.dart';
import '../models/trip_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User operations
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Firestore createUser error: $e');
      // Retry once after a short delay if it's a connectivity issue
      if (e.toString().contains('unavailable') || e.toString().contains('network')) {
        print('Retrying createUser after delay...');
        await Future.delayed(const Duration(seconds: 2));
        await _firestore.collection('users').doc(user.id).set(user.toMap());
      } else {
        throw Exception('Failed to create user: $e');
      }
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      print('Attempting to update user: ${user.id}');
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      print('User updated successfully: ${user.id}');
    } catch (e) {
      print('Failed to update user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    print('Getting user stream for: $userId');
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          print('User doc exists: ${doc.exists}');
          if (doc.exists) {
            final user = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            print('User loaded: ${user.name} (${user.role})');
            return user;
          }
          print('User doc does not exist');
          return null;
        });
  }

  // Help Request operations
  Future<String> createHelpRequest(HelpRequestModel request) async {
    try {
      final docRef = await _firestore.collection('help_requests').add(request.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create help request: $e');
    }
  }

  Future<void> updateHelpRequest(HelpRequestModel request) async {
    try {
      await _firestore.collection('help_requests').doc(request.id).update(request.toMap());
    } catch (e) {
      throw Exception('Failed to update help request: $e');
    }
  }

  Stream<List<HelpRequestModel>> getHelpRequestsForNavigator() {
    return _firestore
        .collection('help_requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HelpRequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<HelpRequestModel>> getHelpRequestsForSeeker(String seekerId) {
    return _firestore
        .collection('help_requests')
        .where('seekerId', isEqualTo: seekerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HelpRequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> acceptHelpRequest(String requestId, String navigatorId, String navigatorName) async {
    try {
      await _firestore.collection('help_requests').doc(requestId).update({
        'status': 'accepted',
        'navigatorId': navigatorId,
        'navigatorName': navigatorName,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to accept help request: $e');
    }
  }

  Future<void> completeHelpRequest(String requestId) async {
    try {
      await _firestore.collection('help_requests').doc(requestId).update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete help request: $e');
    }
  }

  // Trip operations
  Future<String> createTrip(TripModel trip) async {
    try {
      final docRef = await _firestore.collection('trips').add(trip.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    try {
      await _firestore.collection('trips').doc(trip.id).update(trip.toMap());
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  Stream<List<TripModel>> getUserTrips(String userId) {
    return _firestore
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .orderBy('departureDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<TripModel?> getTrip(String tripId) async {
    try {
      final doc = await _firestore.collection('trips').doc(tripId).get();
      if (doc.exists) {
        return TripModel.fromMap(doc.data()! as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get trip: $e');
    }
  }

  Future<void> updateFlightStatus(String tripId, Map<String, dynamic> flightStatus) async {
    try {
      await _firestore.collection('trips').doc(tripId).update({
        'flightStatus': flightStatus,
      });
    } catch (e) {
      throw Exception('Failed to update flight status: $e');
    }
  }

  // Utility methods
  Future<void> updateUserLastActive(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Don't throw error for this as it's not critical
      print('Failed to update last active: $e');
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
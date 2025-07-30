import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/help_request_model.dart';
import '../models/trip_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

// Help Request Providers
final helpRequestsForNavigatorProvider = StreamProvider<List<HelpRequestModel>>((ref) {
  return ref.read(firestoreServiceProvider).getHelpRequestsForNavigator();
});

final helpRequestsForSeekerProvider = StreamProvider.family<List<HelpRequestModel>, String>((ref, seekerId) {
  return ref.read(firestoreServiceProvider).getHelpRequestsForSeeker(seekerId);
});

final helpRequestProvider = StateNotifierProvider<HelpRequestNotifier, AsyncValue<void>>((ref) {
  return HelpRequestNotifier(ref.read(firestoreServiceProvider));
});

class HelpRequestNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _firestoreService;

  HelpRequestNotifier(this._firestoreService) : super(const AsyncValue.data(null));

  Future<void> createHelpRequest(HelpRequestModel request) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.createHelpRequest(request);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> acceptHelpRequest(String requestId, String navigatorId, String navigatorName) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.acceptHelpRequest(requestId, navigatorId, navigatorName);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> completeHelpRequest(String requestId) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.completeHelpRequest(requestId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateHelpRequest(HelpRequestModel request) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.updateHelpRequest(request);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Trip Providers
final userTripsProvider = StreamProvider.family<List<TripModel>, String>((ref, userId) {
  return ref.read(firestoreServiceProvider).getUserTrips(userId);
});

final tripProvider = StateNotifierProvider<TripNotifier, AsyncValue<void>>((ref) {
  return TripNotifier(ref.read(firestoreServiceProvider));
});

class TripNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _firestoreService;

  TripNotifier(this._firestoreService) : super(const AsyncValue.data(null));

  Future<void> createTrip(TripModel trip) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.createTrip(trip);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.updateTrip(trip);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateFlightStatus(String tripId, Map<String, dynamic> flightStatus) async {
    try {
      state = const AsyncValue.loading();
      await _firestoreService.updateFlightStatus(tripId, flightStatus);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Search Providers
final searchHelpRequestsProvider = StreamProvider.family<List<HelpRequestModel>, Map<String, dynamic>>((ref, filters) {
  return ref.read(firestoreServiceProvider).searchHelpRequests(
    airport: filters['airport'],
    date: filters['date'],
    status: filters['status'],
  );
}); 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../utils/logger.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.read(firestoreServiceProvider));
});

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authProvider).when(
    data: (user) {
      if (user != null) {
        Logger.info('Auth user found: ${user.id}');
        return Stream.value(user);
      }
      Logger.info('No auth user found');
      return Stream.value(null);
    },
    loading: () {
      Logger.info('Auth loading...');
      return Stream.value(null);
    },
    error: (error, stack) {
      Logger.error('Auth error: $error');
      return Stream.value(null);
    },
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService;

  AuthNotifier(this._firestoreService) : super(const AsyncValue.loading()) {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? firebaseUser) {
    Logger.info('Auth state changed: ${firebaseUser?.email ?? 'No user'}');
    
    if (firebaseUser == null) {
      Logger.info('User signed out');
      state = const AsyncValue.data(null);
      return;
    }

    Logger.info('User signed in: ${firebaseUser.email}');
    _loadUserData(firebaseUser.uid);
  }

  Future<void> _loadUserData(String uid) async {
    try {
      Logger.info('Loading user data for UID: $uid');
      state = const AsyncValue.loading();
      
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final user = UserModel.fromMap(userData, uid);
        Logger.success('User data loaded successfully');
        state = AsyncValue.data(user);
      } else {
        Logger.warning('User document not found, creating new user');
        // Create a new user document
        final newUser = UserModel(
          id: uid,
          email: _auth.currentUser?.email ?? '',
          name: _auth.currentUser?.displayName ?? _auth.currentUser?.email?.split('@')[0] ?? 'User',
          role: 'seeker', // Default role
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        
        await _firestoreService.createUser(newUser);
        Logger.success('New user created successfully');
        state = AsyncValue.data(newUser);
      }
    } catch (e) {
      Logger.error('Failed to load user data', e);
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      Logger.info('Attempting sign in for: $email');
      state = const AsyncValue.loading();
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 10));
      
      Logger.success('Sign in successful for: ${userCredential.user?.email}');
      
      // User data will be loaded by _onAuthStateChanged
    } catch (e) {
      Logger.error('Sign in failed', e);
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name, String role) async {
    try {
      Logger.info('Attempting sign up for: $email');
      state = const AsyncValue.loading();
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 10));
      
      Logger.info('Firebase user created, updating display name');
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      Logger.info('Creating user document in Firestore');
      
      // Create user document in Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
      
      await _firestoreService.createUser(newUser);
      Logger.success('Sign up successful for: $email');
      
      // User data will be loaded by _onAuthStateChanged
    } catch (e) {
      Logger.error('Sign up failed', e);
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      Logger.info('Signing out user');
      await _auth.signOut();
      Logger.success('Sign out successful');
    } catch (e) {
      Logger.error('Sign out failed', e);
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      Logger.info('Updating user profile for: ${updatedUser.email}');
      await _firestoreService.updateUser(updatedUser);
      Logger.success('User profile updated successfully');
      
      // Reload user data
      if (_auth.currentUser != null) {
        await _loadUserData(_auth.currentUser!.uid);
      }
    } catch (e) {
      Logger.error('Failed to update user profile', e);
      rethrow;
    }
  }
} 
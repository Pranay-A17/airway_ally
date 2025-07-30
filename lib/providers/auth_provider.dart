import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(FirebaseAuth.instance, ref.read(firestoreServiceProvider));
});

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authProvider).when(
    data: (user) {
      if (user != null) {
        print('Auth user found: ${user.uid}');
        return ref.read(firestoreServiceProvider).getUserStream(user.uid);
      }
      print('No auth user found');
      return Stream.value(null);
    },
    loading: () {
      print('Auth loading...');
      return Stream.value(null);
    },
    error: (error, stack) {
      print('Auth error: $error');
      return Stream.value(null);
    },
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;

  AuthNotifier(this._auth, this._firestoreService) : super(const AsyncValue.loading()) {
    // Delay the initialization to ensure Firebase is ready
    Future.microtask(() {
      try {
        _auth.authStateChanges().listen((user) {
          state = AsyncValue.data(user);
        });
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    });
  }

  Future<void> signUp(String email, String password, String name, String role) async {
    try {
      state = const AsyncValue.loading();
      print('Creating Firebase Auth user...');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        print('Firebase Auth user created: ${userCredential.user!.uid}');
        final user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        try {
          print('Creating Firestore user profile...');
          await _firestoreService.createUser(user)
              .timeout(const Duration(seconds: 10));
          print('Firestore user profile created successfully');
        } catch (firestoreError) {
          print('Firestore error during signup: $firestoreError');
          // Don't fail the entire signup if Firestore is down
          // The user can still sign in and create profile later
          print('Continuing with signup despite Firestore error');
        }
      }
      
      print('Sign up completed successfully');
    } catch (e) {
      print('Signup error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      print('Attempting to sign in with email: $email');
      
      // Sign in with Firebase Auth
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Firebase Auth sign in successful');
      
      // Check if user profile exists in Firestore, if not create a basic one
      final user = _auth.currentUser;
      if (user != null) {
        print('Checking if user profile exists for: ${user.uid}');
        try {
          // Add timeout to Firestore operations
          final existingUser = await _firestoreService.getUser(user.uid)
              .timeout(const Duration(seconds: 10));
          
          if (existingUser == null) {
            print('Creating new user profile for: ${user.uid}');
            // Create a basic user profile if it doesn't exist
            final newUser = UserModel(
              id: user.uid,
              email: email,
              name: user.displayName ?? email.split('@')[0],
              role: 'seeker', // Default role
              createdAt: DateTime.now(),
              lastActive: DateTime.now(),
            );
            await _firestoreService.createUser(newUser)
                .timeout(const Duration(seconds: 10));
            print('User profile created successfully');
          } else {
            print('User profile already exists: ${existingUser.name}');
          }
        } catch (firestoreError) {
          print('Firestore error during sign in: $firestoreError');
          // Don't fail the sign in if Firestore is down
          print('Continuing with sign in despite Firestore error');
        }
      }
      
      print('Sign in completed successfully');
    } catch (e) {
      print('Sign in error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      print('Signing out user...');
      await _auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Sign out error: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    try {
      print('Calling FirestoreService.updateUser for user: ${user.id}');
      await _firestoreService.updateUser(user);
      print('Profile update complete for user: ${user.id}');
    } catch (e) {
      print('Error updating user profile: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
} 
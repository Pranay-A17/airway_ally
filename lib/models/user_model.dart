import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'seeker' or 'navigator'
  final String? profileImageUrl;
  final double rating;
  final int completedTrips;
  final List<String> badges;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime lastActive;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImageUrl,
    this.rating = 0.0,
    this.completedTrips = 0,
    this.badges = const [],
    this.preferences = const {},
    required this.createdAt,
    required this.lastActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'seeker',
      profileImageUrl: map['profileImageUrl'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      completedTrips: map['completedTrips'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastActive: (map['lastActive'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'completedTrips': completedTrips,
      'badges': badges,
      'preferences': preferences,
      'createdAt': createdAt,
      'lastActive': lastActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? profileImageUrl,
    double? rating,
    int? completedTrips,
    List<String>? badges,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      completedTrips: completedTrips ?? this.completedTrips,
      badges: badges ?? this.badges,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
} 
enum UserRole { seeker, navigator }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final List<String> languages;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime? lastActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.languages = const [],
    this.preferences = const {},
    required this.createdAt,
    this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      languages: List<String>.from(json['languages'] ?? []),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'languages': languages,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phoneNumber,
    String? profileImageUrl,
    List<String>? languages,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      languages: languages ?? this.languages,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}

class Seeker extends User {
  final String? emergencyContact;
  final String? familyMemberId;
  final List<String> assistanceNeeds;
  final bool isFirstTimeTraveler;

  Seeker({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profileImageUrl,
    super.languages,
    super.preferences,
    required super.createdAt,
    super.lastActive,
    this.emergencyContact,
    this.familyMemberId,
    this.assistanceNeeds = const [],
    this.isFirstTimeTraveler = true,
  }) : super(role: UserRole.seeker);

  factory Seeker.fromJson(Map<String, dynamic> json) {
    return Seeker(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      languages: List<String>.from(json['languages'] ?? []),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
      emergencyContact: json['emergencyContact'] as String?,
      familyMemberId: json['familyMemberId'] as String?,
      assistanceNeeds: List<String>.from(json['assistanceNeeds'] ?? []),
      isFirstTimeTraveler: json['isFirstTimeTraveler'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'emergencyContact': emergencyContact,
      'familyMemberId': familyMemberId,
      'assistanceNeeds': assistanceNeeds,
      'isFirstTimeTraveler': isFirstTimeTraveler,
    };
  }
}

class TravelNavigator extends User {
  final List<String> expertise;
  final int completedTrips;
  final double rating;
  final List<String> badges;
  final bool isVerified;

  TravelNavigator({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.profileImageUrl,
    super.languages,
    super.preferences,
    required super.createdAt,
    super.lastActive,
    this.expertise = const [],
    this.completedTrips = 0,
    this.rating = 0.0,
    this.badges = const [],
    this.isVerified = false,
  }) : super(role: UserRole.navigator);

  factory TravelNavigator.fromJson(Map<String, dynamic> json) {
    return TravelNavigator(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      languages: List<String>.from(json['languages'] ?? []),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
      expertise: List<String>.from(json['expertise'] ?? []),
      completedTrips: json['completedTrips'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      badges: List<String>.from(json['badges'] ?? []),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'expertise': expertise,
      'completedTrips': completedTrips,
      'rating': rating,
      'badges': badges,
      'isVerified': isVerified,
    };
  }
} 
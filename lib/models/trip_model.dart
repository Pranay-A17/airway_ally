import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String userId;
  final String flightNumber;
  final String fromAirport;
  final String toAirport;
  final DateTime departureDate;
  final String departureTime;
  final String? arrivalTime;
  final String status; // 'upcoming', 'in_progress', 'completed', 'cancelled'
  final String? gate;
  final String? terminal;
  final Map<String, dynamic> flightStatus;
  final DateTime createdAt;
  final DateTime? completedAt;

  TripModel({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.fromAirport,
    required this.toAirport,
    required this.departureDate,
    required this.departureTime,
    this.arrivalTime,
    required this.status,
    this.gate,
    this.terminal,
    this.flightStatus = const {},
    required this.createdAt,
    this.completedAt,
  });

  factory TripModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TripModel(
      id: documentId,
      userId: map['userId'] ?? '',
      flightNumber: map['flightNumber'] ?? '',
      fromAirport: map['fromAirport'] ?? '',
      toAirport: map['toAirport'] ?? '',
      departureDate: (map['departureDate'] as Timestamp).toDate(),
      departureTime: map['departureTime'] ?? '',
      arrivalTime: map['arrivalTime'],
      status: map['status'] ?? 'upcoming',
      gate: map['gate'],
      terminal: map['terminal'],
      flightStatus: Map<String, dynamic>.from(map['flightStatus'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'fromAirport': fromAirport,
      'toAirport': toAirport,
      'departureDate': departureDate,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'status': status,
      'gate': gate,
      'terminal': terminal,
      'flightStatus': flightStatus,
      'createdAt': createdAt,
      'completedAt': completedAt,
    };
  }

  TripModel copyWith({
    String? id,
    String? userId,
    String? flightNumber,
    String? fromAirport,
    String? toAirport,
    DateTime? departureDate,
    String? departureTime,
    String? arrivalTime,
    String? status,
    String? gate,
    String? terminal,
    Map<String, dynamic>? flightStatus,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      fromAirport: fromAirport ?? this.fromAirport,
      toAirport: toAirport ?? this.toAirport,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      status: status ?? this.status,
      gate: gate ?? this.gate,
      terminal: terminal ?? this.terminal,
      flightStatus: flightStatus ?? this.flightStatus,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
} 
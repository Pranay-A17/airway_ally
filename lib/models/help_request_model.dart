import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequestModel {
  final String id;
  final String seekerId;
  final String seekerName;
  final String airport;
  final DateTime date;
  final String time;
  final String description;
  final String status; // 'pending', 'accepted', 'completed', 'cancelled'
  final String? navigatorId;
  final String? navigatorName;
  final double seekerRating;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;

  HelpRequestModel({
    required this.id,
    required this.seekerId,
    required this.seekerName,
    required this.airport,
    required this.date,
    required this.time,
    required this.description,
    required this.status,
    this.navigatorId,
    this.navigatorName,
    this.seekerRating = 0.0,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
  });

  factory HelpRequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return HelpRequestModel(
      id: documentId,
      seekerId: map['seekerId'] ?? '',
      seekerName: map['seekerName'] ?? '',
      airport: map['airport'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      navigatorId: map['navigatorId'],
      navigatorName: map['navigatorName'],
      seekerRating: (map['seekerRating'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      acceptedAt: map['acceptedAt'] != null ? (map['acceptedAt'] as Timestamp).toDate() : null,
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seekerId': seekerId,
      'seekerName': seekerName,
      'airport': airport,
      'date': date,
      'time': time,
      'description': description,
      'status': status,
      'navigatorId': navigatorId,
      'navigatorName': navigatorName,
      'seekerRating': seekerRating,
      'createdAt': createdAt,
      'acceptedAt': acceptedAt,
      'completedAt': completedAt,
    };
  }

  HelpRequestModel copyWith({
    String? id,
    String? seekerId,
    String? seekerName,
    String? airport,
    DateTime? date,
    String? time,
    String? description,
    String? status,
    String? navigatorId,
    String? navigatorName,
    double? seekerRating,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
  }) {
    return HelpRequestModel(
      id: id ?? this.id,
      seekerId: seekerId ?? this.seekerId,
      seekerName: seekerName ?? this.seekerName,
      airport: airport ?? this.airport,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      status: status ?? this.status,
      navigatorId: navigatorId ?? this.navigatorId,
      navigatorName: navigatorName ?? this.navigatorName,
      seekerRating: seekerRating ?? this.seekerRating,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
} 
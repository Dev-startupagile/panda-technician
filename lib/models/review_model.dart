import 'dart:convert';

import 'package:panda_technician/models/auth/account.dart';

class ReviewModel {
  final String id;
  final String from;
  final String to;
  final String review;
  final String? requestId;
  final double rating;
  final UserAccount userData;
  DateTime updatedAt;
  DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.from,
    required this.to,
    required this.review,
    this.requestId,
    required this.rating,
    required this.userData,
    required this.updatedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'review': review,
      'requestId': requestId,
      'rating': rating,
      'user_data': userData.toJson(),
      "updatedAt": updatedAt.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      from: map['review_from'] ?? '',
      to: map['review_to'] ?? '',
      review: map['review'] ?? '',
      requestId: map['requestId'],
      rating: (map['rating'] ?? 0) / 1,
      userData: UserAccount.fromMap(map['user_data']),
      updatedAt: DateTime.parse(map["updatedAt"]),
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));
}

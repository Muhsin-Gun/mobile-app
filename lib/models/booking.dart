import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String serviceId;
  final String providerId;
  final String clientId;
  final String clientName;
  final String clientEmail;
  final double totalPrice;
  final String
  status; // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
  final String description;
  final DateTime startDate;
  final DateTime? completedDate;
  final String? paymentId;
  final String paymentStatus; // 'pending', 'completed', 'failed'
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.totalPrice,
    this.status = 'pending',
    required this.description,
    required this.startDate,
    this.completedDate,
    this.paymentId,
    this.paymentStatus = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceId': serviceId,
      'providerId': providerId,
      'clientId': clientId,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'totalPrice': totalPrice,
      'status': status,
      'description': description,
      'startDate': startDate,
      'completedDate': completedDate,
      'paymentId': paymentId,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      serviceId: map['serviceId'] ?? '',
      providerId: map['providerId'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientEmail: map['clientEmail'] ?? '',
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      description: map['description'] ?? '',
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedDate: (map['completedDate'] as Timestamp?)?.toDate(),
      paymentId: map['paymentId'],
      paymentStatus: map['paymentStatus'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String providerId;
  final String title;
  final String description;
  final String category; // 'tutoring', 'design', 'development', 'other'
  final double price;
  final int deliveryDays;
  final List<String> images;
  final double rating;
  final int ordersCount;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.providerId,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.deliveryDays,
    this.images = const [],
    this.rating = 0.0,
    this.ordersCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'providerId': providerId,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'deliveryDays': deliveryDays,
      'images': images,
      'rating': rating,
      'ordersCount': ordersCount,
      'createdAt': createdAt,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? '',
      providerId: map['providerId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      deliveryDays: map['deliveryDays'] ?? 1,
      images: List<String>.from(map['images'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      ordersCount: map['ordersCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

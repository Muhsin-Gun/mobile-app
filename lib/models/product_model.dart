import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String productTitle;
  final String productPrice;
  final String productCategory;
  final String productDescription;
  final String productImage;
  final Timestamp createdAt;
  final double rating;
  final int quantity;
  final List<String> productImages;

  ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productImage,
    required this.createdAt,
    required this.rating,
    required this.quantity,
    required this.productImages,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productPrice': productPrice,
      'productCategory': productCategory,
      'productDescription': productDescription,
      'productImage': productImage,
      'createdAt': createdAt,
      'rating': rating,
      'quantity': quantity,
      'productImages': productImages,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      productTitle: map['productTitle'] ?? '',
      productPrice: map['productPrice'] ?? '',
      productCategory: map['productCategory'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productImage: map['productImage'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt']
          : Timestamp.now(),
      rating: (map['rating'] ?? 0).toDouble(),
      quantity: map['quantity'] is int ? map['quantity'] : 0,
      productImages: List<String>.from(map['productImages'] ?? []),
    );
  }
}


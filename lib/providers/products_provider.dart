import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final List<ProductModel> _products = [];
  final _uuid = const Uuid();

  List<ProductModel> get products => List.unmodifiable(_products);

  Future<void> fetchProducts() async {
    // For now, use in-memory mock data; integrate Firestore if desired.
    if (_products.isNotEmpty) return;
    _products.addAll([
      ProductModel(
        productId: _uuid.v4(),
        productTitle: 'Wireless Headphones',
        productPrice: '129.99',
        productCategory: 'Electronics',
        productDescription: 'Noise-cancelling over-ear headphones',
        productImage:
            'https://images.unsplash.com/photo-1518441902117-f9623a71b2b4?w=400',
        createdAt: Timestamp.now(),
        rating: 4.7,
        quantity: 42,
        productImages: const [],
      ),
      ProductModel(
        productId: _uuid.v4(),
        productTitle: 'Modern Sneakers',
        productPrice: '89.00',
        productCategory: 'Shoes',
        productDescription: 'Lightweight running sneakers with breathable mesh',
        productImage:
            'https://images.unsplash.com/photo-1528701800489-20be9c1f5c4d?w=400',
        createdAt: Timestamp.now(),
        rating: 4.5,
        quantity: 120,
        productImages: const [],
      ),
    ]);
    notifyListeners();
  }

  Future<String?> addProduct(ProductModel product) async {
    final newProduct = product.productId.isEmpty
        ? product.copyWith(productId: _uuid.v4(), createdAt: Timestamp.now())
        : product;
    _products.add(newProduct);
    notifyListeners();
    return null;
  }

  Future<String?> updateProduct(String id, ProductModel product) async {
    final index = _products.indexWhere((p) => p.productId == id);
    if (index == -1) return 'Product not found';
    _products[index] = product.copyWith(productId: id);
    notifyListeners();
    return null;
  }

  Future<String?> deleteProduct(String id) async {
    _products.removeWhere((p) => p.productId == id);
    notifyListeners();
    return null;
  }
}

extension on ProductModel {
  ProductModel copyWith({
    String? productId,
    String? productTitle,
    String? productPrice,
    String? productCategory,
    String? productDescription,
    String? productImage,
    Timestamp? createdAt,
    double? rating,
    int? quantity,
    List<String>? productImages,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productPrice: productPrice ?? this.productPrice,
      productCategory: productCategory ?? this.productCategory,
      productDescription: productDescription ?? this.productDescription,
      productImage: productImage ?? this.productImage,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
      productImages: productImages ?? this.productImages,
    );
  }
}


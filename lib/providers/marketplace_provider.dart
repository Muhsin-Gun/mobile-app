import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:services_marketplace/models/service.dart';
import 'package:services_marketplace/models/service_provider.dart';
import 'package:services_marketplace/models/booking.dart';
import 'package:services_marketplace/models/review.dart';

class MarketplaceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Service> _services = [];
  List<ServiceProvider> _providers = [];
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Service> get services => _services;
  List<ServiceProvider> get providers => _providers;
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all services
  Future<void> fetchServices({String? category}) async {
    _setLoading(true);
    _error = null;
    try {
      Query query = _firestore.collection('services');
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      _services = snapshot.docs
          .map((doc) => Service.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Fetch service providers by category
  Future<void> fetchProviders({String? category}) async {
    _setLoading(true);
    _error = null;
    try {
      Query query = _firestore.collection('serviceProviders');
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.orderBy('rating', descending: true).get();
      _providers = snapshot.docs
          .map(
            (doc) =>
                ServiceProvider.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get single service
  Future<Service?> getService(String serviceId) async {
    try {
      final doc = await _firestore.collection('services').doc(serviceId).get();
      if (doc.exists) {
        return Service.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }

  // Get single provider
  Future<ServiceProvider?> getProvider(String providerId) async {
    try {
      final doc = await _firestore
          .collection('serviceProviders')
          .doc(providerId)
          .get();
      if (doc.exists) {
        return ServiceProvider.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }

  // Create a booking
  Future<Booking?> createBooking({
    required String serviceId,
    required String providerId,
    required String clientId,
    required String clientName,
    required String clientEmail,
    required double totalPrice,
    required String description,
    required DateTime startDate,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final bookingId = _firestore.collection('bookings').doc().id;
      final booking = Booking(
        id: bookingId,
        serviceId: serviceId,
        providerId: providerId,
        clientId: clientId,
        clientName: clientName,
        clientEmail: clientEmail,
        totalPrice: totalPrice,
        description: description,
        startDate: startDate,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .set(booking.toMap());
      notifyListeners();
      return booking;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
    return null;
  }

  // Fetch client bookings
  Future<void> fetchClientBookings(String clientId) async {
    _setLoading(true);
    _error = null;
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('clientId', isEqualTo: clientId)
          .orderBy('createdAt', descending: true)
          .get();

      _bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Fetch provider bookings
  Future<void> fetchProviderBookings(String providerId) async {
    _setLoading(true);
    _error = null;
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('providerId', isEqualTo: providerId)
          .orderBy('createdAt', descending: true)
          .get();

      _bookings = snapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        if (status == 'completed') 'completedDate': DateTime.now(),
      });
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }

  // Add review
  Future<void> addReview({
    required String bookingId,
    required String providerId,
    required String clientId,
    required String clientName,
    required double rating,
    required String comment,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final reviewId = _firestore.collection('reviews').doc().id;
      final review = Review(
        id: reviewId,
        bookingId: bookingId,
        providerId: providerId,
        clientId: clientId,
        clientName: clientName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('reviews').doc(reviewId).set(review.toMap());

      // Update provider rating
      final reviews = await _firestore
          .collection('reviews')
          .where('providerId', isEqualTo: providerId)
          .get();

      double avgRating = 0;
      if (reviews.docs.isNotEmpty) {
        double sum = 0;
        for (var doc in reviews.docs) {
          sum += (doc['rating'] as num).toDouble();
        }
        avgRating = sum / reviews.docs.length;
      }

      await _firestore.collection('serviceProviders').doc(providerId).update({
        'rating': avgRating,
        'reviewsCount': reviews.docs.length,
      });

      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Get reviews for provider
  Future<List<Review>> getProviderReviews(String providerId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('providerId', isEqualTo: providerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

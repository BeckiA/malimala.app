import 'package:flutter/material.dart';
import 'package:waloma/core/model/rating_models/Rating.dart';
import 'package:waloma/core/services/rating_services/rating_api_service.dart';

class ReviewProvider with ChangeNotifier {
  List<RatingModel> _reviews = [];
  bool _isLoading = false;
  List<RatingModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  Future<void> fetchReviews(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reviews = await RatingApiServices.getRatingsByUserId(
        userId: userId,
      );
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Failed to load reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addReview(RatingModel review) {
    _reviews.add(review);
    notifyListeners();
  }
}

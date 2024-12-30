import 'dart:async';

import 'package:flutter/material.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/services/listing_services/listing_api_services.dart';

class ListingsProvider extends ChangeNotifier {
  List<Listings> _listings = [];
  bool _isLoading = false;

  List<Listings> get listings => _listings;
  bool get isLoading => _isLoading;

  ListingsProvider() {
    fetchListings(); // Fetch listings initially when provider is created
  }

  Future<void> fetchListings() async {
    _isLoading = true;
    notifyListeners();

    try {
      _listings = await ListingService.fetchListings();
    } catch (e) {
      print("Failed to fetch listings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchListingsByCategory(String categoryPath) async {
    _isLoading = true;
    notifyListeners();

    try {
      _listings = await ListingService.fetchListingsByCategory(categoryPath);
    } catch (e) {
      print("Error fetching listings by category: $e");
      _listings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Call this method to refresh listings, if needed
  Future<void> refreshListings() async {
    await fetchListings();
  }
}

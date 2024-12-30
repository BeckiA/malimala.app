import 'dart:convert';
import 'dart:io';

class ListingRequestModel {
  int? userId;
  String? listingType;
  String? title;
  String? description;
  String? location;
  int? price;
  Details? details;
  String? contactNumber;
  List<File>? listingImages; // For image paths as strings if needed

  ListingRequestModel({
    required this.userId,
    required this.listingType,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.contactNumber,
    this.details,
    this.listingImages, // Initialize the field for listing images
  });

  ListingRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    listingType = json['listing_type'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
    price = json['price'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    contactNumber = json['contact_number'];
    listingImages = json['listing_images'] != null
        ? List<File>.from(json['listing_images'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['listing_type'] = listingType;
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    data['price'] = price;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['contact_number'] = contactNumber;
    if (listingImages != null) {
      data['listing_images'] =
          jsonEncode(listingImages); // Encode as JSON string
    }
    return data;
  }
}

class Details {
  Map<String, dynamic> additionalFields = {};

  Details.fromJson(Map<String, dynamic> json) {
    additionalFields = json; // Store all incoming fields
  }

  Map<String, dynamic> toJson() {
    return additionalFields;
  }
}

import 'dart:convert';

class Listings {
  final int id;
  final int userId;
  final String listingType;
  final String title;
  final String description;
  final List<String> listingImages;
  final String location;
  final String price;
  final String contactNumber;
  final String uniqueCode;
  final Map<String, dynamic> details;
  final DateTime createdAt;
  final DateTime updatedAt;

  Listings({
    required this.id,
    required this.userId,
    required this.listingType,
    required this.title,
    required this.description,
    required this.listingImages,
    required this.location,
    required this.price,
    required this.contactNumber,
    required this.uniqueCode,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Listings.fromJson(Map<String, dynamic> json) {
    return Listings(
      id: json['id'],
      userId: json['user_id'],
      listingType: json['listing_type'],
      title: json['title'],
      description: json['description'],
      listingImages: List<String>.from(json['listing_images']),
      location: json['location'],
      price: json['price'].toString(),
      contactNumber: json['contact_number'],
      uniqueCode: json['unique_code'],
      details: json['details'] is String
          ? jsonDecode(json['details'])
          : json['details'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

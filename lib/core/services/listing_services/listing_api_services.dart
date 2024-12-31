import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_request_model.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';

class ListingService {
  static var client = http.Client();

  static Future<Map<String, dynamic>> createListing(
      ListingRequestModel listingData, List<File> images) async {
    try {
      var url = Uri.http(AppConfiguration.apiURL, AppConfiguration.listingsAPI);

      final request = http.MultipartRequest("POST", url);

      // Add listing fields as required by the backend
      request.fields['user_id'] = listingData.userId?.toString() ?? "";
      request.fields['listing_type'] = listingData.listingType ?? "";
      request.fields['title'] = listingData.title ?? "";
      request.fields['description'] = listingData.description ?? "";
      request.fields['location'] = listingData.location ?? "";
      request.fields['price'] = listingData.price?.toString() ?? "";
      request.fields['contact_number'] = listingData.contactNumber ?? "";

      // Try sending details directly if backend expects JSON structure rather than string
      request.fields['details'] =
          jsonEncode(listingData.details?.toJson() ?? {});

      // Attach images
      for (var image in images) {
        final mimeTypeData = lookupMimeType(image.path)?.split('/');
        final file = await http.MultipartFile.fromPath(
          'listing_images',
          image.path,
          contentType: mimeTypeData != null
              ? MediaType(mimeTypeData[0], mimeTypeData[1])
              : MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      }

      print("Request Fields: ${request.fields}");
      print("Request Files: ${request.files.map((file) => file.filename)}");

      // Send request and log response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Backend validation failed: ${response.body}");
        return {
          "success": false,
          "message": "Failed to create listing. Please try again later.",
          "error": jsonDecode(response.body)['error'] ?? "Unknown error"
        };
      }
    } catch (error) {
      print("Error creating listing: $error");
      return {
        "success": false,
        "message": "An error occurred while creating the listing: $error"
      };
    }
  }

  static Future<Map<String, dynamic>> updateListing(
    int listingId,
    ListingRequestModel listingData,
    List<File>? newImages, {
    required List<String> retainedImages, // Required retained images
  }) async {
    try {
      // Construct the API endpoint URL
      var url = Uri.http(AppConfiguration.apiURL, '/api/listings/$listingId');

      // Create a multipart request for a PUT method
      final request = http.MultipartRequest("PUT", url);

      // Add listing fields from the model to the request
      request.fields['user_id'] = listingData.userId?.toString() ?? "";
      request.fields['listing_type'] = listingData.listingType ?? "";
      request.fields['title'] = listingData.title ?? "";
      request.fields['description'] = listingData.description ?? "";
      request.fields['location'] = listingData.location ?? "";
      request.fields['price'] = listingData.price?.toString() ?? "";
      request.fields['contact_number'] = listingData.contactNumber ?? "";

      // Add details as a JSON string if provided
      if (listingData.details != null) {
        request.fields['details'] = jsonEncode(listingData.details!.toJson());
      }

      // Handle retained images (existing images the user wants to keep)
      request.fields['retained_images'] = jsonEncode(retainedImages);

      // Attach new images to the request
      if (newImages != null && newImages.isNotEmpty) {
        for (var image in newImages) {
          final mimeTypeData = lookupMimeType(image.path)?.split('/');
          final file = await http.MultipartFile.fromPath(
            'listing_images', // Backend expects this for newly added images
            image.path,
            contentType: mimeTypeData != null
                ? MediaType(mimeTypeData[0], mimeTypeData[1])
                : MediaType('image', 'jpeg'),
          );
          request.files.add(file);
        }
      }

      // Debugging: Log request data
      print("Request Fields: ${request.fields}");
      print("Request Files: ${request.files.map((file) => file.filename)}");

      // Send the request to the server
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Debugging: Log the server response
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Handle the response based on the status code
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": jsonDecode(response.body),
        };
      } else {
        // Parse the error from the backend response
        final errorResponse = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorResponse['message'] ?? "Failed to update listing.",
          "error": errorResponse['error'] ?? "Unknown error",
        };
      }
    } catch (error) {
      // Catch unexpected errors and log them
      print("Error updating listing: $error");
      return {
        "success": false,
        "message": "An error occurred while updating the listing.",
        "error": error.toString(),
      };
    }
  }

  static Future<List<Listings>> fetchListings() async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      var url = Uri.http(AppConfiguration.apiURL, '/api/listings/');

      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Inside your fetchListings method
        if (data['success']) {
          List<dynamic> listingsJson = data['listings'];
          return listingsJson.map((json) {
            // Normalize image paths to use forward slashes
            List<dynamic> normalizedImages = (json['listing_images'] as List)
                .map((imgPath) => (imgPath as String).replaceAll('\\', '/'))
                .toList();
            json['listing_images'] = normalizedImages;

            return Listings.fromJson(json);
          }).toList();
        } else {
          throw Exception("Failed to load listings");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching listings: $e");
      return [];
    }
  }

  static Future<List<Listings>> fetchListingsByCategory(
      String categoryPath) async {
    try {
      List<Listings> allListings = await fetchListings();
      return allListings
          .where((listing) => listing.listingType == categoryPath)
          .toList();
    } catch (e) {
      print("Error filtering listings by category: $e");
      return [];
    }
  }

  // Delete listing function
  static Future<Map<String, dynamic>> deleteListing(int listingId) async {
    try {
      // Construct the API endpoint URL
      var url = Uri.http(AppConfiguration.apiURL, '/api/listings/$listingId');

      // Send DELETE request
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        // Success response
        return {
          "success": true,
          "message": "Listing deleted successfully",
        };
      } else if (response.statusCode == 404) {
        // Not found response
        return {
          "success": false,
          "message": "Listing not found",
        };
      } else {
        // Other errors
        return {
          "success": false,
          "message": jsonDecode(response.body)['message'] ?? "Unknown error",
        };
      }
    } catch (error) {
      print("Error deleting listing: $error");
      return {
        "success": false,
        "message": "An unexpected error occurred while deleting the listing.",
        "error": error.toString(),
      };
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/rating_models/Rating.dart';
import 'package:waloma/core/model/rating_models/rating_request_model.dart';

class RatingApiServices {
  static var client = http.Client();

  static Future<Map<String, dynamic>> createRatingReview(
      RatingRequestModel ratingData) async {
    try {
      var url = Uri.http(AppConfiguration.apiURL, AppConfiguration.ratingAPI);

      final request = http.Request("POST", url)
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode(ratingData.toJson());

      final response = await client.send(request);
      // print("RESPONSE CODE: ${response.statusCode}");
      // print("RESPONSE BODY: ${response}");
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        final errorResponse = await response.stream.bytesToString();
        throw Exception(jsonDecode(errorResponse)['message']);
      }
    } catch (e) {
      throw Exception("Error creating rating: $e");
    }
  }

  static Future<List<RatingModel>> getRatingsByUserId(
      {required int userId}) async {
    try {
      var url = Uri.http(
        AppConfiguration.apiURL,
        '${AppConfiguration.ratingAPI}/user/$userId',
      );

      final response = await client.get(url);

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final responseBody = jsonDecode(response.body);
          // print("RESPONSE BODY DURING FETCH: $responseBody");

          return (responseBody['data'] as List)
              .map((rating) => RatingModel.fromJson(rating))
              .toList();
        } else {
          throw Exception(
              "Unexpected content type: ${response.headers['content-type']}");
        }
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception("Error fetching ratings: $e");
    }
  }

  static Future<void> deleteRating(String id) async {
    try {
      var url = Uri.http(
          AppConfiguration.apiURL, '${AppConfiguration.ratingAPI}/$id');

      final response = await client.delete(url);

      if (response.statusCode != 204) {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      throw Exception("Error deleting rating: $e");
    }
  }
}

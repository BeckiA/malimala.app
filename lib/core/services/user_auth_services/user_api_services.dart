import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/user_models/user_login_request_model.dart';
import 'package:waloma/core/model/user_models/user_registration_request_model.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import '../../model/user_models/user_login_response_model.dart';

class UserAPIService {
  static var client = http.Client();

  static Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Updated login method
  static Future<Map<String, dynamic>> login(UserLoginRequestModel model) async {
    bool hasInternet = await isConnectedToInternet();

    if (!hasInternet) {
      return {
        'success': false,
        'errors': {
          'message':
              'No internet connection. Please check your network and try again.'
        }
      };
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      AppConfiguration.apiURL,
      AppConfiguration.loginAPI,
    );

    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await SharedService.setLoginDetails(
          loginResponseJson(response.body),
        );

        return {
          'success': true,
        };
      } else {
        // Capture and return error messages
        final responseData = jsonDecode(response.body);
        print("ERRRRRRRRR $responseData");

        if (responseData['success'] == false) {
          return {
            'success': false,
            'errors': responseData['message'] ?? 'Unknown error',
          };
        } else {
          return {
            'success': false,
            'errors': 'Unexpected error format',
          };
        }
      }
    } catch (e) {
      // Handle network errors and other exceptions

      return {
        'success': false,
        'errors': 'Unable to connect to the server. Please try again.'
      };
    }
  }

  // Updated register method
  static Future<Map<String, dynamic>> register(
      UserRegistrationRequestModel model) async {
    bool hasInternet = await isConnectedToInternet();

    if (!hasInternet) {
      return {
        'success': false,
        'errors': {
          'No internet connection. Please check your network and try again.'
        }
      };
    }

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      AppConfiguration.apiURL,
      AppConfiguration.registerAPI,
    );

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        return {
          'success': true,
          'user': decodedResponse['user'],
        };
      } else {
        final decodedResponse = jsonDecode(response.body);
        final errors = decodedResponse['errors'] as List? ?? [];

        Map<String, String> errorMessages = {};
        for (var error in errors) {
          String param = error['param'] ?? 'unknown';
          String msg = error['msg'] ?? 'Unknown error';
          errorMessages[param] = msg;
        }

        return {'success': false, 'errors': errorMessages};
      }
    } catch (e) {
      print("API Error: $e");
      return {
        'success': false,
        'apiError': 'Unable to connect to the server. Please try again.'
      };
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      int userId, UserRegistrationRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      AppConfiguration.apiURL,
      "/api/users/$userId",
    );

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    final decodedResponse = jsonDecode(response.body);
    print(decodedResponse);

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(response.body),
      );
      // User profile updated successfully
      return jsonDecode(response.body);
    } else {
      // Handle error response (safely handle null values)
      final decodedResponse = jsonDecode(response.body);
      final errors = decodedResponse['errors'] as List? ??
          []; // Use a safe fallback to an empty list

      Map<String, String> errorMessages = {};
      for (var error in errors) {
        // Safely handle missing param and msg keys
        String param = error['param'] ?? 'unknown';
        String msg = error['msg'] ?? 'Unknown error';
        errorMessages[param] = msg;
      }

      return {'success': false, 'errors': errorMessages};
    }
  }

  // Update profile image
  static Future<Map<String, dynamic>> updateProfileImage(
      int userId, File imageFile) async {
    final url = Uri.http(AppConfiguration.apiURL, "/api/users/$userId/profile");
    final request = http.MultipartRequest("PUT", url);

    // Attach image file
    request.files.add(await http.MultipartFile.fromPath(
      'profile_image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print("FROM UPDATE profile image: ${jsonDecode(response.body)}");
    return jsonDecode(response.body);
  }

  // Fetch user profile image
  static Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final url = Uri.http(AppConfiguration.apiURL, "/api/users/$userId");
    final response = await client.get(url);
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

  // Method to send OTP
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await client.post(
      Uri.http(AppConfiguration.apiURL, AppConfiguration.sendOtpAPI),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      // OTP sent successfully
      return {'success': true, 'message': 'OTP sent successfully'};
    } else {
      // Handle error
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to send OTP'
      };
    }
  }

  // Function to verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    print("$email, $otp");
    final response = await client.post(
      Uri.http(AppConfiguration.apiURL, AppConfiguration.verifyOtpAPI),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      // OTP verification was successful
      final responseData = jsonDecode(response.body);

      return responseData;
    } else {
      // Handle the error
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'OTP verification failed',
      };
    }
  }

  static Future<Map<String, dynamic>> changePassword(
      int userId, String currentPassword, String newPassword) async {
    // Construct the correct URL with the user ID in the path
    final url =
        Uri.http(AppConfiguration.apiURL, '/api/users/$userId/change-password');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
    });

    print("API change password request body: $body");

    try {
      final response = await http.put(url, headers: headers, body: body);

      // Check if the response is JSON
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message':
                responseBody['message'] ?? 'Password updated successfully',
          };
        } else {
          return {
            'success': false,
            'message': responseBody['message'] ?? 'An error occurred',
          };
        }
      } else {
        print("Unexpected response format: ${response.body}");
        return {'success': false, 'message': 'Unexpected response format'};
      }
    } catch (e) {
      print("Error in changePassword: $e");
      return {'success': false, 'message': 'Failed to parse response'};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String token, String newPassword) async {
    final response = await client.post(
      Uri.http(AppConfiguration.apiURL, AppConfiguration.resetPassword),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"email": email, "reset_token": token, "new_password": newPassword}),
    );

    if (response.statusCode == 200) {
      // Password reset was successful
      return {'success': true, 'message': 'Password reset successfully'};
    } else {
      // Handle the error
      final responseData = jsonDecode(response.body);
      return {
        'success': false,
        'message': responseData['message'] ?? 'Failed to reset password',
      };
    }
  }
}

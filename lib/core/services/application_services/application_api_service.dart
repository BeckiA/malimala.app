import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/application_models/application_model.dart';

class ApplicationAPIService {
  static var client = http.Client();

  static Future<Map<String, dynamic>> apply(Application model, File cvDocument,
      File coverLetter, List<File> additionalDocuments, String token) async {
    var url = Uri.http(
      AppConfiguration.apiURL,
      AppConfiguration.applyAPI,
    );

    try {
      var request = http.MultipartRequest('POST', url);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add user details as fields
      request.fields['jobId'] = model.listingId.toString();
      request.fields['firstName'] = model.firstName;
      request.fields['lastName'] = model.lastName;
      request.fields['email'] = model.email;
      request.fields['phone'] = model.phone;
      // if (model.userType != null) request.fields['user_type'] = model.userType!;
      if (model.education != null) {
        var educationList = model.education.map((education) {
          return {
            'degree': education.degree,
            'institution': education.institution,
            'graduation': education.graduation.toString(),
            'gpa': education.gpa.toString(),
          };
        }).toList();
        request.fields['education'] = jsonEncode(educationList);
      }

      // Add single files
      var cvStream = http.ByteStream(cvDocument.openRead());
      var cvLength = await cvDocument.length();
      var cvMultipartFile = http.MultipartFile(
        'documents[cv]', // Key expected by the backend
        cvStream,
        cvLength,
        filename: cvDocument.path.split('/').last,
      );
      request.files.add(cvMultipartFile);

      var coverLetterStream = http.ByteStream(coverLetter.openRead());
      var coverLetterLength = await coverLetter.length();
      var coverLetterMultipartFile = http.MultipartFile(
        'documents[coverLetter]', // Key expected by the backend
        coverLetterStream,
        coverLetterLength,
        filename: coverLetter.path.split('/').last,
      );
      request.files.add(coverLetterMultipartFile);

      // Add additional files
      for (var file in additionalDocuments) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'documents[additional]', // Key expected by the backend
          stream,
          length,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      // Debug: Print request data
      print("Fields: ${request.fields}");
      print("Files: ${request.files.map((file) => file.filename)}");

      var response = await request.send();

      print("ORIGINAL Response YES YES: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await http.Response.fromStream(response);
        print("From the IF response:  $response");

        final decodedResponse = jsonDecode(responseBody.body);
        return {
          'success': true,
          'user': decodedResponse['user'],
        };
      } else {
        final responseBody = await http.Response.fromStream(response);
        print("From the ELSE response:  $response");
        final decodedResponse = jsonDecode(responseBody.body);
        return {
          'success': false,
          'errors': decodedResponse['message'] ?? 'Unknown error occurred'
        };
      }
    } catch (e) {
      print("API Error: $e");
      return {
        'success': false,
        'apiError': 'Unable to connect to the server. Please try again.'
      };
    }
  }
}

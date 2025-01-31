import 'dart:convert';

class Application {
  final int? userId;
  final int listingId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final List<dynamic> education;
  final String? cvPath;
  final String? coverLetterPath;
  final List<dynamic>? additionalDocuments;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Application({
    this.userId,
    required this.listingId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.education,
    this.cvPath,
    this.coverLetterPath,
    this.additionalDocuments,
    this.status = "pending",
    this.createdAt,
    this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      userId: json['id'],
      listingId: json['jobId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      education: jsonDecode(json['education']),
      cvPath: json['cv_path'],
      coverLetterPath: json['coverLetter_path'],
      additionalDocuments: json['additional_documents'] != null
          ? jsonDecode(json['additional_documents'])
          : [],
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": userId,
      "jobId": listingId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "education": jsonEncode(education),
      // "cv_path": cvPath,
      // "coverLetter_path": coverLetterPath,
      // "additional_documents": jsonEncode(additionalDocuments ?? []),
      // "status": status,
    };
  }
}

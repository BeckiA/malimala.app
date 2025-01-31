// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// class ApplicationFilesUploadState extends StatefulWidget {
//   // final UserRegistrationRequestModel userModel;

//   const ApplicationFilesUploadState({Key? key}) : super(key: key);

//   @override
//   _ApplicationFilesUploadStateState createState() =>
//       _ApplicationFilesUploadStateState();
// }

// class _ApplicationFilesUploadStateState
//     extends State<ApplicationFilesUploadState> {
//   File? _cvFile;
//   File? _coverLetterFile;
//   List<File> _additionalFiles = [];
//   bool isLoading = false;
//   String uploadError = '';

//   Future<void> selectFile(String fileType) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null && result.files.isNotEmpty) {
//       setState(() {
//         File selectedFile = File(result.files.first.path!);

//         if (fileType == 'cv') {
//           _cvFile = selectedFile;
//         } else if (fileType == 'coverLetter') {
//           _coverLetterFile = selectedFile;
//         }
//       });
//     }
//   }

//   Future<void> selectAdditionalFiles() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//       allowMultiple: true,
//     );

//     if (result != null) {
//       setState(() {
//         for (var file in result.files) {
//           if (_additionalFiles.length >= 5) {
//             showToast('You can only upload up to 5 additional files.',
//                 context: context);
//             break;
//           }
//           _additionalFiles.add(File(file.path!));
//         }
//       });
//     }
//   }

//   Future<void> uploadFilesAndRegister() async {
//     if (_cvFile == null || _coverLetterFile == null) {
//       showToast('Please upload both CV and Cover Letter.', context: context);
//       return;
//     }
//     setState(() {
//       isLoading = true;
//       uploadError = '';
//     });

//     try {
//       // final registerResponse = await UserAPIService.register(
//       //   widget.userModel,
//       //   [_cvFile!, _coverLetterFile!, ..._additionalFiles],
//       // );

//       // if (registerResponse['success']) {
//       //   final otpResponse = await UserAPIService.sendOtp(
//       //     registerResponse['user']['email'],
//       //   );
//       //   if (otpResponse['success']) {
//       //     Navigator.pushReplacement(
//       //       context,
//       //       MaterialPageRoute(
//       //         builder: (context) =>
//       //             OTPVerificationPage(email: widget.userModel.email.toString()),
//       //       ),
//       //     );
//       //   } else {
//       //     throw Exception('Failed to send OTP.');
//       //   }
//       // } else {
//       //   throw Exception(registerResponse['errors'] ?? 'Registration failed.');
//       // }
//     } catch (e) {
//       setState(() {
//         uploadError = e.toString();
//       });
//       showToast('An error occurred: $e', context: context);
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Your Documents',
//             style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildFileUploadTile(
//                 'Upload CV/Resume', _cvFile, () => selectFile('cv')),
//             _buildFileUploadTile('Upload Cover Letter', _coverLetterFile,
//                 () => selectFile('coverLetter')),
//             _buildFileUploadTile('Upload Additional Documents (Max 5)', null,
//                 selectAdditionalFiles),
//             if (_additionalFiles.isNotEmpty)
//               Column(
//                 children: _additionalFiles.map((file) {
//                   return ListTile(
//                     title: Text(file.path.split('/').last),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         setState(() {
//                           _additionalFiles.remove(file);
//                         });
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             SizedBox(height: 20),
//             if (uploadError.isNotEmpty)
//               Text(uploadError, style: TextStyle(color: Colors.red)),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : uploadFilesAndRegister,
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text('Submit and Register'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

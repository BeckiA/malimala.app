import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/user_models/user_registration_request_model.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/views/screens/otp_verification_page.dart';

class BrokerFileUpload extends StatefulWidget {
  final UserRegistrationRequestModel userModel;

  const BrokerFileUpload({Key? key, required this.userModel}) : super(key: key);

  @override
  _BrokerFileUploadState createState() => _BrokerFileUploadState();
}

class _BrokerFileUploadState extends State<BrokerFileUpload>
    with SingleTickerProviderStateMixin {
  late AnimationController loadingController;
  List<PlatformFile> _selectedFiles = [];
  List<File> _fileObjects = [];
  bool isLoading = false;
  String uploadError = '';

  Future<void> selectFiles() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'png', 'jpg', 'jpeg'],
          allowMultiple: true,
        );

        if (result != null) {
          for (var file in result.files) {
            if (_selectedFiles.length >= 5) {
              showToast(
                'You can only upload up to 5 files.',
                context: context,
                position: StyledToastPosition.bottom,
              );
              break;
            }

            if (_selectedFiles.any((f) => f.name == file.name)) {
              showToast(
                'Duplicate file "${file.name}" removed automatically.',
                context: context,
                position: StyledToastPosition.bottom,
              );
              continue;
            }

            setState(() {
              _selectedFiles.add(file);
              _fileObjects.add(File(file.path!));
            });
          }
          loadingController.forward();
        }
      } catch (e) {
        print('Error picking files: $e');
      }
    } else {
      print('Permission denied');
    }
  }

  Future<void> uploadFilesAndRegister() async {
    if (_selectedFiles.isEmpty) {
      showToast(
        'Please upload at least one file.',
        context: context,
        position: StyledToastPosition.bottom,
      );
      return;
    }
    print("HEY HEY: ${_fileObjects}");
    setState(() {
      isLoading = true;
      uploadError = '';
    });

    try {
      // Pass the user model and selected files to the register API
      final registerResponse = await UserAPIService.register(
        widget.userModel,
        _fileObjects, // Pass the files directly to the register method
      );
      print("Register response: $registerResponse");
      if (registerResponse['success']) {
        // Handle OTP sending process
        final otpResponse = await UserAPIService.sendOtp(
          registerResponse['user']['email'],
        );
        if (otpResponse['success']) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPVerificationPage(email: widget.userModel.email.toString()),
            ),
          );
        } else {
          throw Exception('Failed to send OTP.');
        }
      } else {
        final error = registerResponse['apiError'] ??
            registerResponse['errors'] ??
            'Registration failed.';
        print("YAY! Registration failed, AND I'M THE ERROR: " + error);
        throw Exception(error);
      }
    } catch (e) {
      setState(() {
        uploadError = e.toString();
      });
      showToast(
        'An error occurred: $e',
        context: context,
        position: StyledToastPosition.bottom,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Upload Your Valid Documents',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  'Upload your files',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Files should be jpg, png, pdf, doc. Max 5 files.',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: selectFiles,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20.0),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      color: AppColor.primary,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColor.primarySoft.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/Document.svg',
                                color: AppColor.primary, width: 50),
                            const SizedBox(height: 15),
                            Text(
                              'Select your files',
                              style: TextStyle(
                                  fontSize: 15, color: AppColor.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedFiles.isNotEmpty
                    ? Column(
                        children: _selectedFiles.map((file) {
                          final index = _selectedFiles.indexOf(file);
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                if (file.extension == 'pdf')
                                  Image.asset(
                                    'assets/images/placeholders/pdf.png',
                                    width: 70,
                                  )
                                else if (file.extension == 'doc' ||
                                    file.extension == 'docx')
                                  Image.asset(
                                    'assets/images/placeholders/doc.png',
                                    width: 70,
                                  )
                                else
                                  const Icon(Icons.insert_drive_file,
                                      color: Colors.blue, size: 40),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${(file.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 5,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue.shade50,
                                        ),
                                        child: LinearProgressIndicator(
                                            value: loadingController.value),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedFiles.removeAt(index);
                                      _fileObjects.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Text(
                        'No file chosen.',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                const SizedBox(height: 20),
                if (uploadError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      uploadError,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 18),
                        primary: AppColor.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: isLoading ? null : uploadFilesAndRegister,
                      child: isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Submitting',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                LoadingAnimationWidget.waveDots(
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            )
                          : const Text(
                              'Submit and Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: 'poppins',
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

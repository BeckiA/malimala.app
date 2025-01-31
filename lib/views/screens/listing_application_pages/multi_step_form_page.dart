import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/application_models/application_model.dart';
import 'package:waloma/core/services/application_services/application_api_service.dart';

class MultiStepFormPage extends StatefulWidget {
  final int listingId;
  final int currentUserId;
  final String token;
  MultiStepFormPage(
      {Key? key,
      required this.listingId,
      required this.currentUserId,
      required this.token});
  @override
  _MultiStepFormPageState createState() => _MultiStepFormPageState();
}

class _MultiStepFormPageState extends State<MultiStepFormPage> {
  int _currentStep = 0;
  String? phoneNumberValue;
  String? firstName;
  String? lastName;
  String? email;
  String? institutionName;
  String? degreeLevel;
  double? grade;
  // Controllers for form fields
  final _formKey = GlobalKey<FormBuilderState>();
  File? _cvFile;
  File? _coverLetterFile;
  List<File> _additionalFiles = [];
  bool isLoading = false;
  String uploadError = '';

  Future<void> selectFile(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        File selectedFile = File(result.files.first.path!);

        if (fileType == 'cv') {
          _cvFile = selectedFile;
        } else if (fileType == 'coverLetter') {
          _coverLetterFile = selectedFile;
        }
      });
    }
  }

  Future<void> selectAdditionalFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (_additionalFiles.length >= 5) {
            showToast('You can only upload up to 5 additional files.',
                context: context);
            break;
          }

          if (_additionalFiles.any((f) => f.path == file.path)) {
            showToast(
              'The file "${file.name}" already exists in the upload.',
              context: context,
              backgroundColor: Colors.redAccent,
            );
            continue;
          }

          _additionalFiles.add(File(file.path!));
        }
      });
    }
  }

  Future<void> uploadFilesAndRegister() async {
    if (_cvFile == null || _coverLetterFile == null) {
      showToast('Please upload both CV and Cover Letter.', context: context);
      return;
    }
    setState(() {
      isLoading = true;
      uploadError = '';
    });

    Application applicationModel = Application(
        firstName: firstName!,
        lastName: lastName!,
        phone: phoneNumberValue!,
        listingId: widget.listingId,
        userId: widget.currentUserId,
        email: email!,
        education: [
          Education(
            degree: degreeLevel!,
            institution: institutionName!,
            graduation: _formKey.currentState?.fields['graduation']?.value,
            gpa: grade!,
          ),
        ]);

    try {
      final applyResponse = await ApplicationAPIService.apply(
        applicationModel,
        _cvFile!,
        _coverLetterFile!,
        _additionalFiles,
        widget.token,
      );

      if (applyResponse['success']) {
        // final otpResponse = await UserAPIService.sendOtp(
        //   registerResponse['user']['email'],
        // );
        // if (otpResponse['success']) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           OTPVerificationPage(email: widget.userModel.email.toString()),
        //     ),
        //   );
        // } else {
        //   throw Exception('Failed to send OTP.');
        // }
        print("Successfully applied");
      } else {
        throw Exception(applyResponse['errors'] ?? 'Application failed.');
      }
    } catch (e) {
      setState(() {
        uploadError = e.toString();
      });
      showToast('An error occurred: $e', context: context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Please fill your personal details',
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
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.primary,
            onPrimary: Colors.white,
            surface: AppColor.primary,
          ),
        ),
        child: FormBuilder(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                if (validateAndSave()) {
                  setState(() => _currentStep++);
                }
              } else {
                _submitForm();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (_currentStep != 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Previous Step'),
                        style: OutlinedButton.styleFrom(
                          primary: AppColor.primary,
                        ),
                      ),
                    const SizedBox(width: 8),
                    _currentStep == 2
                        ? SizedBox()
                        : ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text('Next Step'),
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.primary,
                            ),
                          ),
                  ],
                ),
              );
            },
            steps: [
              // Step 1: Personal Details
              Step(
                title: const Text("Step 1"),
                content: Column(
                  children: [
                    _textField(
                      "first_name",
                      "First Name",
                      "Enter your first name",
                      initialValue: "",
                    ),
                    _textField(
                      "last_name",
                      "Last Name",
                      "Enter your last name",
                      initialValue: "",
                    ),
                    _textField(
                      "email",
                      "Email",
                      "Enter your email address",
                      initialValue: "",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _phoneField(),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              // Step 2: Educational Background
              Step(
                title: const Text("Step 2"),
                content: Column(
                  children: [
                    _textField(
                      "degree",
                      "Degree",
                      "Enter your degree",
                      initialValue: "",
                    ),
                    _textField(
                      "institution",
                      "Institution",
                      "Enter your institution name",
                      initialValue: "",
                    ),
                    _datePickerField(
                      "graduation",
                      "Select your graduation year",
                      "Graduation Year",
                      initialDate: DateFormat('yyyy').format(DateTime.now()),
                    ),
                    _textField(
                      "gpa",
                      "GPA",
                      "Enter your GPA",
                      initialValue: "",
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              // Step 3: Document Uploads
              Step(
                title: const Text("Step 3"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFileUploadTile(
                        'Upload CV/Resume', _cvFile, () => selectFile('cv')),
                    _buildFileUploadTile('Upload Cover Letter',
                        _coverLetterFile, () => selectFile('coverLetter')),
                    _buildFileUploadTile('Upload Additional Documents (Max 5)',
                        null, selectAdditionalFiles),
                    if (_additionalFiles.isNotEmpty)
                      Column(
                        children: _additionalFiles.map((file) {
                          final index = _additionalFiles.indexOf(file);
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
                                if (['png', 'jpg', 'jpeg']
                                    .contains(file.path.split('.').last))
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      file,
                                      width: 70,
                                    ),
                                  )
                                else if (file.path.split('.').last == 'pdf')
                                  Image.asset(
                                    'assets/images/placeholders/pdf.png',
                                    width: 70,
                                  )
                                else if (file.path.split('.').last == 'doc' ||
                                    file.path.split('.').last == 'docx')
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
                                        file.path.split('/').last,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${(file.lengthSync() / 1024).ceil()} KB',
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
                                        child:
                                            LinearProgressIndicator(value: 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _additionalFiles.remove(file);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 20),
                    if (uploadError.isNotEmpty)
                      Text(uploadError, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : uploadFilesAndRegister,
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Submit and Apply'),
                      ),
                    ),
                  ],
                ),
                isActive: _currentStep >= 2,
                state: StepState.indexed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create Text input form field
  Widget _textField(
    String name,
    String label,
    String hintText, {
    required String initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    int maxLength = 300,
  }) {
    return Column(
      children: [
        FormBuilderTextField(
            name: name,
            initialValue: initialValue,
            keyboardType: keyboardType,
            decoration: _inputDecoration(label, hintText),
            validator: (onValidateVal) {
              if (onValidateVal == null || onValidateVal.isEmpty) {
                return '$label can\'t be empty.';
              }
              if (name == 'email' &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(onValidateVal)) {
                return 'Please enter a valid email address.';
              }
              if (name == 'gpa') {
                final gpa = double.tryParse(onValidateVal);
                if (gpa == null || gpa < 1.00 || gpa > 4.00) {
                  return 'Please enter a GPA between 1.00 and 4.00.';
                }
              }
              return null;
            },
            onSaved: (onSavedVal) {
              if (name == 'first_name') firstName = onSavedVal ?? '';
              if (name == 'last_name') lastName = onSavedVal ?? '';
              if (name == 'email') email = onSavedVal ?? '';
              if (name == 'degree') degreeLevel = onSavedVal ?? '';
              if (name == 'institution') institutionName = onSavedVal ?? '';
              if (name == 'gpa')
                grade = onSavedVal != null ? double.tryParse(onSavedVal) : null;
            }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFileUploadTile(String title, File? file, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        color: AppColor.primary,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColor.primarySoft.withOpacity(0.75),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/Document.svg',
                    color: AppColor.primary, width: 40),
                const SizedBox(height: 10),
                Text(
                  file != null ? file.path.split('/').last : title,
                  style: TextStyle(fontSize: 15, color: AppColor.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create DatePicker form field
  Widget _datePickerField(String name, String hintText, String labelText,
      {required String initialDate}) {
    return Column(
      children: [
        FormBuilderTextField(
          name: name,
          initialValue: initialDate,
          decoration: _inputDecoration(labelText, hintText),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
              errorText: 'Please enter $labelText',
            ),
            FormBuilderValidators.numeric(
              errorText: 'Please enter a valid year',
            ),
            (value) {
              if (value == null) return null;
              final year = int.tryParse(value.toString());
              if (year == null || year < 2000 || year > DateTime.now().year) {
                return 'Please enter a year between 2000 and ${DateTime.now().year}';
              }
              return null;
            },
          ]),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper method to create phone input field
  Widget _phoneField() {
    return IntlPhoneField(
      style: const TextStyle(fontSize: 16.0),
      decoration: _inputDecoration("Phone Number", "Enter your phone number"),
      initialCountryCode: "ET",
      onChanged: (phone) {
        phoneNumberValue = phone.completeNumber;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      invalidNumberMessage: "Invalid phone number",
      validator: (value) {
        if (value!.number == null || value.completeNumber.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  // Helper method for consistent InputDecoration styling
  InputDecoration _inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle:
          const TextStyle(color: AppColor.primary, fontSize: 18),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      fillColor: AppColor.primarySoft,
      filled: true,
    );
  }

  void _submitForm() {
    if (validateAndSave()) {
      // final formData = _formKey.currentState?.value;
      print("First Name Form Data: $firstName");
      print("Phone Number Value Form Data: $phoneNumberValue");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Form Submission"),
          content: const Text("Your form has been successfully submitted."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Validation failed");
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form != null) {
      if (_currentStep == 0) {
        // Validate Step 1 fields
        if (form.fields['first_name']?.validate() != true ||
            form.fields['last_name']?.validate() != true ||
            form.fields['email']?.validate() != true ||
            phoneNumberValue == null ||
            phoneNumberValue!.isEmpty) {
          return false;
        }
      } else if (_currentStep == 1) {
        // Validate Step 2 fields
        if (form.fields['degree']?.validate() != true ||
            form.fields['institution']?.validate() != true ||
            form.fields['graduation']?.validate() != true ||
            form.fields['gpa']?.validate() != true) {
          return false;
        }
      }
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

class Education {
  final String degree;
  final String institution;
  final DateTime? graduation;
  final double gpa;

  Education({
    required this.degree,
    required this.institution,
    required this.graduation,
    required this.gpa,
  });
}

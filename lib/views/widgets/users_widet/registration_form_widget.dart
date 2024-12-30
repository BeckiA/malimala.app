import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/user_models/user_regisration_response_model.dart';
import 'package:waloma/core/model/user_models/user_registration_request_model.dart';
import 'package:waloma/core/providers/user_providers.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/views/screens/file_upload_screen.dart';
import 'package:waloma/views/screens/otp_verification_page.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({Key? key}) : super(key: key);

  @override
  _UserRegistrationFormState createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _apiError = '';
  Map<String, String> _errors = {};
  String firstName = '';
  String lastName = '';
  String userName = '';
  String email = '';
  String password = '';
  String phoneNumberValue = '';
  String? userType = '';
  // bool isLoading = true;
  bool hidePassword = true;
  bool _userTypeHasError = true;
  List<String> userTypeLists = [
    "job_seeker",
    "employer",
    "broker",
    "car_owner",
    "home_owner",
    "user",
  ];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            children: [
              // Section 1 - Header
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 12),
                child: const Text(
                  'Welcome to Malimala  👋',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing \nelit, sed do eiusmod ',
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 12,
                      height: 150 / 100),
                ),
              ),
              // Full Name Field
              if (_apiError != null && _apiError.isNotEmpty) errorPopUp(),
              // Full Name Field

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'firstName',
                decoration: InputDecoration(
                  hintText: 'First Name',
                  errorText: _errors['first_name'],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Profile.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (onValidateVal) {
                  if (onValidateVal == null || onValidateVal.isEmpty) {
                    return 'First Name can\'t be empty.';
                  }
                  return null;
                },
                onSaved: (onSavedVal) {
                  firstName = onSavedVal ?? '';
                },
              ),

              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'lastName',
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  errorText: _errors['last_name'],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Profile.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (onValidateVal) {
                  if (onValidateVal == null || onValidateVal.isEmpty) {
                    return 'Last Name can\'t be empty.';
                  }
                  return null;
                },
                onSaved: (onSavedVal) {
                  lastName = onSavedVal ?? '';
                },
              ),
              const SizedBox(height: 16),
              // Username Field
              FormBuilderTextField(
                name: 'username',
                decoration: InputDecoration(
                  hintText: 'Username',
                  errorText: _errors['username'],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Text('@',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (onValidateVal) {
                  if (onValidateVal == null || onValidateVal.isEmpty) {
                    return 'Username can\'t be empty.';
                  }
                  return null;
                },
                onSaved: (onSavedVal) {
                  userName = onSavedVal ?? '';
                },
              ),
              const SizedBox(height: 16),
              // Email Field
              FormBuilderTextField(
                name: 'email',
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'youremail@email.com',
                  errorText: _errors['email'],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Message.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: (onValidateVal) {
                  if (onValidateVal == null || onValidateVal.isEmpty) {
                    return 'Email can\'t be empty.';
                  }
                  return null;
                },
                onSaved: (onSavedVal) {
                  email = onSavedVal ?? '';
                },
              ),
              const SizedBox(height: 16),
              // Password Field
              FormBuilderTextField(
                name: 'password',
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: _errors["password"],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Lock.svg',
                        color: AppColor.primary),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: SvgPicture.asset(
                      hidePassword
                          ? 'assets/icons/Hide.svg'
                          : 'assets/icons/Show.svg',
                      color: AppColor.primary,
                    ),
                  ),
                ),
                validator: (onValidateVal) {
                  if (onValidateVal == null || onValidateVal.isEmpty) {
                    return 'Password can\'t be empty.';
                  }
                  return null;
                },
                onSaved: (onSavedVal) {
                  password = onSavedVal ?? '';
                },
              ),

              const SizedBox(height: 16),

              IntlPhoneField(
                style: const TextStyle(fontSize: 16.0),
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  errorText: _errors['phone_number'],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                  counterText: "",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                initialValue: phoneNumberValue,
                initialCountryCode: "ET",
                onChanged: (phone) {
                  phoneNumberValue = phone.completeNumber;
                },
                validator: (value) {
                  if (value == null || value.completeNumber.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              // Dropdown for User Type Selection
              FormBuilderDropdown<String>(
                name: 'userType',
                decoration: InputDecoration(
                  hintText: 'Select User Type',
                  errorText: _errors['user_type'],
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset('assets/icons/Users.svg',
                        color: AppColor.primary),
                  ),
                  suffixIcon: _userTypeHasError
                      ? const Icon(Icons.error, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: "User type can't be empty"),
                ]),
                items: userTypeLists
                    .map((userType) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: userType,
                          child: Text(formatSnakeCase(userType)),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _userTypeHasError = !(_formKey
                            .currentState?.fields['userType']
                            ?.validate() ??
                        false);
                    userType = val;
                  });
                },
                valueTransformer: (val) => val?.toString(),
              ),

              const SizedBox(height: 24),
              // Sign Up Button
              ElevatedButton(
                onPressed: () async {
                  if (isLoading)
                    return; // Prevent multiple submissions while loading
                  print("I'm pressed");
                  setState(() {
                    _errors = {};
                    _apiError = '';
                  });

                  if (validateAndSave()) {
                    UserRegistrationRequestModel model =
                        UserRegistrationRequestModel(
                      username: userName,
                      email: email,
                      password: password,
                      firstName: firstName,
                      lastName: lastName,
                      userType: userType,
                      phoneNumber: phoneNumberValue,
                    );

                    setState(() {
                      isLoading = true;
                    });

                    userType == 'broker'
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrokerFileUpload(),
                            ),
                          )
                        : null;
                    try {
                      // Wrap the API request in a timeout to handle long delays
                      final response = await UserAPIService.register(model)
                          .timeout(const Duration(seconds: 15), onTimeout: () {
                        throw TimeoutException(
                            'The server took too long to respond.');
                      });

                      print(response['success']);
                      if (response['success']) {
                        final otpResponse = await UserAPIService.sendOtp(
                            response['user']['email']);
                        if (otpResponse['success']) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OTPVerificationPage(email: email),
                            ),
                          );
                        } else {
                          setState(() {
                            _apiError = 'Failed to send OTP. Please try again.';
                          });
                        }
                      } else {
                        setState(() {
                          _errors = response['errors'] ?? {};
                          _apiError = response['apiError'] ??
                              'An unknown error occurred.';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        _apiError = e is TimeoutException
                            ? e.message ??
                                'Request timed out. Please try again.'
                            : 'Network or server error. Please try again.';
                      });
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  primary: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Signning In',
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
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: 'poppins',
                        ),
                      ),
              )
            ]));
  }

  Container errorPopUp() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(10),
        border: const Border(left: BorderSide(color: Colors.red, width: 5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          // Warning Icon
          const Icon(
            Icons.error,
            color: Colors.red,
            size: 24,
          ),
          const SizedBox(width: 12),

          // Error message
          Expanded(
            child: Text(
              _apiError,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _apiError = '';
              });
            },
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Helper function to format snake case to title case
  String formatSnakeCase(String text) {
    return text
        .split('_') // Split by underscores
        .map((word) =>
            word[0].toUpperCase() + word.substring(1)) // Capitalize each word
        .join(' '); // Join words with a space
  }
}

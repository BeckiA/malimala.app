import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/views/screens/otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? _errors;
  final _formKey = GlobalKey<FormBuilderState>();
  String? email;
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      key: UniqueKey(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Forgot Password',
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
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 12),
              child: const Text(
                'Forgot Password,',
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
                'Please enter your email to reset the password',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100,
                ),
              ),
            ),

            const SizedBox(height: 12),
            // Section 2 - Form
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  // Email Field
                  FormBuilderTextField(
                    name: 'email',
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'youremail@email.com',
                      errorText:
                          _errors, // Display backend errors (e.g., email not found)
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset('assets/icons/Message.svg',
                            color: AppColor.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email can\'t be empty.';
                      }
                      const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      final regex = RegExp(emailPattern);
                      if (!regex.hasMatch(value)) {
                        return 'Invalid email address.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _errors = null; // Clear error as the user interacts
                      });
                    },
                    onSaved: (onSavedVal) {
                      email = onSavedVal ?? '';
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Reset Password Button
            ElevatedButton(
              onPressed: () async {
                if (validateAndSave()) {
                  setState(() {
                    isApiCallProcess = true;
                  });

                  await UserAPIService.sendOtp(email!).then((otpResponse) {
                    if (otpResponse['success']) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPVerificationPage(
                              email: email!,
                              path: '/reset',
                            ),
                          ));
                    } else {
                      setState(() {
                        _errors = otpResponse['message'] ?? 'Unknown error';
                      });
                      print("Error: ${otpResponse['message']}");
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                primary: AppColor.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to validate and save form
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      setState(() {
        _errors = null; // Clear errors if validation passes
      });
      return true;
    }
    return false;
  }
}

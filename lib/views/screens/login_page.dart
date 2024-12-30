import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/user_models/user_login_request_model.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/views/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _errors = '';
  final _formKey = GlobalKey<FormBuilderState>();
  bool hidePassword = true;
  bool isLoading = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Sign in',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
            },
            icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 48,
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            style: TextButton.styleFrom(
              primary: AppColor.secondary.withOpacity(0.1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dont have an account?',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  ' Sign up',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
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
                  'Welcome Back,',
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
                  'Hi! Welcome Back, you\'ve been missed',
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 12,
                      height: 150 / 100),
                ),
              ),
              if (_errors != null && _errors!.isNotEmpty) errorPopUp(),

              const SizedBox(height: 12),
              // Section 2 - Form
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    FormBuilderTextField(
                      name: 'username',
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Text('@',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.primary, width: 1),
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
                      onSaved: (onSavedVal) => {
                        userName = onSavedVal,
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        hintText: '**********',
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset('assets/icons/Lock.svg',
                              color: AppColor.primary),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.border, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.primary, width: 1),
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

                    // Forgot Password
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/forgot',
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: AppColor.primary.withOpacity(0.1),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.secondary.withOpacity(0.5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isLoading)
                    return; // Prevent multiple submissions while loading
                  setState(() {
                    _errors = '';
                  });

                  if (validateAndSave()) {
                    UserLoginRequestModel model = UserLoginRequestModel(
                      username: userName,
                      password: password,
                    );

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      // Wrap the API request in a timeout
                      final response = await UserAPIService.login(model)
                          .timeout(const Duration(seconds: 15), onTimeout: () {
                        throw TimeoutException(
                            'The server took too long to respond.');
                      });

                      if (response["success"]) {
                        // Login successful, navigate to the home screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/landing',
                          (route) => false,
                        );
                      } else {
                        final errors = response['errors'];
                        setState(() {
                          _errors = errors != null
                              ? errors['error']
                              : 'Login failed. Please try again.';
                        });
                      }
                    } catch (e) {
                      setState(() {
                        _errors = e is TimeoutException
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
                            'Logging In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: 'poppins',
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          LoadingAnimationWidget.waveDots(
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      )
                    : const Text(
                        'Sign in',
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
              _errors!,
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
                _errors = null;
              });
            },
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

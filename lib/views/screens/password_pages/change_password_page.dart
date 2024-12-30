import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/screens/waloma_success_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String? _errors = '';
  final _formKey = GlobalKey<FormBuilderState>();
  bool hidePassword = true;
  bool newhidePassword = true;
  bool confirmHidePassword = true;
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;
  bool _isLoading = false;
  int? _id;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final response = await SharedService.loginDetails();
    print(response?.user!.id);
    if (response?.success == true) {
      setState(() {
        _id = response?.user!.id!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errors = response!.success == false ? "Unable to fetch user data" : '';
        _isLoading = false;
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
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
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
              'Change current password',
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
              'Make sure it\'s strong for better security.',
              style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7),
                fontSize: 12,
                height: 150 / 100,
              ),
            ),
          ),

          if (_errors != null && _errors!.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(10),
                border:
                    const Border(left: BorderSide(color: Colors.red, width: 5)),
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
            ),

          const SizedBox(height: 12),
          // Section 2 - Form
          FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns the content to the left
                children: [
                  const Text(
                    "Current Password",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'poppins',
                      fontSize: 18,
                    ),
                    textAlign:
                        TextAlign.left, // Ensures the text is aligned left
                  ),
                  const SizedBox(
                    height: 7,
                  ),

                  // New Password
                  FormBuilderTextField(
                    name: 'oldpassword',
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
                        return 'Current Password can\'t be empty.';
                      }
                      return null;
                    },
                    onSaved: (onSavedVal) {
                      oldPassword = onSavedVal ?? '';
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "New Password",
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'poppins',
                      fontSize: 18,
                    ),
                    textAlign:
                        TextAlign.left, // Ensures the text is aligned left
                  ),
                  const SizedBox(
                    height: 7,
                  ),

                  // New Password
                  FormBuilderTextField(
                    name: 'newpassword',
                    obscureText: newhidePassword,
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
                            newhidePassword = !newhidePassword;
                          });
                        },
                        icon: SvgPicture.asset(
                          newhidePassword
                              ? 'assets/icons/Hide.svg'
                              : 'assets/icons/Show.svg',
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    validator: (onValidateVal) {
                      if (onValidateVal == null || onValidateVal.isEmpty) {
                        return 'New Password can\'t be empty.';
                      }
                      return null;
                    },
                    onSaved: (onSavedVal) {
                      newPassword = onSavedVal ?? '';
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text("Confirm Password",
                      style: TextStyle(
                        color: AppColor.secondary,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'poppins',
                        fontSize: 18,
                      )),
                  const SizedBox(
                    height: 7,
                  ),

                  // Confirm Password
                  FormBuilderTextField(
                    name: 'confirm_password',
                    obscureText: confirmHidePassword,
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
                            confirmHidePassword = !confirmHidePassword;
                          });
                        },
                        icon: SvgPicture.asset(
                          confirmHidePassword
                              ? 'assets/icons/Hide.svg'
                              : 'assets/icons/Show.svg',
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    validator: (onValidateVal) {
                      if (onValidateVal == null || onValidateVal.isEmpty) {
                        return 'Confirm Password can\'t be empty.';
                      }
                      if (onValidateVal != newPassword) {
                        setState(() {
                          _errors = 'Confirm Passwords do not match.';
                        });
                      }
                      return null;
                    },
                    onSaved: (onSavedVal) {
                      confirmPassword = onSavedVal ?? '';
                    },
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // Sign In Button
          ElevatedButton(
            onPressed: () async {
              if (validateAndSave()) {
                try {
                  // Make API call

                  final changeResponse = await UserAPIService.changePassword(
                      _id!, oldPassword!, newPassword!);

                  // Handle success response
                  if (changeResponse['success']) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalomaSuccessPage(
                                headLineTitle: 'Change Password Success!',
                                subHeadlineTitle:
                                    'Congratulations!, Your password has been changed. Click continue to login',
                              )),
                    );
                  } else {
                    // Handle error response
                    setState(() {
                      _errors = changeResponse['message'] ?? 'Unknown error';
                    });
                    print('Error: ${changeResponse['message']}');
                  }
                } catch (e) {
                  print('Exception occurred: $e');
                  setState(() {
                    _errors = 'An error occurred while resetting the password.';
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
          )
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

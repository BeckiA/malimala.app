import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:waloma/views/screens/reset_password_page.dart';
import 'package:waloma/views/screens/waloma_success_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  final String path;
  final String? token;

  const OTPVerificationPage({
    Key? key,
    required this.email,
    this.path = "",
    this.token,
  }) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  String? _otpErrorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _sendOTP() async {
    setState(() {
      _isResending = true;
      _otpErrorMessage = null;
    });

    try {
      await UserAPIService.sendOtp(widget.email);
    } catch (error) {
      setState(() {
        _otpErrorMessage = "Failed to resend OTP. Please try again.";
      });
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _verifyOTP() async {
    setState(() {
      _isLoading = true;
      _otpErrorMessage = null;
    });

    final otp = _otpController.text.trim();
    final response = await UserAPIService.verifyOtp(widget.email, otp);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      widget.path.isNotEmpty
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(
                  email: widget.email,
                  token: response['reset_token'],
                ),
              ),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WalomaSuccessPage(
                    headLineTitle: "You've Registered Successfully",
                    subHeadlineTitle:
                        "Welcome to the Waloma Marketplace Service, Now You can Login to Waloma!"),
              ),
            );
    } else {
      setState(() {
        _otpErrorMessage = response['message'];
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
        title: const Text('Verification',
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 8),
                  child: const Text(
                    'Email verification',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'OTP Code sent to your email',
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.email,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_otpErrorMessage != null && _otpErrorMessage!.isNotEmpty)
                  errorPopUp(),
                SizedBox(
                  height: 100, // Adjust height for PinCodeTextField
                  child: PinCodeTextField(
                    controller: _otpController,
                    appContext: context,
                    length: 6,
                    onChanged: (value) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: false,
                    pinTheme: PinTheme(
                      errorBorderColor: Colors.red,
                      shape: PinCodeFieldShape.box,
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: AppColor.primary,
                      inactiveColor: AppColor.border,
                      inactiveFillColor: AppColor.primarySoft,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 32, bottom: 16),
                  child: ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 18),
                      primary: AppColor.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: _isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 25)
                        : const Text(
                            'Verify',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: 'poppins'),
                          ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: _isResending
                          ? null
                          : _sendOTP, // Disable button if loading
                      style: ElevatedButton.styleFrom(
                        onPrimary: AppColor.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 18),
                        primary: AppColor.primarySoft,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: _isResending
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white, size: 25)
                          : const Text(
                              'Resend OTP Code',
                              style: TextStyle(
                                color: AppColor.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
          const Icon(Icons.error, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _otpErrorMessage!,
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
                _otpErrorMessage = null;
              });
            },
          ),
        ],
      ),
    );
  }
}

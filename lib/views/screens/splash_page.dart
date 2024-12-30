import 'dart:async';
import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/constant/image_strings.dart';
import 'package:waloma/views/screens/page_switcher.dart';
import 'package:waloma/views/screens/register_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(
          seconds: 2,
        ), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            color: AppColor.white,
            image: DecorationImage(
              image: AssetImage(
                AppImages.walomaLogo,
              ),
            )),
      ),
    );
  }
}
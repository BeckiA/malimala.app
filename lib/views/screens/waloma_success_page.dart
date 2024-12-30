import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';

class WalomaSuccessPage extends StatefulWidget {
  final String headLineTitle;
  final String subHeadlineTitle;
  const WalomaSuccessPage(
      {Key? key, required this.headLineTitle, required this.subHeadlineTitle})
      : super(key: key);

  @override
  State<WalomaSuccessPage> createState() => _WalomaSuccessPageState();
}

class _WalomaSuccessPageState extends State<WalomaSuccessPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(
          seconds: 5,
        ), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              margin: const EdgeInsets.only(bottom: 32),
              child: SvgPicture.asset('assets/icons/Success.svg'),
            ),
            Center(
              child: Text(
                widget.headLineTitle,
                style: const TextStyle(
                  color: AppColor.secondary,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                widget.subHeadlineTitle,
                style: TextStyle(color: AppColor.secondary.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

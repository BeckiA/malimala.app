import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';

class FlashsaleCountdownTile extends StatelessWidget {
  final String digit;

  const FlashsaleCountdownTile({Key? key, required this.digit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            color: AppColor.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

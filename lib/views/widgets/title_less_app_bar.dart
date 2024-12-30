import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';

class TitleLessAppBar extends StatelessWidget {
  const TitleLessAppBar({
    Key? key,
    required this.leftIcon,
    required this.rightIcon,
    required this.leftOnTap,
    required this.rightOnTap,
  }) : super(key: key);

  final VoidCallback rightOnTap, leftOnTap;
  final Widget rightIcon, leftIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
        margin: const EdgeInsets.only(top: 14),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                onPressed: leftOnTap,
                style: ElevatedButton.styleFrom(
                  onPrimary: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: AppColor.primarySoft,
                  elevation: 0,
                  padding: const EdgeInsets.all(8),
                ),
                child: leftIcon,
              ),
            ),
            SizedBox(
              width: 40,
              height: 40,
              child: ElevatedButton(
                onPressed: rightOnTap,
                style: ElevatedButton.styleFrom(
                  onPrimary: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: AppColor.primarySoft,
                  elevation: 0,
                  padding: const EdgeInsets.all(8),
                ),
                child: rightIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

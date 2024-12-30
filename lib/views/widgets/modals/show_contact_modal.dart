import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waloma/constant/app_color.dart';

class ContactBottomSheet extends StatefulWidget {
  @override
  _ContactBottomSheet createState() => _ContactBottomSheet();
}

class _ContactBottomSheet extends State<ContactBottomSheet> {
  // Function to initiate the call
  void _callPhoneNumber(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      // Show an error if the device cannot place calls
      print("Unable to place a call to $phoneNumber.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 6,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColor.primarySoft,
            ),
          ),
          // Phone number and call button
          const Text(
            '+251987654321', // Display the phone number
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: AppColor.secondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () =>
                _callPhoneNumber('+251987654321'), // Initiates the call
            style: ElevatedButton.styleFrom(
              primary: AppColor.primary,
              padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: MediaQuery.of(context).size.width * 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Call Now',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

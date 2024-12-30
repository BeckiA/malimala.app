import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waloma/constant/app_color.dart';

class TrendingListingsSkeleton extends StatelessWidget {
  const TrendingListingsSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for image
            Container(
              width: 180,
              height: 150,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
            ),
            // Placeholder for title
            Container(
              width: 120,
              height: 15,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 4),
            ),
            // Placeholder for price
            Container(
              width: 80,
              height: 15,
              color: Colors.white,
            ),
            // Placeholder for the progress bar and fire icon
            SizedBox(
              width: 180,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          minHeight: 10,
                          value: 0.4,
                          color: AppColor.accent,
                          backgroundColor: AppColor.border,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColor.accent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

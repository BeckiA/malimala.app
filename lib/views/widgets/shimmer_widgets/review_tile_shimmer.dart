import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerReviewTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar placeholder
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(right: 10),
            ),
            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username and rating placeholders
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Username placeholder
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.grey,
                        ),
                        // Rating placeholder
                        Container(
                          width: 60,
                          height: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  // Comment placeholder
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 14,
                    color: Colors.grey,
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

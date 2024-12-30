import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemCardSkeleton extends StatelessWidget {
  const ItemCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width / 2 - 24;

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton for the item image
            Container(
              width: itemWidth,
              height: itemWidth,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 8),
            // Skeleton for the item title
            Container(
              width: itemWidth * 0.6,
              height: 12,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            // Skeleton for the item price
            Container(
              width: itemWidth * 0.4,
              height: 12,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            // Skeleton for the store name
            Container(
              width: itemWidth * 0.5,
              height: 10,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:waloma/core/model/Review.dart';
import 'package:waloma/core/model/rating_models/rating_request_model.dart';

import '../../constant/app_color.dart';

class ReviewTile extends StatelessWidget {
  final RatingRequestModel review;
  ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Photo
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: AssetImage('assets/images/waloma_logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Username - Rating - Comments
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username - Rating
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 8,
                        child: Text(
                          'User Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                              fontFamily: 'poppins'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: SmoothStarRating(
                          allowHalfRating: false,
                          size: 16,
                          color: Colors.orange[400],
                          rating: double.parse(review.rating.toString()),
                          borderColor: AppColor.primarySoft,
                        ),
                      )
                    ],
                  ),
                ),
                // Comments
                Text(
                  review.review,
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/rating_models/Rating.dart';
import 'package:waloma/core/services/user_auth_services/user_api_services.dart';
import 'package:waloma/helpers/profile_image_initals.dart';

class ReviewTile extends StatelessWidget {
  final RatingModel review;
  ReviewTile({required this.review});
  String _normalizeImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    // Remove leading slash and construct the full URL
    imagePath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return 'http://${AppConfiguration.apiURL}/$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    final user = UserAPIService.getUserProfile(review.ratingUser);

    return FutureBuilder<Map<String, dynamic>>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('YAY Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          print('No data available');
          return Text('No data available');
        } else {
          final userProfile = snapshot.data!;
          Widget _buildProfileAvatar() {
            final profileDetails = userProfile['user']['profile_details'];
            final avatar =
                profileDetails != null ? profileDetails['profile_image'] : null;
            final initialsColor = ProfileInitals.getBackgroundColorForInitials(
              userProfile['user']['first_name'],
              userProfile['user']['last_name'],
            );

            return Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: avatar == null || avatar.isEmpty ? initialsColor : null,
                image: avatar != null && avatar.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(_normalizeImageUrl(avatar)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatar == null || avatar.isEmpty
                  ? Center(
                      child: Text(
                        ProfileInitals.getInitials(
                          userProfile['user']['first_name'],
                          userProfile['user']['last_name'],
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : null,
            );
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileAvatar(),
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
                                '${userProfile['user']['first_name']} ${userProfile['user']['last_name']}',
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
      },
    );
  }
}

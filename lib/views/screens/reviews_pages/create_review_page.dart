import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/rating_models/rating_request_model.dart';
import 'package:waloma/core/services/rating_services/rating_api_service.dart';
import 'package:waloma/core/services/user_auth_services/user_instance_service.dart';
import 'package:waloma/core/services/user_auth_services/user_shared_services.dart';
import 'package:waloma/views/widgets/custom_app_bar.dart';
import 'package:waloma/views/widgets/review_tile.dart';

class CreateReview extends StatefulWidget {
  final listingProviderId;
  final List<RatingRequestModel> reviews;
  const CreateReview(
      {Key? key, required this.reviews, required this.listingProviderId})
      : super(key: key);

  @override
  _CreateReviewState createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  double _newRating = 0.0;
  final currentUserId = UserService().userId;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  double getAverageRating() {
    if (widget.reviews.isEmpty) return 0.0;
    double total = widget.reviews.fold(0, (sum, review) => sum + review.rating);
    return total / widget.reviews.length;
  }

  void _showToast(String message, Color? backgroundColor, TextStyle textStyle) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      duration: Duration(seconds: 4),
      animDuration: Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
    );
  }

  void _submitReview() async {
    final loginDetails = await SharedService.loginDetails();
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      final ratingRequest = RatingRequestModel(
        ratedUser: widget.listingProviderId,
        rating: _newRating.toInt(),
        review: _reviewController.text,
        ratingUser: loginDetails!.user!.id!.toInt(),
      );
      print(ratingRequest.ratedUser);
      print(ratingRequest.rating);
      print(ratingRequest.review);
      print(ratingRequest.ratingUser);
      try {
        final response =
            await RatingApiServices.createRatingReview(ratingRequest);
        if (response['success'] == true) {
          setState(() {
            widget.reviews.add(ratingRequest);
            _reviewController.clear();
            _newRating = 0.0;
            isLoading = false;
          });
          _showToast('Review submitted successfully', Colors.green,
              TextStyle(color: Colors.white, fontSize: 16));
        } else {
          throw Exception('Failed to submit review');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showToast('Error: $e', Colors.red[50],
            TextStyle(color: Colors.redAccent, fontSize: 16));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            title: 'Submit Your Review',
            leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
            rightIcon: SvgPicture.asset(
              'assets/icons/Bookmark.svg',
              color: Colors.black.withOpacity(0.5),
            ),
            leftOnTap: () {
              Navigator.of(context).pop();
            },
            rightOnTap: () {},
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1 - Header
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      getAverageRating().toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'poppins'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmoothStarRating(
                        allowHalfRating: true,
                        size: 28,
                        color: Colors.orange[400],
                        rating: getAverageRating(),
                        borderColor: AppColor.primarySoft,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Based on ${widget.reviews.length} Reviews',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section 2 - Submit Review
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Your Review",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SmoothStarRating(
                      allowHalfRating: true,
                      size: 40,
                      color: Colors.orange[400],
                      rating: _newRating,
                      borderColor: AppColor.primarySoft,
                      onRatingChanged: (value) {
                        setState(() {
                          _newRating = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: _buildInputDecoration('Your Review'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Review is required";
                        } else if (value.length > 300) {
                          return "Review can't exceed 300 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.925,
                      child: ElevatedButton(
                        onPressed: _submitReview,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          primary: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Submit Review",

                          // widget.listing != null
                          //     ? "Update Listing"
                          //     : "Post Listing",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section 3 - List Review
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  ReviewTile(review: widget.reviews[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: widget.reviews.length,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle:
          const TextStyle(color: AppColor.primary, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      fillColor: AppColor.primarySoft,
      filled: true,
    );
  }
}

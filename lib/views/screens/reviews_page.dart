import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/rating_models/Rating.dart';
import 'package:waloma/views/widgets/custom_app_bar.dart';
import 'package:waloma/views/widgets/review_tile.dart';

class ReviewsPage extends StatefulWidget {
  final List<RatingModel> reviews;
  const ReviewsPage({Key? key, required this.reviews});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  getAverageRating() {
    double average = 0.0;
    for (var i = 0; i < widget.reviews.length; i++) {
      average += widget.reviews[i].rating;
    }
    print(average / widget.reviews.length);
    return average / widget.reviews.length;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            title: 'Reviews',
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
                      style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'poppins'),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmoothStarRating(
                        allowHalfRating: false,
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
                  )
                ],
              ),
            ),
            // Section 2 - Tab
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: List.generate(6, (index) {
                  int count = widget.reviews
                      .where((review) => review.rating == index.toDouble())
                      .length;
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            const BorderSide(color: AppColor.border, width: 1),
                      ),
                      primary: (_selectedTab == index)
                          ? AppColor.primary
                          : Colors.white,
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/icons/Star-active.svg',
                            width: 14, height: 14),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          child: Text(
                            index == 0 ? 'All reviews' : '$index ($count)',
                            style: TextStyle(
                              color: (_selectedTab == index)
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Section 3 - List Review
            IndexedStack(
              index: _selectedTab,
              children: List.generate(6, (index) {
                if (index == 0) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ReviewTile(review: widget.reviews[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: widget.reviews.length,
                  );
                } else {
                  List<RatingModel> filteredReviews = widget.reviews
                      .where((review) => review.rating == index.toDouble())
                      .toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ReviewTile(review: filteredReviews[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: filteredReviews.length,
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}

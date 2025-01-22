import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/providers/review_providers.dart';
import 'package:waloma/views/widgets/listing_details_data_provider.dart/listing_data_provider.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_details_bottomnav_widget.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';
import 'package:waloma/views/widgets/shimmer_widgets/review_tile_shimmer.dart';

class BidDetailsScreen extends StatefulWidget {
  final Listings listing;
  const BidDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  _BidDetailsScreenState createState() => _BidDetailsScreenState();
}

class _BidDetailsScreenState extends State<BidDetailsScreen> {
  PageController listingImageSlider = PageController();
  void initState() {
    super.initState();
    // Trigger fetch from provider when widget initializes
    Future.microtask(() => Provider.of<ReviewProvider>(context, listen: false)
        .fetchReviews(widget.listing.userId));
  }

  @override
  Widget build(BuildContext context) {
    Listings listing = widget.listing;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: ListingBottomNavWidget(
        listings: listing,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar \
          ListingDetailsHelerMethods.appBarWithNoTitle(context),
          // Section 2 - listing info
          ListingDetailsHelerMethods.listingInfoDetailHeader(
              context, listing, true),

          // Section 5 - Job Responsibilities
          ListingDetailsHelerMethods.descriptionProviderElement(context,
              listing, 'Project Description', true, listing.description),

          // Section 6 - Job Application Posted By
          ListingDetailsHelerMethods.scholarshipListingsProviderElement(
              context,
              listing,
              'assets/icons/Dollar-Sign.svg',
              'Bid Starting Price',
              listing.details['starting_price'],
              false),
          // Section 6 - Job Application Posted By
          ListingDetailsHelerMethods.scholarshipListingsProviderElement(
              context,
              listing,
              'assets/icons/Profile.svg',
              'Bidder Type',
              listing.details['bidder_type'] ?? "Not Provided",
              true),

          // Section 6 - Job Application Deadline
          ListingDetailsHelerMethods.listingApplicationDeadlineProviderElement(
              context, listing, 'Bid Deadline', true, listing.details),
          // Section 5 - Key Features
          ListingDetailDataFields.listingKeyFeatures(
            context,
            listing,
            'Bid Terms and Conditions',
          ),
          // Section 5 - Reviews
          FutureBuilder<Widget>(
            future: ListingDetailsHelerMethods.listingDetailsReview(
                context, listing.userId),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children:
                          List.generate(2, (index) => ShimmerReviewTile()),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return snapshot.data ?? SizedBox.shrink();
              } else {
                return snapshot.data ?? SizedBox.shrink();
              }
            },
          )
        ],
      ),
    );
  }
}

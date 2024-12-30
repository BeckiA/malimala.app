import 'package:flutter/material.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/widgets/listind_details_data_provider.dart/listing_data_provider.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_details_bottomnav_widget.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';

class BidDetailsScreen extends StatefulWidget {
  final Listings listing;
  const BidDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  _BidDetailsScreenState createState() => _BidDetailsScreenState();
}

class _BidDetailsScreenState extends State<BidDetailsScreen> {
  PageController listingImageSlider = PageController();
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
          ListingDetailsHelerMethods.listingDetailsReview(context)
        ],
      ),
    );
  }
}

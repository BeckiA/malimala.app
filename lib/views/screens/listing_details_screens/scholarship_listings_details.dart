import 'package:flutter/material.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/widgets/listind_details_data_provider.dart/listing_data_provider.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_details_bottomnav_widget.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';

class ScholarshipDetailsScreen extends StatefulWidget {
  final Listings listing;
  const ScholarshipDetailsScreen({Key? key, required this.listing})
      : super(key: key);

  @override
  _ScholarshipDetailsScreenState createState() =>
      _ScholarshipDetailsScreenState();
}

class _ScholarshipDetailsScreenState extends State<ScholarshipDetailsScreen> {
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
              context, listing, false),

          // Section 5 - Job Responsibilities
          ListingDetailsHelerMethods.descriptionProviderElement(
              context,
              listing,
              'About ${listing.title} Scholarship',
              true,
              listing.details['responsibilities'] ?? "Not Provided"),

          // Section 6 - Job Application Posted By
          ListingDetailsHelerMethods.scholarshipListingsProviderElement(
              context,
              listing,
              'assets/icons/Correct.svg',
              'Eligibility Criteria',
              listing.details['eligibility'],
              false),
          // Section 6 - Job Application Posted By
          ListingDetailsHelerMethods.scholarshipListingsProviderElement(
              context,
              listing,
              'assets/icons/Wallet.svg',
              'Scholarship Coverage',
              listing.details['benefits'] ?? "Not Provided",
              false),
          ListingDetailsHelerMethods.scholarshipListingsProviderElement(
              context,
              listing,
              'assets/icons/Wallet.svg',
              'Scholarship Type',
              listing.details['scholarship_type'] ?? "Not Provided",
              false),
          // Section 6 - Job Application Deadline
          ListingDetailsHelerMethods.listingApplicationDeadlineProviderElement(
              context, listing, 'Application Deadline', true, listing.details),
          // Section 5 - Key Features
          ListingDetailDataFields.listingKeyFeatures(
              context, listing, 'More On ${listing.title}'),
          // Section 5 - Reviews
          FutureBuilder<Widget>(
            future: ListingDetailsHelerMethods.listingDetailsReview(
                context, listing.userId),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
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

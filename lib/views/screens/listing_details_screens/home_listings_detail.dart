import 'package:flutter/material.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/widgets/listind_details_data_provider.dart/listing_data_provider.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_details_bottomnav_widget.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';

class HomeDetailsScreen extends StatefulWidget {
  final Listings listing;
  const HomeDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  _HomeDetailsScreenState createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  PageController listingImageSlider = PageController();
  @override
  Widget build(BuildContext context) {
    // Your base URL for images
    const String baseUrl = "http://${AppConfiguration.apiURL}/";
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
          // Section 1 - appbar & listing image
          ListingDetailsHelerMethods.listingImageAppBar(
              context, listing, baseUrl, listingImageSlider),
          // Section 2 - listing info
          ListingDetailsHelerMethods.listingInfoDetailHeader(
              context, listing, false),

          // Section 5 - Key Features
          ListingDetailsHelerMethods.listingFurnishingStatusProviderElement(
              context, listing, 'Furnishing Type', true, listing.details),
          // Section 5 - Reviews
          ListingDetailsHelerMethods.listingDetailsReview(
              context, listing.userId)
        ],
      ),
    );
  }
}

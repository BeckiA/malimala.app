import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/providers/review_providers.dart';
import 'package:waloma/views/widgets/listind_details_data_provider.dart/listing_data_provider.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_details_bottomnav_widget.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';

class CarDetailsScreen extends StatefulWidget {
  final Listings listing;
  const CarDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  PageController listingImageSlider = PageController();
  void initState() {
    super.initState();
    // Trigger fetch from provider when widget initializes
    Future.microtask(() => Provider.of<ReviewProvider>(context, listen: false)
        .fetchReviews(widget.listing.userId));
  }

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
          ListingDetailDataFields.listingKeyFeatures(
              context, listing, 'Key Features'),
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

import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/widgets/listing_details_widgets/listing_helper_methods_detail.dart';

class ListingDetailDataFields {
  static Container listingKeyFeatures(
      BuildContext context, Listings listing, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            childrenPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            title: Text(
              title,
              style: const TextStyle(
                color: AppColor.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listing.listingType == 'bid'
                  ? Text(listing.details['terms_and_conditions'] ??
                      "Terms and conditions is not available for this Bid")
                  : ListingDetailsHelerMethods.buildFeaturesDetailsGrid(
                      listing.details, listing.listingType)
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/screens/listing_details_screens/bid_listings_details.dart';
import 'package:waloma/views/screens/listing_details_screens/car_listings_detail.dart';
import 'package:waloma/views/screens/listing_details_screens/home_listings_detail.dart';
import 'package:waloma/views/screens/listing_details_screens/job_listings_details.dart';
import 'package:waloma/views/screens/listing_details_screens/scholarship_listings_details.dart';

class ItemCard extends StatelessWidget {
  final Listings listing;
  final Color titleColor;
  final Color priceColor;

  final String baseUrl = "http://${AppConfiguration.apiURL}/";

  ItemCard({
    required this.listing,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    DecorationImage _imagePathProvider() {
      if (listing.listingType == 'bid') {
        return const DecorationImage(
          image: AssetImage('assets/images/bid-placeholder.jpg'),
          fit: BoxFit.cover,
        );
      } else if (listing.listingType == 'job') {
        return const DecorationImage(
          image: AssetImage('assets/images/job-placeholder.jpg'),
          fit: BoxFit.cover,
        );
      } else if (listing.listingType == 'scholarship') {
        return const DecorationImage(
          image: AssetImage('assets/images/scholarship-placeholder.png'),
          fit: BoxFit.cover,
        );
      }
      return const DecorationImage(
        image: AssetImage('assets/images/waloma_logo.png'),
        fit: BoxFit.cover,
      );
    }

    String imageUrl = listing.listingImages.isNotEmpty
        ? listing.listingImages[0]
        : 'https://placeholder.com/150';

    if (!imageUrl.startsWith('http') && imageUrl.isNotEmpty) {
      imageUrl = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
      imageUrl = 'http://${AppConfiguration.apiURL}/$imageUrl';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (listing.listingType == 'car') {
                return CarDetailsScreen(listing: listing);
              } else if (listing.listingType == 'job') {
                return JobDetailsScreen(listing: listing);
              } else if (listing.listingType == 'home') {
                return HomeDetailsScreen(listing: listing);
              } else if (listing.listingType == 'scholarship') {
                return ScholarshipDetailsScreen(listing: listing);
              } else if (listing.listingType == 'bid') {
                return BidDetailsScreen(listing: listing);
              }
              return const SizedBox();
            },
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Image at the top of the card
            Center(
              child: Container(
                // margin: const EdgeInsets.only(top: 12),
                // width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 4.25,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  image: listing.listingType == 'scholarship' ||
                          listing.listingType == 'job' ||
                          listing.listingType == 'bid'
                      ? _imagePathProvider()
                      : DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),

            // Item details
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ETB. ${listing.price}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: priceColor,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        FeatherIcons.mapPin,
                        size: 14,
                        color: AppColor.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        listing.location,
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

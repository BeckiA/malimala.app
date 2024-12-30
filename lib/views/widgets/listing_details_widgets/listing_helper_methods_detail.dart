import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/views/screens/image_viewer.dart';
import 'package:waloma/views/widgets/custom_app_bar.dart';
import 'package:waloma/views/widgets/rating_tag.dart';
import 'package:waloma/views/widgets/title_less_app_bar.dart';

class ListingDetailsHelerMethods {
  static TitleLessAppBar appBarWithNoTitle(BuildContext context) {
    return TitleLessAppBar(
      leftIcon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
      rightIcon: SvgPicture.asset(
        'assets/icons/Bookmark.svg',
        color: Colors.black.withOpacity(0.5),
      ),
      leftOnTap: () {
        Navigator.of(context).pop();
      },
      rightOnTap: () {},
    );
  }

  static Stack listingImageAppBar(BuildContext context, Listings listing,
      String baseUrl, PageController listingImageSlider) {
    // Helper function to normalize image URLs
    String _normalizeImageUrl(String imagePath) {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      // Remove leading slash and construct the full URL
      imagePath =
          imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
      return 'http://${AppConfiguration.apiURL}/$imagePath';
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Listing image
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageViewer(
                  imageUrl: listing.listingImages
                      .map((image) => _normalizeImageUrl(image))
                      .toList(),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 100),
            width: MediaQuery.of(context).size.width,
            height: 310,
            color: Colors.white,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: listingImageSlider,
              itemCount: listing.listingImages.length,
              itemBuilder: (context, index) => Image.network(
                fit: BoxFit.cover,
                _normalizeImageUrl(listing.listingImages[index]),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),

        // AppBar
        CustomAppBar(
          title: listing.title.toString(),
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

        // Smooth Page Indicator
        if (listing.listingImages.length > 1)
          Positioned(
            bottom: 16,
            child: SmoothPageIndicator(
              controller: listingImageSlider,
              count: listing.listingImages.length,
              effect: ExpandingDotsEffect(
                dotColor: AppColor.primary.withOpacity(0.2),
                activeDotColor: AppColor.primary,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
      ],
    );
  }

  static Widget buildFeaturesDetailsGrid(
      Map<String, dynamic> details, String listingType) {
    final List<Map<String, dynamic>> jobFeatures = [
      {
        'icon': FeatherIcons.briefcase,
        'label': 'Work Setup',
        'value': details['work_setup']
      },
      {
        'icon': FeatherIcons.barChart2,
        'label': 'Level',
        'value': details['career_level']
      },
    ];
    final List<Map<String, dynamic>> bidFeatures = [
      {
        'icon': FeatherIcons.info,
        'label': 'Bid Terms of Service',
        'value': details['terms_and_conditions'] ?? 'default'
      },
    ];
    final List<Map<String, dynamic>> scholarshipFeatures = [
      {
        'icon': FeatherIcons.watch,
        'label': 'Program Duration',
        'value': details['duration']
      },
      {
        'icon': FeatherIcons.bookOpen,
        'label': 'Program',
        'value': details['program']
      },
    ];

    final List<Map<String, dynamic>> carFeatures = [
      {'icon': Icons.directions_car, 'label': 'Make', 'value': details['make']},
      {'icon': Icons.build, 'label': 'Model', 'value': details['model']},
      {'icon': Icons.calendar_today, 'label': 'Year', 'value': details['year']},
      {'icon': Icons.palette, 'label': 'Color', 'value': details['color']},
      {'icon': Icons.event_seat, 'label': 'Seats', 'value': details['seats']},
      {
        'icon': Icons.offline_bolt,
        'label': 'Condition',
        'value': details['condition']
      },
      {
        'icon': Icons.settings,
        'label': 'Transmission',
        'value': details['transmission']
      },
      {
        'icon': Icons.confirmation_number,
        'label': 'VIN',
        'value': details['vin']
      },
      {
        'icon': Icons.color_lens,
        'label': 'Interior Color',
        'value': details['interior_color']
      },
      {
        'icon': Icons.directions_boat,
        'label': 'Engine Size',
        'value': '${details['engine_size']} cc'
      },
      {
        'icon': Icons.flash_on,
        'label': 'Horse Power',
        'value': '${details['horse_power']} HP'
      },
      {
        'icon': Icons.view_compact,
        'label': 'Cylinders',
        'value': details['cylinders']
      },
    ];

    late List<Map<String, dynamic>> listingFeatures;
    if (listingType == 'car') {
      listingFeatures = carFeatures;
    } else if (listingType == 'scholarship') {
      listingFeatures = scholarshipFeatures;
    } else if (listingType == 'job') {
      listingFeatures = jobFeatures;
    } else if (listingType == 'bid') {
      listingFeatures = bidFeatures;
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        childAspectRatio: 3, // Adjust height as needed
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: listingFeatures.length,
      itemBuilder: (context, index) {
        final feature = listingFeatures[index];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.primarySoft,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColor.border),
          ),
          child: Row(
            children: [
              Icon(feature['icon'], color: AppColor.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${feature['label']}: ${feature['value']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Container listingInfoDetailHeader(
      BuildContext context, Listings listing, bool isScholarship) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    listing.title.toString(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                        color: AppColor.secondary),
                  ),
                ),
                RatingTag(
                  margin: const EdgeInsets.only(left: 10),
                  value: 3,
                ),
              ],
            ),
          ),
          listing.listingType == 'scholarship'
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(bottom: 7),
                ),
          listing.listingType == 'scholarship'
              ? const SizedBox()
              : Text(
                  isScholarship ? '' : '${listing.details['position']}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                      color: AppColor.secondary),
                ),
          Container(
            margin: const EdgeInsets.only(bottom: 14),
          ),
          listingHeaderComponents(listing),
          listing.listingType == 'scholarship' || listing.listingType == 'bid'
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(bottom: 14),
                ),
          listing.listingType == 'scholarship' || listing.listingType == 'bid'
              ? const SizedBox()
              : descriptionProviderElement(context, listing,
                  'About ${listing.title}', false, listing.description)
        ],
      ),
    );
  }

  static Container descriptionProviderElement(BuildContext context,
      Listings listing, String title, bool isAlone, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: isAlone
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'poppins',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          ),
          Text(
            description,
            style: TextStyle(
                color: AppColor.secondary.withOpacity(0.7), height: 150 / 100),
          ),
        ],
      ),
    );
  }

  static Container listingPostedByProviderElement(
      BuildContext context,
      Listings listing,
      String title,
      bool isAlone,
      Map<String, dynamic> listingPostedBy) {
    final postedByItem = {
      'icon': 'assets/icons/Work.svg',
      'text': listing.details['posted_by'] ?? "Not available",
    };

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: isAlone
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'poppins',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          ),
          listingCardProvider(postedByItem, true, false),
        ],
      ),
    );
  }

  static Container listingFurnishingStatusProviderElement(
      BuildContext context,
      Listings listing,
      String title,
      bool isAlone,
      Map<String, dynamic> listingPostedBy) {
    final postedByItem = {
      'icon': 'assets/icons/Home.svg',
      'text': listing.details['furnishing'] ?? "Not available",
    };

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: isAlone
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'poppins',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          ),
          listingCardProvider(postedByItem, true, false),
        ],
      ),
    );
  }

// Application Deadline for the Job Posts
  static Container listingApplicationDeadlineProviderElement(
      BuildContext context,
      Listings listings,
      String title,
      bool isAlone,
      Map<String, dynamic> listingPostedBy) {
    final applicationDeadlineItem = {
      'icon': 'assets/icons/Calendar.svg',
      'text': listings.listingType == 'bid'
          ? listings.details['bid_deadline'] ?? "N/A"
          : listings.details['application_deadline'] ?? "N/A",
    };

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: isAlone
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          : const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColor.secondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'poppins',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 7),
          ),
          listingCardProvider(applicationDeadlineItem, true, true),
        ],
      ),
    );
  }

  // Job Description Header
  static Padding listingHeaderComponents(Listings listing) {
    final List<Map<String, dynamic>> jobInfoItems = [
      {'icon': 'assets/icons/Location.svg', 'text': listing.location},
      {
        'icon': 'assets/icons/Time.svg',
        'text': '${listing.details['min_experience']} of min experience'
      },
      {
        'icon': 'assets/icons/Calendar.svg',
        'text': '${listing.details['job_type']}'
      },
      {'icon': 'assets/icons/Wallet.svg', 'text': 'ETB. ${listing.price}'},
    ];
    final List<Map<String, dynamic>> carInfoItems = [
      {'icon': 'assets/icons/Location.svg', 'text': listing.location},
      {
        'icon': 'assets/icons/Calendar.svg',
        'text': _formatDate(listing.createdAt.toString())
      },
    ];
    final List<Map<String, dynamic>> bidInfoItems = [
      {'icon': 'assets/icons/Location.svg', 'text': listing.location},
      {
        'icon': 'assets/icons/Calendar.svg',
        'text': _formatDate(listing.createdAt.toString())
      },
    ];
    final List<Map<String, dynamic>> scholarshipInfoItems = [
      {'icon': 'assets/icons/Location.svg', 'text': listing.location},
      {
        'icon': 'assets/icons/Calendar.svg',
        'text': _formatDate(listing.createdAt.toString())
      },
    ];
    final List<Map<String, dynamic>> homeInfoItems = [
      {'icon': 'assets/icons/Location.svg', 'text': listing.location},
      {
        'icon': 'assets/icons/Correct.svg',
        'text': listing.details['condition']
      },
      {
        'icon': 'assets/icons/Calendar.svg',
        'text': _formatDate(listing.createdAt.toString())
      },
      {
        'icon': 'assets/icons/Arrow-up.svg',
        'text': listing.details['square_meters']
      },
    ];

    late List<Map<String, dynamic>> infoItems;
    if (listing.listingType == 'job') {
      infoItems = jobInfoItems;
    } else if (listing.listingType == 'car') {
      infoItems = carInfoItems;
    } else if (listing.listingType == 'home') {
      infoItems = homeInfoItems;
    } else if (listing.listingType == 'scholarship') {
      infoItems = scholarshipInfoItems;
    } else if (listing.listingType == 'bid') {
      infoItems = bidInfoItems;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: infoItems.length,
        itemBuilder: (context, index) {
          final item = infoItems[index];
          return listingCardProvider(item, false, false);
        },
      ),
    );
  }

  static Container listingCardProvider(
      dynamic item, bool isPostedBy, bool isApplicationDeadline) {
    return Container(
      padding: isPostedBy
          ? const EdgeInsets.symmetric(vertical: 25, horizontal: 5)
          : const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            item['icon'],
            color: AppColor.secondary,
            width: isPostedBy ? 25 : 25,
            height: isPostedBy ? 25 : 25,
          ),
          SizedBox(width: isPostedBy ? 16 : 8),
          Expanded(
            child: Text(
              isApplicationDeadline ? _formatDate(item['text']) : item['text'],
              style: TextStyle(
                fontSize: isPostedBy ? 16 : 14,
                color: AppColor.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper function to parse and format the date
  static String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d').format(date);
    } catch (e) {
      return dateString; // Return original text if parsing fails
    }
  }

  // Application Deadline for the Job Posts
  static Container scholarshipListingsProviderElement(BuildContext context,
      listing, iconPath, title, description, bool isBidderType) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eligibility Criteria Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      color: AppColor.secondary,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Eligibility Description
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    listing.listingType == 'bid'
                        ? isBidderType
                            ? description ?? 'Not Provided'
                            : "ETB. $description"
                        : description ?? 'Not Provided',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper function to format date
// static String _formatDate(String? dateString) {
//   if (dateString == null || dateString.isEmpty) return 'Date unavailable';
//   try {
//     DateTime date = DateTime.parse(dateString);
//     return DateFormat('MMM d, yyyy').format(date);
//   } catch (e) {
//     return 'Invalid date';
//   }
// }

  static Container listingDetailsReview(BuildContext context) {
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
            title: const Text(
              'Reviews',
              style: TextStyle(
                color: AppColor.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'poppins',
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListView.separated(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) =>
              //       ReviewTile(review: listing.reviews[index]),
              //   separatorBuilder: (context, index) =>
              //       const SizedBox(height: 16),
              //   itemCount: 2,
              // ),
              Container(
                margin: const EdgeInsets.only(left: 52, top: 12, bottom: 6),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ReviewsPage(
                    //       reviews: listing.reviews,
                    //     ),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: AppColor.primary,
                    elevation: 0,
                    primary: AppColor.primarySoft,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'See More Reviews',
                    style: TextStyle(
                        color: AppColor.secondary, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

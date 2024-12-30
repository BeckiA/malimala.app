import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/config/app_configuration.dart';
import 'package:waloma/core/providers/listing_providers.dart';
import 'package:waloma/core/services/listing_services/listing_api_services.dart';
import 'package:waloma/views/screens/listing_post_page.dart';

class ManageListingsWidget extends StatefulWidget {
  final Listings listing;
  final Function onUpdate; // Add a callback to notify parent

  ManageListingsWidget(
      {Key? key, required this.listing, required this.onUpdate})
      : super(key: key);

  @override
  State<ManageListingsWidget> createState() => _ManageListingsWidgetState();
}

class _ManageListingsWidgetState extends State<ManageListingsWidget> {
  String? selectedAction;

  DecorationImage _imagePathProvider() {
    if (widget.listing.listingType == 'bid') {
      return const DecorationImage(
        image: AssetImage('assets/images/bid-placeholder.jpg'),
        fit: BoxFit.cover,
      );
    } else if (widget.listing.listingType == 'job') {
      return const DecorationImage(
        image: AssetImage('assets/images/job-placeholder.jpg'),
        fit: BoxFit.cover,
      );
    } else if (widget.listing.listingType == 'scholarship') {
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

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;

    String imageUrl = listing.listingImages.isNotEmpty
        ? listing.listingImages[0]
        : 'https://placeholder.com/150';

    if (!imageUrl.startsWith('http') && imageUrl.isNotEmpty) {
      imageUrl = imageUrl.startsWith('/') ? imageUrl.substring(1) : imageUrl;
      imageUrl = 'http://${AppConfiguration.apiURL}/$imageUrl';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(3, 3),
          ),
        ],
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: listing.listingType == 'scholarship' ||
                    listing.listingType == 'job' ||
                    listing.listingType == 'bid'
                ? Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: _imagePathProvider(),
                    ),
                  )
                : Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Location.svg',
                      width: 18,
                      height: 18,
                      color: AppColor.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        listing.location,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColor.primarySoft,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedAction,
                hint: Row(
                  children: [
                    Icon(Icons.more_vert, color: AppColor.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Actions',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.primary,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: const [
                        Icon(FeatherIcons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: const [
                        Icon(FeatherIcons.trash, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) async {
                  setState(() {
                    selectedAction = value;
                  });

                  if (value == 'Delete') {
                    _confirmDelete(context, listing.title, listing.id);
                  } else if (value == 'Edit') {
                    final shouldRefresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingPostScreen(
                          listings: listing,
                        ),
                      ),
                    );

                    if (shouldRefresh == true) {
                      widget.onUpdate();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String title, int listingId) {
    PanaraConfirmDialog.show(
      context,
      title: 'Delete "$title"?',
      message: 'Are you sure you want to delete this listing?',
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
      onTapCancel: () {
        Navigator.of(context).pop(); // Close dialog
      },
      onTapConfirm: () {
        Navigator.of(context).pop(); // Close dialog
        handleDeleteListing(listingId); // Call delete function
      },
      color: Colors.redAccent,
      panaraDialogType: PanaraDialogType.error, // Customize with 'error' style
      barrierDismissible: false, // Prevent dismissal by tapping outside
    );
  }

  void handleDeleteListing(int listingId) async {
    final response = await ListingService.deleteListing(listingId);

    if (response['success']) {
      // Show success message or perform further actions
      print(response['message']);
      // Refresh the listings if needed
      Provider.of<ListingsProvider>(context, listen: false).fetchListings();
    } else {
      // Handle the error
      print(response['message']);
    }
  }
}

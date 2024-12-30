import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/providers/listing_providers.dart';
import 'package:waloma/views/screens/listing_post_page.dart';
import 'package:waloma/views/widgets/listing_placeholder_animations/manage_listing_loader_widget.dart';
import 'package:waloma/views/widgets/manage_listing_widgets/manage_listings_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageListingContainer extends StatefulWidget {
  ManageListingContainer({Key? key}) : super(key: key);

  @override
  _ManageListingContainerState createState() => _ManageListingContainerState();
}

class _ManageListingContainerState extends State<ManageListingContainer> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch from provider when widget initializes
    Future.microtask(() =>
        Provider.of<ListingsProvider>(context, listen: false).fetchListings());
  }

  Future<void> _refreshListings() async {
    // Call the fetch method from the provider
    await Provider.of<ListingsProvider>(context, listen: false).fetchListings();
  }

  Future<void> _navigateToListingForm(
      BuildContext context, Listings? listing) async {
    // Await the result from the listing form
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListingPostScreen(listings: listing),
      ),
    );

    // Refresh the listings if needed
    if (shouldRefresh == true) {
      _refreshListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Consumer<ListingsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            // Show skeleton loaders when loading
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(6, (index) => ManageListingsShimmer()),
            );
          } else if (provider.listings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/no-product-found.png"),
                  const SizedBox(height: 5),
                  const Text(
                    'No listings available to preview',
                    style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
                  ),
                ],
              ),
            );
          } else {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                provider.listings.length,
                (index) => GestureDetector(
                  onTap: () => _navigateToListingForm(
                    context,
                    provider.listings[index],
                  ),
                  child: ManageListingsWidget(
                    onUpdate: _refreshListings,
                    listing: provider.listings[index],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/providers/listing_providers.dart';
import 'package:waloma/views/widgets/item_card.dart';
import 'package:waloma/views/widgets/listing_placeholder_animations/item_skeleton_loader_widet.dart';

// ignore: must_be_immutable
class CategoryListingContainer extends StatefulWidget {
  final String categoryPath;
  CategoryListingContainer({Key? key, required this.categoryPath})
      : super(key: key);

  @override
  _CategoryListingContainerState createState() =>
      _CategoryListingContainerState();
}

class _CategoryListingContainerState extends State<CategoryListingContainer> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch from provider when widget initializes
    Future.microtask(() => Provider.of<ListingsProvider>(context, listen: false)
        .fetchListingsByCategory(widget.categoryPath));
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
              children: List.generate(6, (index) => const ItemCardSkeleton()),
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
            ));
          } else {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                provider.listings.length,
                (index) => ItemCard(
                  listing: provider.listings[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

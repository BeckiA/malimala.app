import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/providers/listing_providers.dart';
import 'package:waloma/views/widgets/item_card.dart';
import 'package:waloma/views/widgets/listing_placeholder_animations/item_skeleton_loader_widet.dart';

class ListingContainer extends StatefulWidget {
  const ListingContainer({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListingContainerState createState() => _ListingContainerState();
}

class _ListingContainerState extends State<ListingContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Consumer<ListingsProvider>(
        builder: (context, listingsProvider, snapshot) {
          if (listingsProvider.isLoading) {
            // Display skeleton loaders while waiting for data
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(6, (index) => const ItemCardSkeleton()),
            );
          } else if (listingsProvider.listings.isEmpty) {
            return const Center(child: Text('No listings available'));
          } else {
            List<Listings> listings = listingsProvider.listings;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                listings.length,
                (index) => ItemCard(
                  listing: listings[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

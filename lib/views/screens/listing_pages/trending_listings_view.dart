import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/listing_models/listing_response_model.dart';
import 'package:waloma/core/services/listing_services/listing_api_services.dart';
import 'package:waloma/views/widgets/item_card.dart';
import 'package:waloma/views/widgets/listing_placeholder_animations/trending_items_skeleton_widget.dart';

class TrendingListingsView extends StatefulWidget {
  const TrendingListingsView({Key? key}) : super(key: key);

  @override
  State<TrendingListingsView> createState() => _TrendingListingsViewState();
}

class _TrendingListingsViewState extends State<TrendingListingsView> {
  late Future<List<Listings>> _futureListings;

  @override
  void initState() {
    super.initState();
    _futureListings = ListingService.fetchListings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listings>>(
      future: _futureListings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display skeleton loaders while waiting for data
          return SizedBox(
            height: 270,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children:
                  List.generate(6, (index) => const TrendingListingsSkeleton()),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load listings'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No listings available'));
        } else {
          List<Listings> listings = snapshot.data!;
          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 265,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      listings.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItemCard(
                              listing: listings[index],
                              titleColor: AppColor.primary,
                              priceColor: AppColor.accent,
                            ),
                            SizedBox(
                              width: 180,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const LinearProgressIndicator(
                                          minHeight: 10,
                                          value: 0.4,
                                          color: AppColor.accent,
                                          backgroundColor: AppColor.border,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColor.accent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

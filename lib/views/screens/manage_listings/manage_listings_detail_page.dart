import 'package:flutter/material.dart';
import 'package:waloma/views/screens/category_pages/category_hero_display_page.dart';
import 'package:waloma/views/screens/manage_listings/manage_listings_page.dart';

// ignore: must_be_immutable
class ManageListingsDetailsScreen extends StatelessWidget {
  ManageListingsDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [const CategoryHeroDisplayPage(), ManageListingContainer()],
    ));
  }
}

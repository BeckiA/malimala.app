import 'package:flutter/material.dart';
import 'package:waloma/views/screens/category_pages/category_hero_display_page.dart';
import 'package:waloma/views/screens/category_pages/category_listings_page.dart';

// ignore: must_be_immutable
class CategoryDetailsScreen extends StatelessWidget {
  String categoryPath = '';
  CategoryDetailsScreen({Key? key, required this.categoryPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        const CategoryHeroDisplayPage(),
        CategoryListingContainer(categoryPath: categoryPath)
      ],
    ));
  }
}

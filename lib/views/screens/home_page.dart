import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/Category.dart';
import 'package:waloma/core/services/CategoryService.dart';
import 'package:waloma/views/screens/category_detail_screen.dart';
import 'package:waloma/views/screens/homepage_helpers/home_hero_page.dart';
import 'package:waloma/views/screens/homepage_helpers/view_category_page.dart';
import 'package:waloma/views/screens/listing_pages/lsiting_container_page.dart';
import 'package:waloma/views/screens/listing_pages/trending_listings_view.dart';
import 'package:waloma/views/widgets/category_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categoryData = CategoryService.categoryData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1
          const HomeHeroDisplayPage(titleMessage: 'Find the best \n for you.'),
          // Section 2 - category
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewMoreWidget(),
                            )),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          'View More',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                // Category list
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 96,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categoryData.length,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 16);
                    },
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        data: categoryData[index],
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailsScreen(
                                  categoryPath:
                                      categoryData[index].categoryPath),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Section 4 - Flash Sale
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Trending Sales',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const TrendingListingsView()
              ],
            ),
          ),

          // Section 5 - product list

          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              'Todays recommendation...',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),

          const ListingContainer()
        ],
      ),
    );
  }
}

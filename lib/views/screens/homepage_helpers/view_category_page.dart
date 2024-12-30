import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/views/screens/category_detail_screen.dart';
import 'package:waloma/views/screens/category_pages/category_hero_display_page.dart';
import 'package:waloma/views/screens/homepage_helpers/home_hero_page.dart';
import 'package:waloma/views/widgets/menu_tile_widget.dart';

class ViewMoreWidget extends StatelessWidget {
  const ViewMoreWidget({Key? key}) : super(key: key);

  void navigator(BuildContext context, categoryPath) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryDetailsScreen(
            categoryPath: categoryPath,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // Section 1
            const CategoryHeroDisplayPage(),
            // Section 2 - category
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      'LISTING CATEGORIES',
                      style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.5),
                          letterSpacing: 6 / 100,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MenuTileWidget(
                    onTap: () => navigator(context, 'home'),
                    icon: SvgPicture.asset(
                      'assets/icons/Home.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Houses',
                    margin: const EdgeInsets.all(0),
                  ),
                  const SizedBox(height: 16),
                  MenuTileWidget(
                    onTap: () => navigator(context, 'car'),
                    icon: SvgPicture.asset(
                      width: 50,
                      height: 50,
                      'assets/icons/Car.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Vehicles',
                    margin: const EdgeInsets.all(0),
                  ),
                  const SizedBox(height: 16),
                  MenuTileWidget(
                    onTap: () => navigator(context, 'job'),
                    icon: SvgPicture.asset(
                      'assets/icons/Work.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Jobs',
                    margin: const EdgeInsets.all(0),
                  ),
                  const SizedBox(height: 16),
                  MenuTileWidget(
                    onTap: () => navigator(context, 'scholarship'),
                    icon: SvgPicture.asset(
                      'assets/icons/Bookmark.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Scholarships',
                    margin: const EdgeInsets.all(0),
                  ),
                  const SizedBox(height: 16),
                  MenuTileWidget(
                    onTap: () => navigator(context, 'bid'),
                    icon: SvgPicture.asset(
                      'assets/icons/Document.svg',
                      color: AppColor.secondary.withOpacity(0.5),
                    ),
                    title: 'Bids',
                    margin: const EdgeInsets.all(0),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}

import 'package:waloma/core/model/Category.dart';

class CategoryService {
  static List<Category> categoryData =
      categoryRawData.map((data) => Category.fromJson(data)).toList();
}

var categoryRawData = [
  {
    'featured': true,
    'icon_url': 'assets/icons/Discount.svg',
    'name': 'Best offers',
    'category_path': '/'
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/House.svg',
    'name': 'Houses',
    'category_path': 'home'
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Car.svg',
    'name': 'Vehicles',
    'category_path': 'car'
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Work.svg',
    'name': 'Jobs',
    'category_path': 'job'
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Bookmark.svg',
    'name': 'Scholarships',
    'category_path': 'scholarship'
  },
  {
    'featured': false,
    'icon_url': 'assets/icons/Document.svg',
    'name': 'Bids',
    'category_path': 'bid'
  },
];

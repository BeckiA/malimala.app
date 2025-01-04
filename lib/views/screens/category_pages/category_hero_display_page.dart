import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/views/screens/chat_pages/message_page.dart';
import 'package:waloma/views/widgets/custom_icon_button_widget.dart';

class CategoryHeroDisplayPage extends StatelessWidget {
  const CategoryHeroDisplayPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 26),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconButtonWidget(
                  onTap: () => Navigator.pop(context),
                  value: 0,
                  icon: SvgPicture.asset(
                    'assets/icons/Arrow-left.svg',
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(0),
                ),
                Row(
                  children: [
                    CustomIconButtonWidget(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => MessagePage()));
                      },
                      value: 2,
                      margin: const EdgeInsets.only(left: 16),
                      icon: SvgPicture.asset(
                        'assets/icons/Chat.svg',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

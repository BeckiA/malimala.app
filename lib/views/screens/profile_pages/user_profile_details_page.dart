import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waloma/constant/app_color.dart';

class UserProfileList extends StatefulWidget {
  final String profileName;
  final String headlineText;
  final Widget menuTiles;
  const UserProfileList(
      {Key? key,
      required this.profileName,
      required this.headlineText,
      required this.menuTiles})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileListState createState() => _UserProfileListState();
}

class _UserProfileListState extends State<UserProfileList> {
  Future _pageNavigator(Widget widget, BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(widget.profileName,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset('assets/icons/Arrow-left.svg'),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: Text(
                  widget.headlineText,
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              widget.menuTiles,
            ]));
  }
}

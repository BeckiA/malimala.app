import 'package:flutter/material.dart';
import 'package:waloma/core/model/ExploreItem.dart';

class ExploreCardWidget extends StatelessWidget {
  final ExploreItem data;
  const ExploreCardWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          image: AssetImage(data.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

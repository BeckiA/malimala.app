import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/Search.dart';

class SearchHistoryTile extends StatelessWidget {
  SearchHistoryTile({required this.data, required this.onTap});

  final SearchHistory data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColor.primarySoft,
              width: 1,
            ),
          ),
        ),
        // ignore: unnecessary_string_interpolations
        child: Text('${data.title}'),
      ),
    );
  }
}

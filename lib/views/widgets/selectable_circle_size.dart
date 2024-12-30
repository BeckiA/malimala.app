import 'package:flutter/material.dart';
import 'package:waloma/constant/app_color.dart';
import 'package:waloma/core/model/ProductSize.dart';

class SelectableCircleSize extends StatefulWidget {
  final List<ProductSize> productSize;
  final Color selectedColor;
  final Color baseColor;
  final TextStyle selectedTextStyle;
  final TextStyle textStyle;

  final EdgeInsetsGeometry margin, padding;
   SelectableCircleSize({
    required this.productSize,
    required this.margin,
    required this.padding,
    required this.selectedColor,
    required this.baseColor,
    required this.textStyle,
    required this.selectedTextStyle,
  });

  @override
  _SelectableCircleState createState() => _SelectableCircleState();
}

class _SelectableCircleState extends State<SelectableCircleSize> {
  int _selectedIndex = 0;

  _change(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getTextStyle(index) {
    if (index == _selectedIndex) {
      if (widget.selectedTextStyle == null) return const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
      return widget.selectedTextStyle;
    } else {
      if (widget.textStyle == null) return const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w600);
      return widget.textStyle;
    }
  }

  _getBackgroundColor(index) {
    if (index == _selectedIndex) {
      // ignore: unnecessary_null_comparison
      if (widget.selectedColor == null) return AppColor.secondary;
      return widget.selectedColor;
    } else {
      // ignore: unnecessary_null_comparison
      if (widget.baseColor == null) return AppColor.primarySoft;
      return widget.baseColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: List.generate(
          widget.productSize.length,
          (index) {
            return InkWell(
              onTap: () {
                _change(index);
              },
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: _getBackgroundColor(index),
                ),
                child: Text(
                  widget.productSize[index].name,
                  style: _getTextStyle(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

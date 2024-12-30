import 'package:flutter/material.dart';

class IconToastWidget extends StatelessWidget {
  final Icon icon;
  final String msg;
  final Color backgroundColor;

  // Named constructor for success
  IconToastWidget.success({
    Key? key,
    required this.msg,
  })  : icon = const Icon(Icons.check_circle, color: Colors.green, size: 24),
        backgroundColor = Colors.green[100]!,
        super(key: key);

  // Named constructor for error
  IconToastWidget.error({
    Key? key,
    required this.msg,
  })  : icon = const Icon(Icons.error, color: Colors.red, size: 24),
        backgroundColor = Colors.red[100]!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

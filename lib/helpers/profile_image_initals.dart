import 'package:flutter/material.dart';

class ProfileInitals {
// Helper function to get initials from the first and last name
  static String getInitials(String? firstName, String? lastName) {
    String firstInitial =
        (firstName?.isNotEmpty ?? false) ? firstName![0].toUpperCase() : '';
    String lastInitial =
        (lastName?.isNotEmpty ?? false) ? lastName![0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

// Helper function to generate a background color based on initials
  static Color getBackgroundColorForInitials(
      String? firstName, String? lastName) {
    // Fallback to empty string if null
    final initials = getInitials(firstName ?? '', lastName ?? '');
    // Sum the character codes of initials, defaulting to 0 if initials are empty
    final colorIndex = initials.isNotEmpty
        ? initials.codeUnits
            .fold(0, (prev, char) => int.parse(prev.toString()) + char)
        : 0;
    // Use modulo to cycle through the color palette
    return _colorPalette[colorIndex % _colorPalette.length];
  }

// Define a list of colors for the background
  static final List<Color> _colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];
}

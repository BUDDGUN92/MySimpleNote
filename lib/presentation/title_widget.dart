/// A widget that displays the application title "My Simple Note".
///
/// This widget creates a centered text display with specific styling:
/// - Black color (ARGB: 255, 0, 0, 0)
/// - Font size of 50
/// - Bold font weight
/// - Helvetica Neue font family
///
/// Used as the header or title component in the application.
///
/// Example:
/// ```dart
/// TitleWidget()
/// ```
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'My Simple Note',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontSize: 50,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

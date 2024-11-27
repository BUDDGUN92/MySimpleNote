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
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

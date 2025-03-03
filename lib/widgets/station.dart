import 'package:flutter/material.dart';
import 'package:music_app/widgets/braille_cell.dart';

class Station extends StatelessWidget {
  final String data;

  const Station({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BrailleCell(value: 255),
        BrailleCell(value: 255),
        SizedBox(width: 12),
        BrailleCell(value: 255),
        BrailleCell(value: 255),
        SizedBox(width: 12),
        BrailleCell(value: 255),
        BrailleCell(value: 255),
        SizedBox(width: 12),
        BrailleCell(value: 255),
        BrailleCell(value: 255),
        SizedBox(width: 12),
        BrailleCell(value: 255),
        BrailleCell(value: 255),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_app/widgets/braille_cell_pin.dart';

class BrailleCell extends StatelessWidget {
  final int value;

  const BrailleCell({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Column(
          children: [
            BrailleCellPin(isActivated: true),
            BrailleCellPin(isActivated: false),
            BrailleCellPin(isActivated: false),
            BrailleCellPin(isActivated: false),
          ],
        ),
        Column(
          children: [
            BrailleCellPin(isActivated: true),
            BrailleCellPin(isActivated: false),
            BrailleCellPin(isActivated: false),
            BrailleCellPin(isActivated: false),
          ],
        ),
      ],
    );
  }
}

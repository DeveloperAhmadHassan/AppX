import 'package:flutter/material.dart';
import 'package:heroapp/utils/extensions/string.dart';

import '../../../models/reel.dart';

class ChunkIndicators extends StatelessWidget {
  const ChunkIndicators({
    super.key,
    required this.reel,
    required double currentPosition,
  }) : _currentPosition = currentPosition;

  final Reel reel;
  final double _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: reel.timestamps!.asMap().entries.map((entry) {
          String timestamp = entry.value;
          int timestampInSeconds = timestamp.toSeconds();
          bool isActivated = _currentPosition >= timestampInSeconds;

          return Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: reel.timestamps!.length < 20 ? 4.0 : 0.2),
              child: LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey,
                minHeight: 2,
                valueColor: AlwaysStoppedAnimation<Color>(isActivated ? Colors.white : Colors.grey),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

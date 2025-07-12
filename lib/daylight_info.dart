import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaylightInfo extends StatelessWidget {
  final int sunriseTimestamp;
  final int sunsetTimestamp;

  const DaylightInfo({
    super.key,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
  });

  String formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    return DateFormat('hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final sunrise = DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);
    final now = DateTime.now();

    final totalDuration = sunset.difference(sunrise);
    final remainingDuration = sunset.difference(now);

    String formatDuration(Duration d) => '${d.inHours}H ${(d.inMinutes % 60)}M';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Sunrise', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(formatTime(sunriseTimestamp)),
              ],
            ),
            Column(
              children: [
                const Text('Sunset', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(formatTime(sunsetTimestamp)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Length of day: ${formatDuration(totalDuration)}'),
        Text('Remaining daylight: ${formatDuration(remainingDuration)}'),
      ],
    );
  }
}
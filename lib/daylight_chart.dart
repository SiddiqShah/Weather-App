import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DaylightChart extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime now;

  const DaylightChart({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final sunriseStr = DateFormat('hh:mm a').format(sunrise);
    final sunsetStr = DateFormat('hh:mm a').format(sunset);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUNRISE & SUNSET',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: CustomPaint(
            size: const Size(double.infinity, 70),
            painter: _DaylightChartPainter(
              sunrise: sunrise,
              sunset: sunset,
              now: now,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sunrise', style: TextStyle(color: Colors.grey)),
                Text(sunriseStr),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Sunset', style: TextStyle(color: Colors.grey)),
                Text(sunsetStr),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DaylightChartPainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime now;

  _DaylightChartPainter({
    required this.sunrise,
    required this.sunset,
    required this.now,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final dayLength = sunset.difference(sunrise).inSeconds;
    final points = <Offset>[];
    for (double i = 0; i <= size.width; i += 1) {
      final percent = i / size.width;
      final rad = percent * pi;
      final y = size.height - sin(rad) * size.height * 0.9;
      points.add(Offset(i, y));
    }
    final path = Path()..moveTo(0, size.height);
    for (final p in points) {
      path.lineTo(p.dx, p.dy);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final horizonPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      horizonPaint,
    );

    if (now.isAfter(sunrise) && now.isBefore(sunset)) {
      final elapsed = now.difference(sunrise).inSeconds;
      final percent = elapsed / dayLength;
      final dx = percent * size.width;
      final rad = percent * pi;
      final dy = size.height - sin(rad) * size.height * 0.9;
      final dotPaint = Paint()
        ..color = Colors.orange
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), 7, dotPaint);

      final sunRayPaint = Paint()
        ..color = Colors.orange.withOpacity(0.7)
        ..strokeWidth = 2;
      for (var i = 0; i < 8; i++) {
        final angle = pi / 4 * i;
        final rayLength = 15;
        final rayDx = dx + cos(angle) * rayLength;
        final rayDy = dy + sin(angle) * rayLength;
        canvas.drawLine(Offset(dx, dy), Offset(rayDx, rayDy), sunRayPaint);
      }
    }

    final nightPaint = Paint()..color = Colors.indigo;
    canvas.drawCircle(Offset(0, size.height), 7, nightPaint);
    canvas.drawCircle(Offset(size.width, size.height), 7, nightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
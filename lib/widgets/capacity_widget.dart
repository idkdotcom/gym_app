import 'package:flutter/material.dart';

class GymCapacityWidget extends StatelessWidget {
  const GymCapacityWidget(
      {super.key, required this.currentMembers, required this.maxCapacity});
  final int currentMembers;
  final int maxCapacity;

  @override
  Widget build(BuildContext context) {
    double capacityPercentage = (currentMembers / maxCapacity).clamp(0.0, 1.0);

    Color waterColor;
    if (capacityPercentage > 0.75) {
      waterColor = Colors.red;
    } else if (capacityPercentage > 0.5) {
      waterColor = Colors.yellow;
    } else {
      waterColor = Colors.green;
    }

    return CustomPaint(
      size: const Size(200, 400),
      painter: GlassPainter(capacityPercentage, waterColor),
    );
  }
}

class GlassPainter extends CustomPainter {
  GlassPainter(this.fillPercentage, this.waterColor);

  final double fillPercentage;
  final Color waterColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;

    // Glass paint
    Paint glassPaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Water paint
    Paint waterPaint = Paint()
      ..color = waterColor
      ..style = PaintingStyle.fill;

    // Glass rectangle
    Rect glassRect = Rect.fromLTWH(
      strokeWidth / 2, 
      strokeWidth / 2, 
      size.width - strokeWidth, 
      size.height - strokeWidth,
    );

    // Draw the glass
    canvas.drawRect(glassRect, glassPaint);

    // 80% of glass size for water dimensions
    double waterWidth = (size.width - strokeWidth) * 0.8;
    double waterHeight = (size.height - strokeWidth) * 0.8 * fillPercentage;

    // Calculate left and top to center the water inside the glass
    double waterLeft = (size.width - waterWidth) / 2;
    double waterTop = (size.height - waterHeight) / 1.2;

    // Water rectangle centered inside the glass
    Rect waterRect = Rect.fromLTWH(
      waterLeft,
      waterTop,
      waterWidth,
      waterHeight,
    );

    // Draw the water
    canvas.drawRect(waterRect, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

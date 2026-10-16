import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Subtle eight-point-star lattice for hero panels and framed headers.
///
/// Drawn, not shipped: no asset, no dependency. Keep opacity low — the
/// pattern supports the calm reading space, never competes with text.
/// Verse areas stay plain per `docs/theme.md` §3.3.
class IslamicPattern extends StatelessWidget {
  const IslamicPattern({
    super.key,
    required this.color,
    this.cell = 56,
    this.strokeWidth = 1.2,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LatticePainter(
        color: color,
        cell: cell,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _LatticePainter extends CustomPainter {
  _LatticePainter({
    required this.color,
    required this.cell,
    required this.strokeWidth,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    // Overlapping squares rotated 0° and 45° tile an eight-point star.
    for (double y = -cell; y < size.height + cell; y += cell) {
      for (double x = -cell; x < size.width + cell; x += cell) {
        final Offset c = Offset(x + cell / 2, y + cell / 2);
        final double r = cell * 0.32;
        canvas.drawRect(
          Rect.fromCenter(center: c, width: r * 2, height: r * 2),
          paint,
        );
        final Path diamond = Path();
        for (int i = 0; i < 4; i++) {
          final double a = math.pi / 4 + i * math.pi / 2;
          final Offset p = c + Offset(math.cos(a), math.sin(a)) * r * 1.25;
          if (i == 0) {
            diamond.moveTo(p.dx, p.dy);
          } else {
            diamond.lineTo(p.dx, p.dy);
          }
        }
        diamond.close();
        canvas.drawPath(diamond, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LatticePainter old) {
    return old.color != color || old.cell != cell;
  }
}

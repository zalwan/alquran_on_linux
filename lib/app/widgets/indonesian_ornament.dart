import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../../core/format/arabic_numerals.dart';

/// Indonesian batik kawung lattice for hero panels and framed headers.
///
/// Drawn, not shipped: four almond petals cross around every grid point,
/// the way kawung flowers bloom across a diagonal batik ground. No asset,
/// no dependency. Keep opacity low — the pattern supports the calm reading
/// space, never competes with text. Verse areas stay plain per
/// `docs/theme.md` §3.3.
class KawungPattern extends StatelessWidget {
  const KawungPattern({
    super.key,
    required this.color,
    this.cell = 52,
    this.strokeWidth = 1.1,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _KawungPainter(
        color: color,
        cell: cell,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _KawungPainter extends CustomPainter {
  _KawungPainter({
    required this.color,
    required this.cell,
    required this.strokeWidth,
  });

  final Color color;
  final double cell;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final Paint fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // Authentic kawung ground: each grid point blooms a four-petal flower
    // (petals pointing up, down, left, right) with pin dots — colen —
    // tucked between the petal roots. Petal tips of neighbours just meet,
    // so the negative space reads as a clean diamond lattice.
    final double petalLength = cell * 0.52;
    final double petalWidth = cell * 0.30;
    final double root = cell * 0.24;
    const List<Offset> directions = [
      Offset(0, -1),
      Offset(1, 0),
      Offset(0, 1),
      Offset(-1, 0),
    ];
    for (double y = -cell; y < size.height + cell; y += cell) {
      for (double x = -cell; x < size.width + cell; x += cell) {
        final Offset c = Offset(x + cell / 2, y + cell / 2);
        for (final Offset dir in directions) {
          _petal(canvas, c + dir * root, petalWidth, petalLength, dir, stroke);
        }
        for (final Offset a in const [
          Offset(1, -1),
          Offset(1, 1),
          Offset(-1, 1),
          Offset(-1, -1),
        ]) {
          canvas.drawCircle(
            c + a * root * 0.55,
            math.max(0.8, cell * 0.025),
            fill,
          );
        }
        canvas.drawCircle(c, math.max(1.0, cell * 0.035), fill);
      }
    }
  }

  void _petal(
    Canvas canvas,
    Offset center,
    double width,
    double length,
    Offset direction,
    Paint paint,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 2 - direction.direction);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: width, height: length),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KawungPainter old) {
    return old.color != color || old.cell != cell;
  }
}

/// Double-rule cartouche with pointed ends — the surah-name plate shape
/// used in Indonesian mushaf standards (Kemenag / Menara Kudus).
class CartouchePlate extends StatelessWidget {
  const CartouchePlate({
    super.key,
    required this.child,
    this.color,
    this.fillColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 46, vertical: 10),
  });

  final Widget child;
  final Color? color;
  final EdgeInsets padding;

  /// Kept on the plate colour by default so the plate reads as a cut-out.
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color gold =
        color ??
        (theme.brightness == Brightness.dark
            ? AppColors.darkGold
            : AppColors.gold);
    return CustomPaint(
      painter: _CartouchePainter(
        stroke: gold,
        fill: fillColor ?? scheme.primaryContainer,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _CartouchePainter extends CustomPainter {
  _CartouchePainter({required this.stroke, required this.fill});

  final Color stroke;
  final Color fill;

  /// Silhouette of the plate: a straight top/bottom edge bowing into a
  /// point at each end, like a stretched leaf.
  Path _platePath(Size size, double inset) {
    final double h = size.height;
    final double y0 = inset;
    final double y1 = h - inset;
    final double ym = h / 2;
    final double xl = inset;
    final double xr = size.width - inset;
    final double tip = (h - inset * 2) * 0.5;
    const double k = 0.45;
    return Path()
      ..moveTo(xl + tip, y0)
      ..lineTo(xr - tip, y0)
      ..quadraticBezierTo(xr - tip * 0.25, y0 + (ym - y0) * k, xr, ym)
      ..quadraticBezierTo(xr - tip * 0.25, y1 - (y1 - ym) * k, xr - tip, y1)
      ..lineTo(xl + tip, y1)
      ..quadraticBezierTo(xl + tip * 0.25, y1 - (y1 - ym) * k, xl, ym)
      ..quadraticBezierTo(xl + tip * 0.25, y0 + (ym - y0) * k, xl + tip, y0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.fill;
    final Paint outer = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final Paint inner = Paint()
      ..color = stroke.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(_platePath(size, 1.4), fillPaint);
    canvas.drawPath(_platePath(size, 1.4), outer);
    canvas.drawPath(_platePath(size, 6.0), inner);
  }

  @override
  bool shouldRepaint(covariant _CartouchePainter old) {
    return old.stroke != stroke || old.fill != fill;
  }
}

/// Mushaf frame: double rule with an optional stud diamond in every corner.
///
/// Echoes the ornamental surah-name plates of Indonesian mushaf standards
/// (Kemenag/Menara Kudus) without shipping any raster ornament. The child
/// padding must keep text clear of the rules (~10 px) *and* the diamonds.
class MushafFrame extends StatelessWidget {
  const MushafFrame({
    super.key,
    required this.child,
    this.radius = 10,
    this.cornerGems = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
    this.color,
  });

  final Widget child;
  final double radius;

  /// Set false for pill cartouches, where corner studs would collide with
  /// the full-round end curve.
  final bool cornerGems;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color primary = color ?? Theme.of(context).colorScheme.primary;
    return CustomPaint(
      painter: _MushafFramePainter(
        color: primary,
        radius: radius,
        cornerGems: cornerGems,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _MushafFramePainter extends CustomPainter {
  _MushafFramePainter({
    required this.color,
    required this.radius,
    required this.cornerGems,
  });

  final Color color;
  final double radius;
  final bool cornerGems;

  static const double _inset = 1.2;
  static const double _ruleGap = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outer = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    final Paint inner = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Rect bounds =
        Offset(_inset, _inset) &
        Size(size.width - _inset * 2, size.height - _inset * 2);
    final double r = math.min(radius, bounds.shortestSide / 2);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, Radius.circular(r)),
      outer,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bounds.deflate(_ruleGap),
        Radius.circular(math.max(0, r - 4)),
      ),
      inner,
    );

    if (cornerGems) {
      final double dock = math.min(r, 15);
      final Paint gem = Paint()
        ..color = color.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;
      _cornerGem(canvas, Offset(dock, dock), gem);
      _cornerGem(canvas, Offset(size.width - dock, dock), gem);
      _cornerGem(canvas, Offset(dock, size.height - dock), gem);
      _cornerGem(canvas, Offset(size.width - dock, size.height - dock), gem);
    }
  }

  /// A small stud diamond seated diagonally inside the frame corner —
  /// echoes the corner medallions of Indonesian mushaf surah plates.
  void _cornerGem(Canvas canvas, Offset center, Paint fill) {
    const double r = 4.5;
    final Path diamond = Path();
    final List<Offset> points = [
      center + const Offset(0, -r),
      center + const Offset(r, 0),
      center + const Offset(0, r),
      center + const Offset(-r, 0),
    ];
    diamond.moveTo(points.first.dx, points.first.dy);
    for (final Offset p in points.skip(1)) {
      diamond.lineTo(p.dx, p.dy);
    }
    diamond.close();
    canvas.drawPath(diamond, fill);
  }

  @override
  bool shouldRepaint(covariant _MushafFramePainter old) {
    return old.color != color ||
        old.radius != radius ||
        old.cornerGems != cornerGems;
  }
}

/// Ornamental verse-number medallion: a double gold ring with the
/// ayah number in Arabic-Indic digits, as seen at the head of each verse
/// in Indonesian mushaf printings.
class VerseMedallion extends StatelessWidget {
  const VerseMedallion({super.key, required this.number, this.color});

  final int number;
  final Color? color;

  static const double size = 40;

  @override
  Widget build(BuildContext context) {
    final Color gold =
        color ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkGold
            : AppColors.gold);
    final double fontSize = size * 0.44;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _MedallionPainter(color: gold),
        child: Center(
          child: Text(
            arabicIndic(number),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTypography.arabicFontFamily,
              fontSize: fontSize,
              height: 1.0,
              color: gold,
            ),
          ),
        ),
      ),
    );
  }
}

class _MedallionPainter extends CustomPainter {
  _MedallionPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = size.center(Offset.zero);
    final Paint ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    // Outer hairline ring.
    canvas.drawCircle(c, size.shortestSide / 2 - 1.0, ring..strokeWidth = 1.2);
    // Inner ring carries more weight, framing the number.
    canvas.drawCircle(c, size.shortestSide / 2 - 5.0, ring..strokeWidth = 2.0);
    // Eight studs tick the outer ring at the compass points.
    final Paint stud = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final double angle = i * math.pi / 4;
      final Offset p =
          c +
          Offset(math.cos(angle), math.sin(angle)) *
              (size.shortestSide / 2 - 1.0);
      canvas.drawCircle(p, 1.0, stud);
    }
  }

  @override
  bool shouldRepaint(covariant _MedallionPainter old) {
    return old.color != color;
  }
}

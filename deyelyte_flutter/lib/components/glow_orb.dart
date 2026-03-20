import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Glow Orb (Decorative)
//
// Radial gradient "ambient light" orb for hero backgrounds.
// ─────────────────────────────────────────────────────────────────────────────

class GlowOrb extends StatelessWidget {
  const GlowOrb({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

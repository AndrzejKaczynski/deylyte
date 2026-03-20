import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Border Radius Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;   // Buttons, inputs
  static const double lg  = 16.0;   // Cards
  static const double xl  = 24.0;   // Large modal sheets
  static const double xxl = 32.0;

  static BorderRadius circle   = BorderRadius.circular(999);
  static BorderRadius radiusMd = BorderRadius.circular(md);
  static BorderRadius radiusLg = BorderRadius.circular(lg);
  static BorderRadius radiusXl = BorderRadius.circular(xl);
  static BorderRadius radiusXxl = BorderRadius.circular(xxl);
}

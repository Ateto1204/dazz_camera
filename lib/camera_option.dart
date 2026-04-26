import 'package:flutter/material.dart';

class CameraOption {
  const CameraOption({
    required this.id,
    required this.title,
    required this.previewLabel,
    required this.description,
    required this.accentColor,
    required this.previewColors,
  });

  final String id;
  final String title;
  final String previewLabel;
  final String description;
  final Color accentColor;
  final List<Color> previewColors;
}

const cameraOptions = <CameraOption>[
  CameraOption(
    id: 'classic',
    title: 'Classic',
    previewLabel: 'STANDARD LOOK',
    description: 'Balanced tone with a clean camera preview feel.',
    accentColor: Color(0xFFE2E5EA),
    previewColors: [Color(0xFFEEF2F5), Color(0xFF626A73), Color(0xFF101214)],
  ),
  CameraOption(
    id: 'dazz',
    title: 'Dazz',
    previewLabel: 'DAZZ SOFTLIGHT',
    description: 'Warm highlight bloom with a nostalgic handheld mood.',
    accentColor: Color(0xFFF0A25A),
    previewColors: [Color(0xFFF6C48A), Color(0xFF8D5630), Color(0xFF140F0C)],
  ),
  CameraOption(
    id: 'vintage',
    title: 'Vintage',
    previewLabel: 'AGED FILM',
    description: 'Muted brown tones and softer contrast for an old film look.',
    accentColor: Color(0xFFC3936A),
    previewColors: [Color(0xFFDABB9F), Color(0xFF705341), Color(0xFF130F0B)],
  ),
  CameraOption(
    id: 'mono',
    title: 'Mono',
    previewLabel: 'BLACK & WHITE',
    description: 'Neutral grayscale styling with stronger structure.',
    accentColor: Color(0xFFB2B2B2),
    previewColors: [Color(0xFFE8E8E8), Color(0xFF676767), Color(0xFF090909)],
  ),
  CameraOption(
    id: 'warm',
    title: 'Warm',
    previewLabel: 'SUNSET GLOW',
    description: 'Richer orange-red hues with a brighter center tone.',
    accentColor: Color(0xFFE67854),
    previewColors: [Color(0xFFF2B07C), Color(0xFF9D4937), Color(0xFF130B0A)],
  ),
  CameraOption(
    id: 'cool',
    title: 'Cool',
    previewLabel: 'COOL SHIFT',
    description: 'Blue-tinted styling with a cleaner digital mood.',
    accentColor: Color(0xFF71A9F3),
    previewColors: [Color(0xFFA6D0FF), Color(0xFF365B89), Color(0xFF091018)],
  ),
  CameraOption(
    id: 'dreamy',
    title: 'Dreamy',
    previewLabel: 'DREAM HAZE',
    description: 'Soft lilac glow with a slightly misty preview card.',
    accentColor: Color(0xFFC99FE8),
    previewColors: [Color(0xFFE3C8F4), Color(0xFF775A8E), Color(0xFF110B15)],
  ),
  CameraOption(
    id: 'film',
    title: 'Film',
    previewLabel: 'FILM STOCK',
    description: 'Green-brown mood with a subtle analog atmosphere.',
    accentColor: Color(0xFF7CB184),
    previewColors: [Color(0xFFA3C489), Color(0xFF4E6641), Color(0xFF0E110C)],
  ),
];

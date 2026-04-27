import 'camera_option.dart';

class CameraDetailContent {
  const CameraDetailContent({
    required this.tagline,
    required this.overview,
    required this.features,
    required this.bestFor,
  });

  final String tagline;
  final String overview;
  final List<String> features;
  final List<String> bestFor;
}

const cameraDetailContentById = <String, CameraDetailContent>{
  'original': CameraDetailContent(
    tagline: 'A clean baseline preset for natural framing and tone.',
    overview:
        'Original keeps the preview grounded and neutral so you can focus on composition first. It is the easiest starting point when you want the camera UI to feel clear, balanced, and dependable.',
    features: [
      'Balanced tone',
      'Minimal styling',
      'Reliable default',
      'Easy to preview',
    ],
    bestFor: ['Everyday scenes', 'General framing', 'Quick demos'],
  ),
  'sony-handycam': CameraDetailContent(
    tagline: 'A soft camcorder mood with a casual home-video feel.',
    overview:
        'Sony Handycam introduces a relaxed recording character that feels familiar and approachable. It suits moments where you want the interface to suggest motion, memory, and an easy handheld rhythm.',
    features: [
      'Camcorder mood',
      'Soft digital feel',
      'Relaxed framing',
      'Memory-driven tone',
    ],
    bestFor: ['Travel clips', 'Family moments', 'Casual motion scenes'],
  ),
  'panasonic-viera': CameraDetailContent(
    tagline: 'A brighter digital-video style with a clear consumer look.',
    overview:
        'Panasonic VIERA leans into a cleaner digital-video identity. It feels slightly sharper and more display-ready, making it useful when you want a straightforward recording preset with a crisp presentation.',
    features: [
      'Clean digital look',
      'Bright presentation',
      'Sharper mood',
      'Display-ready feel',
    ],
    bestFor: ['Indoor clips', 'Simple interviews', 'Demo recording'],
  ),
  'hitachi': CameraDetailContent(
    tagline: 'A nostalgic tape-inspired look with a softer vintage edge.',
    overview:
        'Hitachi carries a more retro recording identity. It gives the camera menu a tape-era personality that feels slightly older, warmer, and more archival than the other recording options.',
    features: [
      'Tape-era vibe',
      'Warm nostalgia',
      'Retro recording feel',
      'Soft contrast',
    ],
    bestFor: ['Throwback scenes', 'Memory-style footage', 'Retro intros'],
  ),
  'canon-dslr': CameraDetailContent(
    tagline: 'A still-photo preset with a crisp and dependable DSLR mood.',
    overview:
        'Canon DSLR suggests a photo-first shooting style. It feels structured and familiar, giving the interface a steady, confident tone for scenes where clarity and framing matter most.',
    features: [
      'Photo-first feel',
      'Crisp structure',
      'Dependable style',
      'Classic DSLR mood',
    ],
    bestFor: ['Portrait setups', 'Street stills', 'General photo scenes'],
  ),
  'contax-t2': CameraDetailContent(
    tagline: 'A premium compact film-camera mood with polished restraint.',
    overview:
        'Contax T2 brings in a more refined compact-camera identity. It feels composed, stylish, and slightly cinematic without becoming heavy, which makes it useful for cleaner editorial-style scenes.',
    features: [
      'Refined compact feel',
      'Polished tone',
      'Film-camera mood',
      'Editorial energy',
    ],
    bestFor: ['City scenes', 'Editorial portraits', 'Lifestyle shots'],
  ),
  'fujifilm-instax-mini': CameraDetailContent(
    tagline: 'An instant-camera preset with playful, lighthearted energy.',
    overview:
        'Instax Mini is the most casual and cheerful option in the capture row. It suggests spontaneity, quick memories, and a social snapshot feeling rather than precise technical control.',
    features: [
      'Instant-camera mood',
      'Playful feel',
      'Light snapshot energy',
      'Casual presentation',
    ],
    bestFor: ['Friends', 'Events', 'Playful snapshots'],
  ),
  'olympus-pen': CameraDetailContent(
    tagline: 'A compact half-frame inspired preset for storytelling moments.',
    overview:
        'Olympus PEN gives the menu a more narrative, sequence-friendly personality. It feels compact and stylish, with an emphasis on scenes that benefit from rhythm, story, and a slightly vintage photography spirit.',
    features: [
      'Half-frame reference',
      'Compact styling',
      'Story-focused mood',
      'Vintage spirit',
    ],
    bestFor: ['Travel stories', 'Daily journals', 'Sequential scenes'],
  ),
  'ricoh-gr': CameraDetailContent(
    tagline: 'A compact street-photo preset with a direct modern feel.',
    overview:
        'Ricoh GR is designed around quick, decisive capture. It feels compact, contemporary, and practical, making it a strong choice when you want the UI to suggest speed and confidence.',
    features: [
      'Street-photo feel',
      'Compact control',
      'Quick response mood',
      'Modern minimal tone',
    ],
    bestFor: ['Street moments', 'Quick observations', 'Minimal compositions'],
  ),
};

CameraDetailContent detailContentFor(CameraOption option) {
  return cameraDetailContentById[option.id] ??
      cameraDetailContentById['original']!;
}

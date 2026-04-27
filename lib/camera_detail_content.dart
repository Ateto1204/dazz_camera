import 'camera_option.dart';

enum DetailLanguage { tw, en }

class CameraDetailLocalizedContent {
  const CameraDetailLocalizedContent({
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

class CameraDetailContentBundle {
  const CameraDetailContentBundle({required this.tw, required this.en});

  final CameraDetailLocalizedContent tw;
  final CameraDetailLocalizedContent en;

  CameraDetailLocalizedContent contentFor(DetailLanguage language) {
    return language == DetailLanguage.tw ? tw : en;
  }
}

const cameraDetailContentById = <String, CameraDetailContentBundle>{
  'sony-handycam': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '帶有家用錄影機氛圍的輕鬆紀錄風格。',
      overview:
          'Sony Handycam 這個選項帶來熟悉的家用錄影感，節奏自然、情緒輕鬆，適合想讓畫面看起來像生活紀錄、旅行片段或隨手拍攝回憶時使用。',
      features: ['家用錄影感', '數位柔和氛圍', '輕鬆手持節奏', '日常記憶感'],
      bestFor: ['旅行片段', '家庭日常', '移動中的生活紀錄'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A relaxed recording style with a familiar home-video mood.',
      overview:
          'Sony Handycam brings in an easy camcorder character that feels casual and memory-driven. It works well when you want the interface to suggest daily recording, travel moments, or simple handheld clips.',
      features: [
        'Home-video feel',
        'Soft digital mood',
        'Relaxed handheld rhythm',
        'Memory-driven tone',
      ],
      bestFor: ['Travel clips', 'Family moments', 'Everyday movement scenes'],
    ),
  ),
  'panasonic-viera': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '偏明亮清晰的數位錄影風格。',
      overview:
          'Panasonic VIERA 呈現的是比較乾淨、清楚、帶點消費型數位攝影機氣質的錄影感，適合需要穩定展示、清爽觀看感受的場景。',
      features: ['明亮數位感', '畫面清楚', '展示感較強', '結構俐落'],
      bestFor: ['室內錄影', '簡單訪談', '展示型畫面'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A brighter and cleaner digital-video style.',
      overview:
          'Panasonic VIERA leans toward a straightforward digital-video identity. It feels cleaner and more display-ready, making it useful for scenes that need a crisp and uncomplicated recording tone.',
      features: [
        'Bright digital look',
        'Clear presentation',
        'Display-ready feel',
        'Structured framing mood',
      ],
      bestFor: ['Indoor clips', 'Simple interviews', 'Presentation shots'],
    ),
  ),
  'hitachi': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '帶有錄影帶年代感的懷舊錄影風格。',
      overview:
          'Hitachi 比起其他錄影選項更有復古記錄感，像是較早期的家用錄影器材所呈現的氣氛。它適合想營造回憶、舊時代紀錄感或懷舊開場時使用。',
      features: ['懷舊錄影帶感', '復古氣氛', '偏暖記憶感', '柔和反差'],
      bestFor: ['復古片段', '回憶式開場', '懷舊生活紀錄'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A nostalgic tape-era recording style with a retro edge.',
      overview:
          'Hitachi carries a stronger archival and tape-inspired mood than the other recording options. It is a good fit when you want the menu to feel older, warmer, and more memory-focused.',
      features: [
        'Tape-era vibe',
        'Retro recording mood',
        'Warm nostalgic tone',
        'Soft contrast',
      ],
      bestFor: ['Throwback scenes', 'Retro intros', 'Memory-style footage'],
    ),
  ),
  'canon-dslr': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '穩定清楚的經典 DSLR 拍攝印象。',
      overview:
          'Canon DSLR 這個選項偏向標準攝影感，給人一種穩定、熟悉、可預期的拍照印象。適合想讓介面呈現正規拍攝、構圖清楚的風格。',
      features: ['經典 DSLR 感', '構圖穩定', '清楚標準', '熟悉拍攝氛圍'],
      bestFor: ['人像練習', '一般街拍', '基本展示拍攝'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A dependable DSLR-inspired style with a clean photo mood.',
      overview:
          'Canon DSLR suggests a familiar still-photo identity. It feels steady and reliable, making it a practical choice when you want a clear, structured, and classic photography impression.',
      features: [
        'Classic DSLR mood',
        'Stable framing feel',
        'Clean presentation',
        'Reliable photo-first tone',
      ],
      bestFor: [
        'Portrait setups',
        'General street stills',
        'Basic photo demos',
      ],
    ),
  ),
  'contax-t2': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '精緻簡潔的高級隨身底片機氛圍。',
      overview:
          'Contax T2 帶來一種比較收斂、精緻、帶有品味的拍攝感。它不會太厚重，但會讓整體介面更像偏編輯感、生活風格攝影的選項。',
      features: ['高級隨身感', '精緻收斂', '底片氛圍', '生活編輯感'],
      bestFor: ['城市漫遊', '生活風格人像', '編輯感畫面'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A refined compact-film mood with polished restraint.',
      overview:
          'Contax T2 gives the menu a more composed and premium compact-camera identity. It feels elegant and editorial without becoming heavy, which suits cleaner lifestyle and city scenes.',
      features: [
        'Premium compact feel',
        'Polished tone',
        'Film-inspired restraint',
        'Editorial energy',
      ],
      bestFor: ['City scenes', 'Lifestyle portraits', 'Editorial moments'],
    ),
  ),
  'fujifilm-instax-mini': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '輕鬆、可愛、偏即拍即看的快拍氛圍。',
      overview: 'Instax Mini 是比較輕快、帶玩心的拍攝選項，適合想讓介面感覺更像社交場合、朋友聚會或隨手記錄當下情緒的場景。',
      features: ['即拍即看感', '輕鬆可愛', '快拍氛圍', '社交記錄感'],
      bestFor: ['朋友聚會', '活動紀錄', '隨手快拍'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A playful instant-camera mood for quick snapshots.',
      overview:
          'Instax Mini is the most casual and cheerful option in the capture row. It suggests spontaneity, social moments, and light snapshot energy rather than technical precision.',
      features: [
        'Instant-camera feel',
        'Playful presentation',
        'Quick snapshot mood',
        'Social energy',
      ],
      bestFor: ['Friends', 'Events', 'Playful snapshots'],
    ),
  ),
  'olympus-pen': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '帶故事節奏感的輕巧半格相機印象。',
      overview: 'Olympus PEN 給人的感覺更偏向敘事與日常片段的整理，它讓介面有一種輕巧、節奏分明、適合連續記錄生活的拍攝語氣。',
      features: ['半格相機靈感', '輕巧敘事感', '日常故事氣質', '復古攝影味道'],
      bestFor: ['旅行日記', '生活片段', '連續敘事場景'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A compact half-frame inspired style for narrative moments.',
      overview:
          'Olympus PEN gives the interface a more sequential and story-friendly character. It feels compact and stylish, with a rhythm that suits daily scenes and travel storytelling.',
      features: [
        'Half-frame inspiration',
        'Compact styling',
        'Narrative mood',
        'Vintage photography spirit',
      ],
      bestFor: ['Travel diaries', 'Daily stories', 'Sequence-friendly scenes'],
    ),
  ),
  'ricoh-gr': CameraDetailContentBundle(
    tw: CameraDetailLocalizedContent(
      tagline: '快速、直接、現代感明確的街拍相機風格。',
      overview: 'Ricoh GR 偏向俐落直接的拍攝氣質，適合想讓介面看起來更像快速觀察、立即捕捉、重視瞬間判斷的街拍工具。',
      features: ['街拍工具感', '快速反應', '現代極簡氣質', '直接俐落'],
      bestFor: ['街頭觀察', '快速捕捉', '極簡構圖場景'],
    ),
    en: CameraDetailLocalizedContent(
      tagline: 'A direct, compact street-photo style with modern clarity.',
      overview:
          'Ricoh GR is built around speed and decisiveness. It gives the menu a compact and contemporary character that works well for quick observation and minimal, confident compositions.',
      features: [
        'Street-photo feel',
        'Quick response mood',
        'Modern minimal tone',
        'Compact control energy',
      ],
      bestFor: ['Street moments', 'Quick observations', 'Minimal compositions'],
    ),
  ),
};

CameraDetailContentBundle detailContentFor(CameraOption option) {
  return cameraDetailContentById[option.id]!;
}

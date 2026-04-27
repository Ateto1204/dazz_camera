import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'camera_detail_content.dart';
import 'camera_option.dart';

class CameraDetailPage extends StatefulWidget {
  const CameraDetailPage({super.key, required this.option});

  final CameraOption option;

  @override
  State<CameraDetailPage> createState() => _CameraDetailPageState();
}

class _CameraDetailPageState extends State<CameraDetailPage> {
  static const _languagePreferenceKey = 'camera_detail_language';
  DetailLanguage _language = DetailLanguage.en;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languagePreferenceKey);
    final language = savedLanguage == 'tw'
        ? DetailLanguage.tw
        : DetailLanguage.en;

    if (!mounted) {
      return;
    }

    setState(() {
      _language = language;
    });
  }

  Future<void> _setLanguage(DetailLanguage language) async {
    if (_language == language) {
      return;
    }

    setState(() {
      _language = language;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _languagePreferenceKey,
      language == DetailLanguage.tw ? 'tw' : 'en',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bundle = detailContentFor(widget.option);
    final content = bundle.contentFor(_language);
    final isTw = _language == DetailLanguage.tw;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Camera Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageToggle(
              isTw: isTw,
              onChanged: (value) {
                _setLanguage(value ? DetailLanguage.tw : DetailLanguage.en);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(option: widget.option, tagline: content.tagline),
              const SizedBox(height: 24),
              _SectionTitle(title: isTw ? '簡介' : 'Overview'),
              const SizedBox(height: 10),
              Text(
                content.overview,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.86),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: isTw ? '特色' : 'Features'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: content.features
                    .map((feature) => _FeatureChip(label: feature))
                    .toList(),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: isTw ? '適合場景' : 'Best For'),
              const SizedBox(height: 12),
              Column(
                children: content.bestFor
                    .map((item) => _BestForItem(label: item))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.isTw, required this.onChanged});

  final bool isTw;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageToggleButton(
            label: 'TW',
            selected: isTw,
            onTap: () => onChanged(true),
          ),
          _LanguageToggleButton(
            label: 'EN',
            selected: !isTw,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggleButton extends StatelessWidget {
  const _LanguageToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        key: ValueKey('language-toggle-$label'),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.option, required this.tagline});

  final CameraOption option;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: option.colors,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: ClipOval(
              child: option.iconData != null
                  ? ColoredBox(
                      color: Colors.black.withValues(alpha: 0.16),
                      child: Icon(
                        option.iconData,
                        size: 38,
                        color: Colors.white,
                      ),
                    )
                  : Image.asset(option.thumbnailAssetPath!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            option.title,
            key: const ValueKey('camera-detail-title'),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tagline,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.88),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BestForItem extends StatelessWidget {
  const _BestForItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.white70,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.84),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

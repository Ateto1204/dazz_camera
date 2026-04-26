import 'package:flutter/material.dart';

import 'camera_menu_page.dart';
import 'camera_option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraOption _selectedOption = cameraOptions.first;

  Future<void> _openCameraMenu() async {
    final result = await Navigator.of(context).push<CameraOption>(
      MaterialPageRoute(
        builder: (_) => CameraMenuPage(initialOption: _selectedOption),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedOption = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 720;
            final bottomHeight = compact ? 92.0 : 108.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 14 : 20,
                compact ? 12 : 18,
                compact ? 14 : 20,
                compact ? 14 : 20,
              ),
              child: Column(
                children: [
                  Expanded(child: _PreviewCard(option: _selectedOption)),
                  SizedBox(height: compact ? 14 : 18),
                  SizedBox(
                    height: bottomHeight,
                    child: _BottomControls(onOpenMenu: _openCameraMenu),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.option});

  final CameraOption option;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: option.previewColors,
        ),
        border: Border.all(
          color: option.accentColor.withValues(alpha: 0.42),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: option.accentColor.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxHeight < 360 || constraints.maxWidth < 340;
            final ultraCompact =
                constraints.maxHeight < 280 || constraints.maxWidth < 300;

            return Stack(
              children: [
                Positioned(
                  top: -32,
                  right: -18,
                  child: _PreviewGlow(
                    color: option.accentColor.withValues(alpha: 0.24),
                    size: compact ? 120 : 180,
                  ),
                ),
                Positioned(
                  bottom: -48,
                  left: -24,
                  child: _PreviewGlow(
                    color: Colors.white.withValues(alpha: 0.08),
                    size: compact ? 140 : 210,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 18 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 10 : 12,
                                    vertical: compact ? 6 : 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    option.previewLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: compact ? 0.8 : 1.2,
                                      fontSize: compact ? 11 : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (!ultraCompact)
                                _PreviewStatus(accentColor: option.accentColor),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Current option',
                            style:
                                (compact
                                        ? theme.textTheme.bodyMedium
                                        : theme.textTheme.titleMedium)
                                    ?.copyWith(color: Colors.white70),
                          ),
                          SizedBox(height: compact ? 6 : 8),
                          Text(
                            option.title,
                            key: const ValueKey('selected-camera-option-title'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                (ultraCompact
                                        ? theme.textTheme.headlineMedium
                                        : compact
                                        ? theme.textTheme.headlineLarge
                                        : theme.textTheme.displaySmall)
                                    ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (!ultraCompact) ...[
                            SizedBox(height: compact ? 10 : 14),
                            Text(
                              option.description,
                              maxLines: compact ? 2 : 3,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (compact
                                          ? theme.textTheme.bodyMedium
                                          : theme.textTheme.bodyLarge)
                                      ?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.86,
                                        ),
                                        height: 1.35,
                                      ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreviewStatus extends StatelessWidget {
  const _PreviewStatus({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text('UI PREVIEW'),
        ],
      ),
    );
  }
}

class _PreviewGlow extends StatelessWidget {
  const _PreviewGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxHeight < 104 || constraints.maxWidth < 360;
        final buttonSize = compact ? 62.0 : 70.0;

        return Row(
          children: [
            _CircleControl(
              icon: Icons.photo_library_outlined,
              size: buttonSize,
            ),
            const Spacer(),
            _CaptureButton(size: compact ? 84 : 94),
            const Spacer(),
            _CircleControl(
              key: const ValueKey('open-camera-menu-button'),
              icon: Icons.camera_alt_outlined,
              size: buttonSize,
              onTap: onOpenMenu,
            ),
          ],
        );
      },
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({
    super.key,
    required this.icon,
    required this.size,
    this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF181818),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.34),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: size - 10,
          height: size - 10,
          padding: EdgeInsets.all(size * 0.08),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.96),
              width: 4,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.92),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.12),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

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
    final option = _selectedOption;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewportConstraints) {
            final shortScreen = viewportConstraints.maxHeight < 760;
            final veryShortScreen = viewportConstraints.maxHeight < 680;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                veryShortScreen ? 16 : 20,
                veryShortScreen ? 12 : 18,
                veryShortScreen ? 16 : 20,
                veryShortScreen ? 14 : 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: veryShortScreen ? 6 : 7,
                    child: _PreviewCard(option: option),
                  ),
                  SizedBox(height: veryShortScreen ? 14 : 20),
                  Expanded(
                    flex: shortScreen ? 5 : 4,
                    child: _OperationAreaCard(
                      option: option,
                      onOpenCameraMenu: _openCameraMenu,
                    ),
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

class _OperationAreaCard extends StatelessWidget {
  const _OperationAreaCard({
    required this.option,
    required this.onOpenCameraMenu,
  });

  final CameraOption option;
  final VoidCallback onOpenCameraMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 280;
          final ultraCompact = constraints.maxHeight < 250;
          final horizontalPadding = ultraCompact
              ? 12.0
              : compact
              ? 14.0
              : 18.0;
          final topPadding = ultraCompact
              ? 12.0
              : compact
              ? 14.0
              : 18.0;
          final bottomPadding = ultraCompact
              ? 12.0
              : compact
              ? 14.0
              : 20.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              topPadding,
              horizontalPadding,
              bottomPadding,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - topPadding - bottomPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: compact
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (!compact) ...[
                      Text(
                        'Camera Prototype',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Preview reacts to the selected camera option. Library and capture are UI only.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: _OperationButton(
                            icon: Icons.photo_library_outlined,
                            label: 'Library',
                            compact: compact,
                            showLabel: !ultraCompact,
                            onTap: null,
                          ),
                        ),
                        SizedBox(
                          width: ultraCompact
                              ? 10
                              : compact
                              ? 12
                              : 16,
                        ),
                        _CaptureButton(
                          size: ultraCompact
                              ? 62
                              : compact
                              ? 76
                              : 96,
                        ),
                        SizedBox(
                          width: ultraCompact
                              ? 10
                              : compact
                              ? 12
                              : 16,
                        ),
                        Expanded(
                          child: _OperationButton(
                            key: const ValueKey('open-camera-menu-button'),
                            icon: Icons.tune_rounded,
                            label: ultraCompact ? 'Menu' : 'Camera Menu',
                            compact: compact,
                            showLabel: !ultraCompact,
                            highlightColor: option.accentColor,
                            onTap: onOpenCameraMenu,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ultraCompact
                          ? 8
                          : compact
                          ? 12
                          : 14,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: ultraCompact
                            ? 10
                            : compact
                            ? 12
                            : 14,
                        vertical: ultraCompact
                            ? 8
                            : compact
                            ? 10
                            : 12,
                      ),
                      decoration: BoxDecoration(
                        color: option.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: option.accentColor.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: option.accentColor,
                            size: ultraCompact
                                ? 18
                                : compact
                                ? 20
                                : 24,
                          ),
                          SizedBox(width: ultraCompact ? 8 : 10),
                          Expanded(
                            child: Text(
                              ultraCompact
                                  ? 'Selected: ${option.name}'
                                  : 'Current option: ${option.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: ultraCompact ? 13 : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
          color: option.accentColor.withValues(alpha: 0.4),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: option.accentColor.withValues(alpha: 0.15),
            blurRadius: 26,
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
                constraints.maxHeight < 320 || constraints.maxWidth < 320;
            final showPreviewTag = !ultraCompact && constraints.maxWidth >= 340;

            return Stack(
              children: [
                Positioned(
                  top: -36,
                  right: -12,
                  child: _PreviewGlow(
                    color: option.accentColor.withValues(alpha: 0.26),
                    size: compact ? 120 : 170,
                  ),
                ),
                Positioned(
                  bottom: -44,
                  left: -24,
                  child: _PreviewGlow(
                    color: Colors.white.withValues(alpha: 0.08),
                    size: compact ? 140 : 190,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    ultraCompact
                        ? 16
                        : compact
                        ? 18
                        : 24,
                    ultraCompact
                        ? 16
                        : compact
                        ? 18
                        : 24,
                    ultraCompact
                        ? 16
                        : compact
                        ? 18
                        : 24,
                    ultraCompact
                        ? 16
                        : compact
                        ? 18
                        : 26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: compact ? 10 : 12,
                                  vertical: compact ? 6 : 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  option.previewLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    letterSpacing: compact ? 0.8 : 1.2,
                                    fontWeight: FontWeight.w700,
                                    fontSize: compact ? 11 : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (showPreviewTag) ...[
                            const SizedBox(width: 8),
                            Text(
                              'UI PREVIEW',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white70,
                                letterSpacing: compact ? 1.2 : 1.6,
                                fontSize: compact ? 11 : null,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Current camera option',
                        style:
                            (compact
                                    ? theme.textTheme.bodyMedium
                                    : theme.textTheme.titleMedium)
                                ?.copyWith(color: Colors.white70),
                      ),
                      SizedBox(height: compact ? 6 : 8),
                      Text(
                        option.name,
                        key: const ValueKey('selected-camera-option-name'),
                        style:
                            (ultraCompact
                                    ? theme.textTheme.headlineMedium
                                    : compact
                                    ? theme.textTheme.headlineLarge
                                    : theme.textTheme.displaySmall)
                                ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (!ultraCompact) ...[
                        SizedBox(height: compact ? 8 : 12),
                        Text(
                          option.description,
                          maxLines: compact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              (compact
                                      ? theme.textTheme.bodyMedium
                                      : theme.textTheme.bodyLarge)
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.86),
                                    height: 1.35,
                                  ),
                        ),
                      ],
                      if (!compact) ...[
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _PreviewMetric(
                                label: 'Tone',
                                value: option.name,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PreviewMetric(
                                label: 'Mode',
                                value: option.previewLabel,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
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

class _OperationButton extends StatelessWidget {
  const _OperationButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.compact,
    required this.showLabel,
    this.highlightColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool compact;
  final bool showLabel;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final isInteractive = onTap != null;
    final iconColor = highlightColor ?? Colors.white;

    return Opacity(
      opacity: isInteractive ? 1 : 0.78,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 14,
              vertical: compact ? 12 : 18,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isInteractive
                    ? iconColor.withValues(alpha: 0.24)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: compact ? 20 : 24),
                if (showLabel) ...[
                  SizedBox(height: compact ? 6 : 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: compact ? 12 : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
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
          width: size - 14,
          height: size - 14,
          padding: EdgeInsets.all(size * 0.07),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.95),
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
                  blurRadius: 18,
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

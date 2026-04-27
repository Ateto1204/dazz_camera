import 'package:flutter/material.dart';

import 'camera_detail_page.dart';
import 'camera_option.dart';

class CameraMenuPage extends StatefulWidget {
  const CameraMenuPage({super.key, required this.initialOption});

  final CameraOption initialOption;

  @override
  State<CameraMenuPage> createState() => _CameraMenuPageState();
}

class _CameraMenuPageState extends State<CameraMenuPage> {
  late CameraOption _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialOption;
  }

  void _handleOptionTap(CameraOption option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _applySelection() {
    Navigator.of(context).pop(_selectedOption);
  }

  Future<void> _openDetailPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CameraDetailPage(option: _selectedOption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canApply = _selectedOption.id == originalCameraOption.id;
    final canViewDetail = _selectedOption.id != originalCameraOption.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OptionScrollerRow(
                key: const ValueKey('recording-options-row'),
                options: recordingCameraOptions,
                selectedOption: _selectedOption,
                onTap: _handleOptionTap,
              ),
              const SizedBox(height: 18),
              _OptionScrollerRow(
                key: const ValueKey('capture-options-row'),
                options: captureCameraOptions,
                selectedOption: _selectedOption,
                onTap: _handleOptionTap,
              ),
              const Spacer(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 112,
                      child: OutlinedButton(
                        key: const ValueKey('detail-camera-option-button'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: canViewDetail ? _openDetailPage : null,
                        child: const Text(
                          'Detail',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 112,
                      child: FilledButton(
                        key: const ValueKey('apply-camera-option-button'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: canApply ? _applySelection : null,
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
  }
}

class _OptionScrollerRow extends StatelessWidget {
  const _OptionScrollerRow({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onTap,
  });

  final List<CameraOption> options;
  final CameraOption selectedOption;
  final ValueChanged<CameraOption> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < options.length; i++) ...[
                      SizedBox(
                        width: 82,
                        height: 120,
                        child: _CameraOptionTile(
                          key: ValueKey(
                            'camera-option-item-${options[i].id}-$i',
                          ),
                          option: options[i],
                          isSelected: options[i].id == selectedOption.id,
                          onTap: () => onTap(options[i]),
                        ),
                      ),
                      if (i != options.length - 1) const SizedBox(width: 12),
                    ],
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

class _CameraOptionTile extends StatelessWidget {
  const _CameraOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final CameraOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: isSelected ? 1 : 0.58,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.08),
                        width: isSelected ? 2.2 : 1,
                      ),
                    ),
                    child: ClipOval(
                      child: option.iconData != null
                          ? Center(
                              child: Icon(
                                option.iconData,
                                size: 26,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  option.thumbnailAssetPath!,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

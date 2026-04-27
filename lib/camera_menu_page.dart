import 'package:flutter/material.dart';

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
    if (!option.isImplemented) {
      return;
    }

    setState(() {
      _selectedOption = option;
    });
  }

  void _applySelection() {
    Navigator.of(context).pop(_selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
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
              FilledButton(
                key: const ValueKey('apply-camera-option-button'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _applySelection,
                child: const Text(
                  'Apply',
                  style: TextStyle(fontWeight: FontWeight.w700),
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
      height: 138,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final option = options[index];

          return SizedBox(
            width: 104,
            child: _CameraOptionTile(
              key: ValueKey('camera-option-item-${option.id}'),
              option: option,
              isSelected: option.id == selectedOption.id,
              onTap: () => onTap(option),
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
      opacity: option.isImplemented ? 1 : 0.58,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: option.isImplemented ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.08),
                      width: isSelected ? 2.2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: option.colors,
                            ),
                          ),
                          child: Image.asset(
                            option.thumbnailAssetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (!option.isImplemented)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.32),
                            ),
                          ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  option.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: option.isImplemented ? Colors.white : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

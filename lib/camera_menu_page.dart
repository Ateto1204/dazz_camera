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

  void _confirmSelection() {
    Navigator.of(context).pop(_selectedOption);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Camera Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a camera option',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select one option and confirm to update the home preview.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: cameraOptions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = cameraOptions[index];
                  final isSelected = option.id == _selectedOption.id;

                  return _CameraOptionCard(
                    key: ValueKey('camera-option-item-${option.id}'),
                    option: option,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedOption = option;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const ValueKey('confirm-camera-option-button'),
                style: FilledButton.styleFrom(
                  backgroundColor: _selectedOption.accentColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: _confirmSelection,
                child: Text('Confirm ${_selectedOption.title}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraOptionCard extends StatelessWidget {
  const _CameraOptionCard({
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                option.previewColors.first.withValues(alpha: 0.92),
                option.previewColors[1],
                option.previewColors.last,
              ],
            ),
            border: Border.all(
              color: isSelected
                  ? option.accentColor
                  : Colors.white.withValues(alpha: 0.08),
              width: isSelected ? 2.2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: option.accentColor.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      option.previewColors.first,
                      option.previewColors[1],
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    option.title.substring(0, 1),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.previewLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.26),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

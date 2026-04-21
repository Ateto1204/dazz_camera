import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dazz Filter Picker',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF1A55A),
          brightness: Brightness.dark,
        ),
      ),
      home: const FilterSelectionScreen(),
    );
  }
}

class FilterSelectionScreen extends StatefulWidget {
  const FilterSelectionScreen({super.key});

  @override
  State<FilterSelectionScreen> createState() => _FilterSelectionScreenState();
}

class _FilterSelectionScreenState extends State<FilterSelectionScreen> {
  int _selectedIndex = 0;

  CameraFilter get _selectedFilter => filters[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dazz Camera',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Stage 1 · Filter Picker Prototype',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: FilterPreviewCard(filter: _selectedFilter)),
                  const SizedBox(height: 24),
                  Text(
                    'Filters',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 144,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = index == _selectedIndex;

                        return FilterOptionTile(
                          key: ValueKey('filter-item-${filter.id}'),
                          filter: filter,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        );
                      },
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

class FilterPreviewCard extends StatelessWidget {
  const FilterPreviewCard({super.key, required this.filter});

  final CameraFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deepColor = Color.lerp(filter.previewColor, Colors.black, 0.55)!;
    final glowColor = Color.lerp(filter.previewColor, Colors.white, 0.2)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [glowColor, deepColor, const Color(0xFF050505)],
        ),
        border: Border.all(
          color: filter.previewColor.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: filter.previewColor.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -20,
              child: _GlowOrb(
                color: filter.previewColor.withValues(alpha: 0.3),
                size: 150,
              ),
            ),
            Positioned(
              bottom: -60,
              left: -30,
              child: _GlowOrb(
                color: Colors.white.withValues(alpha: 0.08),
                size: 190,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREVIEW',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Current filter',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filter.name,
                    key: const ValueKey('selected-filter-name'),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Text('Stage 1 placeholder · no camera feed'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOptionTile extends StatelessWidget {
  const FilterOptionTile({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final CameraFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isSelected ? Colors.white : Colors.white70;

    return SizedBox(
      width: 94,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(filter.previewColor, Colors.white, 0.18)!,
                          Color.lerp(filter.previewColor, Colors.black, 0.38)!,
                        ],
                      ),
                      border: Border.all(
                        color: isSelected
                            ? filter.previewColor
                            : Colors.white.withValues(alpha: 0.12),
                        width: isSelected ? 2.4 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: filter.previewColor.withValues(
                                  alpha: 0.22,
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  filter.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

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

class CameraFilter {
  const CameraFilter({
    required this.id,
    required this.name,
    required this.previewColor,
  });

  final String id;
  final String name;
  final Color previewColor;
}

const filters = <CameraFilter>[
  CameraFilter(
    id: 'original',
    name: 'Original',
    previewColor: Color(0xFFE0E5EA),
  ),
  CameraFilter(id: 'dazz', name: 'Dazz', previewColor: Color(0xFFF0A35A)),
  CameraFilter(id: 'vintage', name: 'Vintage', previewColor: Color(0xFFBD9066)),
  CameraFilter(id: 'warm', name: 'Warm', previewColor: Color(0xFFE77B57)),
  CameraFilter(id: 'cool', name: 'Cool', previewColor: Color(0xFF5F9FE8)),
  CameraFilter(id: 'mono', name: 'Mono', previewColor: Color(0xFF9E9E9E)),
  CameraFilter(id: 'dreamy', name: 'Dreamy', previewColor: Color(0xFFC691D8)),
  CameraFilter(id: 'film', name: 'Film', previewColor: Color(0xFF74A87A)),
];

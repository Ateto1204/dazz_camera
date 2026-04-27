import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_menu_page.dart';
import 'camera_option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  CameraOption _selectedOption = cameraOptions.first;
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _cameraController = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(_cameraDescription);
    }
  }

  Future<void> _initializeCamera([CameraDescription? preferredCamera]) async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw CameraException(
          'NoCameraAvailable',
          'No camera is available on this device.',
        );
      }

      final camera = preferredCamera ?? _pickDefaultCamera(cameras);
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      final previousController = _cameraController;

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraDescription = camera;
        _isInitializing = false;
      });

      await previousController?.dispose();
    } on CameraException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _cameraController = null;
        _isInitializing = false;
        _errorMessage = _cameraErrorMessage(error);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _cameraController = null;
        _isInitializing = false;
        _errorMessage = 'Failed to initialize the camera preview.';
      });
    }
  }

  CameraDescription _pickDefaultCamera(List<CameraDescription> cameras) {
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        return camera;
      }
    }

    return cameras.first;
  }

  String _cameraErrorMessage(CameraException error) {
    switch (error.code) {
      case 'CameraAccessDenied':
        return 'Camera access was denied.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera access was denied. Please enable it in Settings.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      default:
        return error.description ?? 'Failed to initialize the camera preview.';
    }
  }

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

            return Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 14 : 20,
                compact ? 12 : 18,
                compact ? 14 : 20,
                compact ? 14 : 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _CameraPreviewCard(
                      option: _selectedOption,
                      controller: _cameraController,
                      isInitializing: _isInitializing,
                      errorMessage: _errorMessage,
                    ),
                  ),
                  SizedBox(height: compact ? 10 : 14),
                  _ParameterControlsBar(compact: compact),
                  SizedBox(height: compact ? 12 : 16),
                  SizedBox(
                    height: compact ? 92 : 108,
                    child: _BottomControls(
                      compact: compact,
                      onOpenMenu: _openCameraMenu,
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

class _CameraPreviewCard extends StatelessWidget {
  const _CameraPreviewCard({
    required this.option,
    required this.controller,
    required this.isInitializing,
    required this.errorMessage,
  });

  final CameraOption option;
  final CameraController? controller;
  final bool isInitializing;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (controller != null && controller!.value.isInitialized)
              LayoutBuilder(
                builder: (context, constraints) {
                  final rawAspectRatio = controller!.value.aspectRatio;
                  final portraitAspectRatio = rawAspectRatio > 1
                      ? 1 / rawAspectRatio
                      : rawAspectRatio;
                  final previewHeight = constraints.maxHeight;
                  final previewWidth = previewHeight * portraitAspectRatio;

                  return ColoredBox(
                    color: Colors.black,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: previewWidth,
                        height: previewHeight,
                        child: CameraPreview(controller!),
                      ),
                    ),
                  );
                },
              )
            else if (isInitializing)
              const _PreviewMessage(
                icon: Icons.camera_alt_outlined,
                title: 'Initializing camera...',
              )
            else
              _PreviewMessage(
                icon: Icons.error_outline_rounded,
                title: errorMessage ?? 'Camera preview unavailable.',
              ),
            Positioned(
              top: 16,
              left: 16,
              child: _PreviewTitleBadge(title: option.title),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParameterControlsBar extends StatelessWidget {
  const _ParameterControlsBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 38 : 42,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          children: [
            _PreviewValueChip(
              icon: Icons.thermostat_rounded,
              label: compact ? 'WB' : 'WB 5200K',
            ),
            const SizedBox(width: 8),
            _PreviewValueChip(label: compact ? 'ISO' : 'ISO 100'),
            const SizedBox(width: 8),
            _PreviewValueChip(label: compact ? 'EV' : 'EV 0.0'),
            const SizedBox(width: 8),
            _PreviewIconChip(icon: Icons.timer_outlined, compact: compact),
            const SizedBox(width: 8),
            _PreviewIconChip(icon: Icons.flash_off_rounded, compact: compact),
            const SizedBox(width: 8),
            _PreviewIconChip(
              icon: Icons.flip_camera_ios_outlined,
              compact: compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewTitleBadge extends StatelessWidget {
  const _PreviewTitleBadge({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _PreviewIconChip extends StatelessWidget {
  const _PreviewIconChip({required this.icon, required this.compact});

  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 34 : 38,
      height: compact ? 34 : 38,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Icon(icon, color: Colors.white, size: compact ? 17 : 19),
    );
  }
}

class _PreviewValueChip extends StatelessWidget {
  const _PreviewValueChip({this.icon, required this.label});

  final IconData? icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: Colors.white70),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.compact, required this.onOpenMenu});

  final bool compact;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final sideButtonSize = compact ? 62.0 : 70.0;

    return Row(
      children: [
        _CircleControl(
          icon: Icons.photo_library_outlined,
          size: sideButtonSize,
        ),
        const Spacer(),
        _CaptureButton(size: compact ? 84 : 94),
        const Spacer(),
        _CircleControl(
          icon: Icons.camera_alt_outlined,
          size: sideButtonSize,
          onTap: onOpenMenu,
        ),
      ],
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({required this.icon, required this.size, this.onTap});

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

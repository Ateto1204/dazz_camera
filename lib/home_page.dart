import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
                      controller: _cameraController,
                      isInitializing: _isInitializing,
                      errorMessage: _errorMessage,
                    ),
                  ),
                  SizedBox(height: compact ? 14 : 18),
                  SizedBox(
                    height: compact ? 92 : 108,
                    child: _BottomControls(compact: compact),
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
    required this.controller,
    required this.isInitializing,
    required this.errorMessage,
  });

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
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: const Text(
                  'ORIGINAL',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
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
  const _BottomControls({required this.compact});

  final bool compact;

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
        _CircleControl(icon: Icons.camera_alt_outlined, size: sideButtonSize),
      ],
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF181818),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.34),
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

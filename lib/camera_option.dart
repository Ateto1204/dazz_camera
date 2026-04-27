import 'package:flutter/material.dart';

class CameraOption {
  const CameraOption({
    required this.id,
    required this.title,
    required this.previewLabel,
    required this.colors,
    required this.thumbnailAssetPath,
    this.isImplemented = false,
  });

  final String id;
  final String title;
  final String previewLabel;
  final List<Color> colors;
  final String thumbnailAssetPath;
  final bool isImplemented;
}

const recordingCameraOptions = <CameraOption>[
  CameraOption(
    id: 'original',
    title: 'Original',
    previewLabel: 'STANDARD LOOK',
    colors: [Color(0xFFE5E8EC), Color(0xFF6A7480), Color(0xFF111418)],
    thumbnailAssetPath: 'assets/images/recording/Canon VIXIA.png',
    isImplemented: true,
  ),
  CameraOption(
    id: 'sony-handycam',
    title: 'Sony Handycam',
    previewLabel: 'CAMCORDER',
    colors: [Color(0xFFF5C48B), Color(0xFF8E5932), Color(0xFF150F0C)],
    thumbnailAssetPath: 'assets/images/recording/Sony Handycam.png',
  ),
  CameraOption(
    id: 'panasonic-viera',
    title: 'Panasonic VIERA',
    previewLabel: 'DIGITAL VIDEO',
    colors: [Color(0xFFD8BA9C), Color(0xFF6B5140), Color(0xFF120E0B)],
    thumbnailAssetPath: 'assets/images/recording/Panasonic VIERA.png',
  ),
  CameraOption(
    id: 'hitachi',
    title: 'Hitachi',
    previewLabel: 'TAPE LOOK',
    colors: [Color(0xFFE4E4E4), Color(0xFF666666), Color(0xFF080808)],
    thumbnailAssetPath: 'assets/images/recording/Hitachi.png',
  ),
];

const captureCameraOptions = <CameraOption>[
  CameraOption(
    id: 'canon-dslr',
    title: 'Canon DSLR',
    previewLabel: 'PHOTO',
    colors: [Color(0xFFF2B17D), Color(0xFF9F4D39), Color(0xFF160C0A)],
    thumbnailAssetPath: 'assets/images/capture/Canon DSLR.png',
  ),
  CameraOption(
    id: 'contax-t2',
    title: 'Contax T2',
    previewLabel: 'FILM',
    colors: [Color(0xFFA8D0FF), Color(0xFF365D8C), Color(0xFF081018)],
    thumbnailAssetPath: 'assets/images/capture/Contax T2.png',
  ),
  CameraOption(
    id: 'fujifilm-instax-mini',
    title: 'Instax Mini',
    previewLabel: 'INSTANT',
    colors: [Color(0xFFE2C8F3), Color(0xFF785B90), Color(0xFF110B15)],
    thumbnailAssetPath: 'assets/images/capture/Fujifilm Instax Mini.png',
  ),
  CameraOption(
    id: 'olympus-pen',
    title: 'Olympus PEN',
    previewLabel: 'HALF FRAME',
    colors: [Color(0xFFA3C58A), Color(0xFF4F6843), Color(0xFF0D110B)],
    thumbnailAssetPath: 'assets/images/capture/Olympus PEN.png',
  ),
  CameraOption(
    id: 'ricoh-gr',
    title: 'Ricoh GR',
    previewLabel: 'COMPACT',
    colors: [Color(0xFFBCC6D1), Color(0xFF4E5966), Color(0xFF0D1014)],
    thumbnailAssetPath: 'assets/images/capture/Ricoh GR.png',
  ),
];

const cameraOptions = <CameraOption>[
  ...recordingCameraOptions,
  ...captureCameraOptions,
];

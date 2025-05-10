import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';

import '../controllers/user_controller.dart';
import '../data/models/analysis_record.dart';
import '../routes/app_routes.dart';
import '../services/ia_service.dart';
import '../widgets/scan_widgets/face_camera_view.dart';
import '../widgets/shared_widgets/custom_background.dart';
import '../widgets/shared_widgets/custom_button.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  int _countdown = 0;
  final IaService _iaService = IaService();
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCam,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo inicializar la cámara: $e');
    }
  }

  @override
  void dispose() {
    _iaService.dispose();
    _cameraController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  Future<void> _analyzeFace() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _countdown = 5;
    });
    _ringController.forward(from: 0);

    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown--);
    }

    try {
      final picture = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(picture.path);
      final resultado = await _iaService.analizarFatiga(inputImage);

      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final userId = Get.find<UserController>().userId.value;
      final record = AnalysisRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        status: resultado['estado']?.toString() ?? 'No Detectado',
        date: now,
        observations: resultado['observaciones']?.toString() ?? 'No se detectó rostro.',
        eyeProbability: (resultado['probabilidad_ojos'] as num?)?.toDouble() ?? 1.0,
        yawnDetected: (resultado['bostezo_detectado'] as bool?) ?? false,
        headTilt: (resultado['inclinacion_cabeza'] as num?)?.toDouble() ?? 0.0,
        fatigueScore: (resultado['score_fatiga'] as num?)?.toDouble() ?? 0.0,
      );

      if (resultado['fatigado'] == true) {
        Get.toNamed(AppRoutes.alert, arguments: record);
      } else {
        Get.toNamed(AppRoutes.report, arguments: record.toMap());
      }
    } catch (e) {
      Get.snackbar('Error', 'Fallo al analizar la imagen: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _countdown = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo Facial'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: _isCameraInitialized
              ? Column(
                  children: [
                    Expanded(
                      child: FaceCameraView(
                        cameraController: _cameraController,
                        isProcessing: _isProcessing,
                        ringController: _ringController,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_isProcessing && _countdown > 0)
                      Text(
                        'Escaneando en: $_countdown s',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Analizar con IA',
                      icon: Icons.analytics,
                      isLoading: _isProcessing,
                      backgroundColor: Colors.deepPurpleAccent,
                      onPressed: _analyzeFace,
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
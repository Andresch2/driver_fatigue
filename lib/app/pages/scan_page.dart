import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';

import '../controllers/user_controller.dart';
import '../routes/app_routes.dart';
import '../services/ia_service.dart';
import '../widgets/custom_background.dart';
import '../widgets/custom_button.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  int _countdown = 0;
  final IaService _iaService = IaService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium,
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
    super.dispose();
  }

  Future<void> _analyzeFace() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _countdown = 5;
    });

    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown--);
    }

    try {
      final imageFile = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final resultado = await _iaService.analizarFatiga(inputImage);

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
      final userId  = Get.find<UserController>().userId.value;

      final data = {
        'user_id':        userId,
        'status':         resultado['estado']?.toString() ?? 'No Detectado',
        'date':           dateStr,
        'observations':   resultado['observaciones']?.toString() ?? 'No se detectó rostro.',
        'eye_probability': (resultado['probabilidad_ojos'] as num?)?.toDouble() ?? 1.0,
        'yawn_detected':   (resultado['bostezo_detectado'] as bool?) ?? false,
        'head_tilt':       (resultado['inclinacion_cabeza'] as num?)?.toDouble() ?? 0.0,
        'fatigue_score':   (resultado['score_fatiga'] as num?)?.toDouble() ?? 0.0,
      };

      if (resultado['fatigado'] == true) {
        await _mostrarAlertaFatiga(data);
      } else {
        Get.toNamed(AppRoutes.report, arguments: data);
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

  Future<void> _mostrarAlertaFatiga(Map<String, dynamic> data) async {
    final tts = FlutterTts();
    await tts.setLanguage("es-ES");
    await tts.setPitch(1.0);
    await tts.setSpeechRate(0.5);
    await tts.speak("¡Atención! Se detectaron signos de fatiga. Por favor tome un descanso.");
    Get.toNamed(AppRoutes.alert, arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo Facial')),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isCameraInitialized
              ? Column(
                  children: [
                    AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CameraPreview(_cameraController),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isProcessing && _countdown > 0)
                      Text('Escaneando en: $_countdown s', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Analizar con IA',
                      icon: Icons.face_retouching_natural,
                      isLoading: _isProcessing,
                      backgroundColor: Theme.of(context).primaryColor,
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

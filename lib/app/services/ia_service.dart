import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class IaService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
      enableTracking: true,
    ),
  );


  Future<Map<String, dynamic>> analizarFatiga(InputImage image) async {
    try {
      final List<Face> faces = await _faceDetector.processImage(image);

      if (faces.isEmpty) {
        return {
          'estado': 'No Detectado',
          'observaciones': 'No se detectó ningún rostro.',
          'probabilidad_ojos': 0.0,
          'bostezo_detectado': false,
          'inclinacion_cabeza': 0.0,
          'score_fatiga': 0.0,
          'fatigado': false,
        };
      }

      Face face = faces.first;

      final leftEyeProb = face.leftEyeOpenProbability ?? 1.0;
      final rightEyeProb = face.rightEyeOpenProbability ?? 1.0;
      final promedioOjos = (leftEyeProb + rightEyeProb) / 2;
      
      final faceContours = face.contours;
      double bostezoProbabilidad = 0.0;
      
      if (faceContours[FaceContourType.lowerLipBottom] != null &&
          faceContours[FaceContourType.upperLipTop] != null) {
        
        final lowerLip = faceContours[FaceContourType.lowerLipBottom]!.points;
        final upperLip = faceContours[FaceContourType.upperLipTop]!.points;
        
        if (lowerLip.isNotEmpty && upperLip.isNotEmpty) {

          final lowerY = lowerLip[lowerLip.length ~/ 2].y;
          final upperY = upperLip[upperLip.length ~/ 2].y;
          final aperturaBoca = (lowerY - upperY).abs();
          
          final faceHeight = face.boundingBox.height;
          bostezoProbabilidad = aperturaBoca / (faceHeight * 0.3);
          bostezoProbabilidad = bostezoProbabilidad.clamp(0.0, 1.0);
        }
      }
      
      double inclinacionCabeza = 0.0;
      if (face.headEulerAngleY != null && face.headEulerAngleZ != null) {

        final angleY = face.headEulerAngleY!.abs() / 45.0;
        final angleZ = face.headEulerAngleZ!.abs() / 30.0;
        
        inclinacionCabeza = (angleY + angleZ) / 2;
        inclinacionCabeza = inclinacionCabeza.clamp(0.0, 1.0);
      }
      
      double scoreFatiga = 0.0;

      scoreFatiga = (1.0 - promedioOjos) * 0.5 +
                   bostezoProbabilidad * 0.3 +
                   inclinacionCabeza * 0.2;
      
      final fatigado = scoreFatiga > 0.4;
      
      String observaciones = fatigado ? 'Signos de fatiga detectados.' : 'No se detectaron signos significativos de fatiga.';
      
      if (promedioOjos < 0.5) {
        observaciones += ' Ojos parcialmente cerrados.';
      }
      
      if (bostezoProbabilidad > 0.6) {
        observaciones += ' Posible bostezo detectado.';
      }
      
      if (inclinacionCabeza > 0.5) {
        observaciones += ' Inclinación de cabeza notable.';
      }

      return {
        'estado': fatigado ? 'Fatigado' : 'Alerta',
        'observaciones': observaciones,
        'probabilidad_ojos': promedioOjos,
        'bostezo_detectado': bostezoProbabilidad > 0.6,
        'inclinacion_cabeza': inclinacionCabeza,
        'score_fatiga': scoreFatiga,
        'fatigado': fatigado,
      };
    } catch (e) {
      if (kDebugMode) {
        print("Error en el análisis facial: $e");
      }
      
      return {
        'estado': 'Error',
        'observaciones': 'Fallo al analizar la imagen.',
        'probabilidad_ojos': 0.0,
        'bostezo_detectado': false,
        'inclinacion_cabeza': 0.0,
        'score_fatiga': 0.0,
        'fatigado': false,
      };
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}
import 'package:hive/hive.dart';

part 'analysis_record.g.dart';

@HiveType(typeId: 0)
class AnalysisRecord {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String status;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String observations;
  @HiveField(5)
  final double eyeProbability;
  @HiveField(6)
  final bool yawnDetected;
  @HiveField(7)
  final double headTilt;
  @HiveField(8)
  final double fatigueScore;

  AnalysisRecord({
    required this.id,
    required this.userId,
    required this.status,
    required this.date,
    required this.observations,
    required this.eyeProbability,
    required this.yawnDetected,
    required this.headTilt,
    required this.fatigueScore,
  });

  AnalysisRecord copyWith({
    String? id,
    String? userId,
    String? status,
    String? date,
    String? observations,
    double? eyeProbability,
    bool? yawnDetected,
    double? headTilt,
    double? fatigueScore,
  }) {
    return AnalysisRecord(
      id:               id             ?? this.id,
      userId:           userId         ?? this.userId,
      status:           status         ?? this.status,
      date:             date           ?? this.date,
      observations:     observations   ?? this.observations,
      eyeProbability:   eyeProbability ?? this.eyeProbability,
      yawnDetected:     yawnDetected   ?? this.yawnDetected,
      headTilt:         headTilt       ?? this.headTilt,
      fatigueScore:     fatigueScore   ?? this.fatigueScore,
    );
  }

  Map<String, dynamic> toCreateMap() => {
        'user_id':         userId,
        'status':          status,
        'date':            date,
        'observations':    observations,
        'eye_probability': eyeProbability,
        'yawn_detected':   yawnDetected,
        'head_tilt':       headTilt,
        'fatigue_score':   fatigueScore,
      };

  Map<String, dynamic> toMap() {
    final m = toCreateMap();
    m[r'$id'] = id;
    return m;
  }

  factory AnalysisRecord.fromMap(Map<String, dynamic> m) {
    return AnalysisRecord(
      id:               m[r'$id']?.toString()           ?? '',
      userId:           m['user_id']?.toString()        ?? '',
      status:           m['status']?.toString()         ?? '',
      date:             m['date']?.toString()           ?? '',
      observations:     m['observations']?.toString()   ?? '',
      eyeProbability:   (m['eye_probability'] as num?)?.toDouble() ?? 0.0,
      yawnDetected:     (m['yawn_detected']   as bool?)             ?? false,
      headTilt:         (m['head_tilt']       as num?)?.toDouble() ?? 0.0,
      fatigueScore:     (m['fatigue_score']   as num?)?.toDouble() ?? 0.0,
    );
  }
}

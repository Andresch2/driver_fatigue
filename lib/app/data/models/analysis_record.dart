class AnalysisRecord {
  final String id;
  final String userId;
  final String status;
  final String date;
  final String observations;
  final double eyeProbability;
  final bool yawnDetected;
  final double headTilt;
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

  Map<String, dynamic> toCreateMap() {
    return {
      'user_id':        userId,
      'status':         status,
      'date':           date,
      'observations':   observations,
      'eye_probability': eyeProbability,
      'yawn_detected':  yawnDetected,
      'head_tilt':      headTilt,
      'fatigue_score':  fatigueScore,
    };
  }

  Map<String, dynamic> toMap() {
    final m = toCreateMap();
    m[r'$id'] = id;
    return m;
  }

  factory AnalysisRecord.fromMap(Map<String, dynamic> m) {
    return AnalysisRecord(
      id:               m[r'$id']?.toString()     ?? '',
      userId:           m['user_id']?.toString()  ?? '',
      status:           m['status']?.toString()   ?? '',
      date:             m['date']?.toString()     ?? '',
      observations:     m['observations']?.toString() ?? '',
      eyeProbability:   (m['eye_probability'] as num?)?.toDouble() ?? 0.0,
      yawnDetected:     (m['yawn_detected'] as bool?) ?? false,
      headTilt:         (m['head_tilt']     as num?)?.toDouble() ?? 0.0,
      fatigueScore:     (m['fatigue_score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

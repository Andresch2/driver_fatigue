// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalysisRecordAdapter extends TypeAdapter<AnalysisRecord> {
  @override
  final int typeId = 0;

  @override
  AnalysisRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalysisRecord(
      id: fields[0] as String,
      userId: fields[1] as String,
      status: fields[2] as String,
      date: fields[3] as String,
      observations: fields[4] as String,
      eyeProbability: fields[5] as double,
      yawnDetected: fields[6] as bool,
      headTilt: fields[7] as double,
      fatigueScore: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AnalysisRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.observations)
      ..writeByte(5)
      ..write(obj.eyeProbability)
      ..writeByte(6)
      ..write(obj.yawnDetected)
      ..writeByte(7)
      ..write(obj.headTilt)
      ..writeByte(8)
      ..write(obj.fatigueScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

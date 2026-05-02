// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stopwatch_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LapEntryAdapter extends TypeAdapter<LapEntry> {
  @override
  final int typeId = 10;

  @override
  LapEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LapEntry(
      lapNumber: fields[0] as int,
      lapMilliseconds: fields[1] as int,
      totalMilliseconds: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LapEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lapNumber)
      ..writeByte(1)
      ..write(obj.lapMilliseconds)
      ..writeByte(2)
      ..write(obj.totalMilliseconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LapEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StopwatchEntryAdapter extends TypeAdapter<StopwatchEntry> {
  @override
  final int typeId = 11;

  @override
  StopwatchEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopwatchEntry(
      id: fields[0] as String,
      name: fields[1] as String,
      elapsedMilliseconds: fields[2] as int,
      isRunning: fields[3] as bool,
      isEnabled: fields[4] as bool,
      laps: (fields[5] as List?)?.cast<LapEntry>(),
      color: fields[6] as String,
      startedAt: fields[7] as DateTime?,
      accumulatedMs: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StopwatchEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.elapsedMilliseconds)
      ..writeByte(3)
      ..write(obj.isRunning)
      ..writeByte(4)
      ..write(obj.isEnabled)
      ..writeByte(5)
      ..write(obj.laps)
      ..writeByte(6)
      ..write(obj.color)
      ..writeByte(7)
      ..write(obj.startedAt)
      ..writeByte(8)
      ..write(obj.accumulatedMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopwatchEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

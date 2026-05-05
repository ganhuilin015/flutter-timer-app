// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerItemAdapter extends TypeAdapter<TimerItem> {
  @override
  final int typeId = 2;

  @override
  TimerItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerItem(
      id: fields[0] as String,
      name: fields[1] as String,
      totalSeconds: fields[2] as int,
      remainingSeconds: fields[3] as int?,
      status: fields[4] as TimerStatus,
      color: fields[5] as String,
      soundFile: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimerItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalSeconds)
      ..writeByte(3)
      ..write(obj.remainingSeconds)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.soundFile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimerStatusAdapter extends TypeAdapter<TimerStatus> {
  @override
  final int typeId = 1;

  @override
  TimerStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimerStatus.idle;
      case 1:
        return TimerStatus.running;
      case 2:
        return TimerStatus.paused;
      case 3:
        return TimerStatus.finished;
      default:
        return TimerStatus.idle;
    }
  }

  @override
  void write(BinaryWriter writer, TimerStatus obj) {
    switch (obj) {
      case TimerStatus.idle:
        writer.writeByte(0);
        break;
      case TimerStatus.running:
        writer.writeByte(1);
        break;
      case TimerStatus.paused:
        writer.writeByte(2);
        break;
      case TimerStatus.finished:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

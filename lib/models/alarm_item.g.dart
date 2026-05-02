// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmItemAdapter extends TypeAdapter<AlarmItem> {
  @override
  final int typeId = 3;

  @override
  AlarmItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmItem(
      id: fields[0] as String,
      name: fields[1] as String,
      hour: fields[2] as int,
      minute: fields[3] as int,
      repeatDays: (fields[4] as List?)?.cast<bool>(),
      isEnabled: fields[5] as bool,
      sound: fields[6] as String,
      color: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hour)
      ..writeByte(3)
      ..write(obj.minute)
      ..writeByte(4)
      ..write(obj.repeatDays)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.sound)
      ..writeByte(7)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

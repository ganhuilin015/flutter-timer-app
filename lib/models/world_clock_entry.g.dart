// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_clock_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorldClockAdapter extends TypeAdapter<WorldClock> {
  @override
  final int typeId = 0;

  @override
  WorldClock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorldClock(
      id: fields[0] as String,
      cityName: fields[1] as String,
      countryName: fields[2] as String,
      timeZoneName: fields[3] as String,
      isEnabled: fields[4] as bool,
      color: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorldClock obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cityName)
      ..writeByte(2)
      ..write(obj.countryName)
      ..writeByte(3)
      ..write(obj.timeZoneName)
      ..writeByte(4)
      ..write(obj.isEnabled)
      ..writeByte(5)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorldClockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

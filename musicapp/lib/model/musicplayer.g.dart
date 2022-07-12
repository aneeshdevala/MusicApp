// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musicplayer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicPlayerAdapter extends TypeAdapter<MusicPlayer> {
  @override
  final int typeId = 1;

  @override
  MusicPlayer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicPlayer(
      name: fields[1] as String,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MusicPlayer obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicPlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flash_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashModeAdapter extends TypeAdapter<FlashMode> {
  @override
  final int typeId = 2;

  @override
  FlashMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FlashMode.WITH_WEATHER;
      case 1:
        return FlashMode.ALWAYS;
      case 2:
        return FlashMode.NEVER_IN_USE;
      default:
        return FlashMode.WITH_WEATHER;
    }
  }

  @override
  void write(BinaryWriter writer, FlashMode obj) {
    switch (obj) {
      case FlashMode.WITH_WEATHER:
        writer.writeByte(0);
        break;
      case FlashMode.ALWAYS:
        writer.writeByte(1);
        break;
      case FlashMode.NEVER_IN_USE:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

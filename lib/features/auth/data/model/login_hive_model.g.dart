// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginHiveModelAdapter extends TypeAdapter<LoginHiveModel> {
  @override
  final int typeId = 1;

  @override
  LoginHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginHiveModel(
      email: fields[1] as String,
      password: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

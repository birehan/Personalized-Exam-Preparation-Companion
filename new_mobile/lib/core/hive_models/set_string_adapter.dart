import 'package:hive/hive.dart';

class SetStringAdapter extends TypeAdapter<Set<String>> {
  @override
  final int typeId = 0; // Unique identifier for the type

  @override
  Set<String> read(BinaryReader reader) {
    final length = reader.readByte();
    return Set<String>.from(List.generate(length, (_) => reader.readString()));
  }

  @override
  void write(BinaryWriter writer, Set<String> obj) {
    writer.writeByte(obj.length);
    for (final item in obj) {
      writer.writeString(item);
    }
  }
}

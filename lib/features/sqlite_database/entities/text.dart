import "dart:typed_data";

import "package:floor/floor.dart";

@entity
class TextEntity {
  @PrimaryKey(autoGenerate: true)
  final int textId;

  final String? title, data;

  final int? eventType;

  final bool? hasImage;

  final Uint8List? dataImage;

  const TextEntity(
      {required this.hasImage,
      required this.textId,
      required this.title,
      required this.data,
      required this.dataImage,
      required this.eventType});
}

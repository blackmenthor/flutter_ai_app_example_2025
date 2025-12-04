import 'dart:io';

enum PhotoType {
  frontFace,
  sideFace,
  fullBody,
}

class UserPhoto {
  final String id;
  final File file;
  final PhotoType type;
  final DateTime capturedAt;

  UserPhoto({
    required this.id,
    required this.file,
    required this.type,
    required this.capturedAt,
  });
}

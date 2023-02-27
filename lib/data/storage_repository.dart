import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadProfilePicture(
    String userId,
    File imageFile,
  );
  Future<File> compressImage(String photoId, File image);
  Future<String> uploadLoop(String userId, File audioFile);
  Future<String> uploadBadgeImage(String receiverId, File imageFile);
}

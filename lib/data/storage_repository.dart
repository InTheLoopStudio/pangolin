import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadProfilePicture(
    String userId,
    File imageFile,
  );
  Future<File> compressImage(String photoId, File image);
  Future<String> uploadAudioAttachment(File audioFile);
  Future<String> uploadImageAttachment(File imageFile);
  Future<String> uploadBadgeImage(String receiverId, File imageFile);
}

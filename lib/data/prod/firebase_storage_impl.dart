import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final storageRef = FirebaseStorage.instance.ref();

class FirebaseStorageImpl extends StorageRepository {
  @override
  Future<String> uploadProfilePicture(
    String userId,
    File imageFile,
  ) async {
    final prefix = userId.isEmpty ? 'images/users' : 'images/users/$userId';

    final uniquePhotoId = const Uuid().v4();
    final image = await compressImage(uniquePhotoId, imageFile);

    final uploadTask = storageRef
        .child('$prefix/userProfile_$uniquePhotoId.jpg')
        .putFile(image);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Future<File> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );

    if (compressedImage == null) return image;

    return File(compressedImage.path);
  }

  @override
  Future<String> uploadAudioAttachment(File audioFile) async {
    final extension = p.extension(audioFile.path);
    const prefix = 'audio/loops';

    final uniqueAudioId = const Uuid().v4();

    final uploadTask =
        storageRef.child('$prefix/loop_$uniqueAudioId.$extension').putFile(audioFile);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Future<String> uploadImageAttachment(File imageFile) async {
    final extension = p.extension(imageFile.path);
    const prefix = 'images/loops';
    final uniqueImageId = const Uuid().v4();

    final uploadTask = storageRef
        .child('$prefix/loop_$uniqueImageId.$extension')
        .putFile(imageFile);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Future<String> uploadBadgeImage(String receiverId, File imageFile) async {
    final prefix =
        receiverId.isEmpty ? 'images/badges' : 'images/badges/$receiverId';

    final uniqueImageId = const Uuid().v4();

    final compressedImage = await compressImage(uniqueImageId, imageFile);
    final uploadTask = storageRef
        .child('$prefix/badge_$uniqueImageId.jpg')
        .putFile(compressedImage);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}

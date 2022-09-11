import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final storageRef = FirebaseStorage.instance.ref();

class FirebaseStorageImpl extends StorageRepository {
  Future<String> uploadProfilePicture(
      String userId, String url, File imageFile) async {
    final String prefix =
        userId.isEmpty ? 'images/users' : 'images/users/$userId';

    String uniquePhotoId = Uuid().v4();
    File image = await compressImage(uniquePhotoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      final oldUniquePhotoId = exp.firstMatch(url);

      if (oldUniquePhotoId != null) {
        uniquePhotoId = oldUniquePhotoId[1]!;
      }
    }
    UploadTask uploadTask = storageRef
        .child('$prefix/userProfile_$uniquePhotoId.jpg')
        .putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<File> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImage!;
  }

  Future<String> uploadLoop(String userId, File audioFile) async {
    final String prefix =
        userId.isEmpty ? 'audio/loops' : 'audio/loops/$userId';

    String uniqueAudioId = Uuid().v4();

    UploadTask uploadTask =
        storageRef.child('$prefix/loop_$uniqueAudioId.mp3').putFile(audioFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> uploadBadgeImage(String badgeId, File imageFile) async {
    final String prefix = 'images/badges';

    String uniqueImageId = Uuid().v4();

    File compressedImage = await compressImage(uniqueImageId, imageFile);
    UploadTask uploadTask =
        storageRef.child('$prefix/badge_$uniqueImageId.jpg').putFile(compressedImage);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}

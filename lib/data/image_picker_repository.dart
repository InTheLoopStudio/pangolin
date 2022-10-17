import 'dart:io';

// ignore: one_member_abstracts
abstract class ImagePickerRepository {
  Future<File?> pickImage();
}

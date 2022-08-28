import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../repository/image_repository.dart';

class ImageController {
  static Future<void> uploadImage(XFile image) async {
    File file = File(image.path);
    
    // Image upload only if it exists
    if (file.existsSync()) {
      final response = await ImageRepository.uploadImage(file);

      // Response from server
      if (!response['success']) {
        throw 'Error';
      }

      return;
    }

    throw 'Error';
  }
}

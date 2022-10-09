import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../constants/routes/web_routes.dart';
import '../services/http_service.dart';

class ImageRepository {
  static Future<Map<String, dynamic>> uploadImage(File file) async {
    const headers = {
      'enctype': 'multipart/form-data',
    };

    //Use Multipart Form to upload a file
    final body = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: basename(file.path),
      ),
    });

    return await HTTPService.post(
      route: WebRoutes.UPLOAD_IMAGE,
      body: body,
      headers: headers,
    );
  }
}

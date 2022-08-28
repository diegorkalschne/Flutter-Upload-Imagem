// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HTTPService {
  static final _BASE_URL = dotenv.env['BASE_URL'];

  /// POST request
  static Future<Map<String, dynamic>> post({
    required String route,
    dynamic body,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    Response response = await Dio().post(
      '$_BASE_URL$route',
      data: body,
      queryParameters: params,
      options: Options(
        headers: headers,
        followRedirects: false,
        contentType: 'application/json',
      ),
    );

    return response.data;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:to_do_app/view_model/data/local/shared_keys.dart';
import 'package:to_do_app/view_model/data/network/end_point.dart';

class DioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    bool? withToken = false,
  }) async {
    try {
      if (withToken ?? false) {
        String? token = await storage.read(key: SharedKeys.token);
        _dio.options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      return await _dio.get(
        endPoint,
        queryParameters: params,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post({
    required String endPoint,
    Map<String, dynamic>? params,
    Object? body,
    bool? withToken = false,
  }) async {
    try {
      if (withToken ?? false) {
        String? token = await storage.read(key: SharedKeys.token);
        _dio.options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      return await _dio.post(
        endPoint,
        queryParameters: params,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> put({
    required String endPoint,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    bool? withToken = false,
  }) async {
    try {
      if (withToken ?? false) {
        String? token = await storage.read(key: SharedKeys.token);
        _dio.options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      return await _dio.put(
        endPoint,
        queryParameters: params,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> patch({
    required String endPoint,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    bool? withToken = false,
  }) async {
    try {
      if (withToken ?? false) {
        String? token = await storage.read(key: SharedKeys.token);
        _dio.options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      return await _dio.patch(
        endPoint,
        queryParameters: params,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> delete({
    required String endPoint,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    bool? withToken = false,
  }) async {
    try {
      if (withToken ?? false) {
        String? token = await storage.read(key: SharedKeys.token);
        _dio.options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }
      return await _dio.delete(
        endPoint,
        queryParameters: params,
        data: body,
      );
    } catch (e) {
      rethrow;
    }
  }
}

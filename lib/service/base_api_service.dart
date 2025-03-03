import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';

import '../../models/response_model.dart';
import '../models/json_property_name.dart';

class BaseAPIService{
  static String qrsUrl = GlobalConfiguration().getValue(kQrsEndpoint);
  static String tgsUrl = GlobalConfiguration().getValue(kTgsEndpoint);

  BaseAPIService._();

  static final BaseAPIService instance = BaseAPIService._();

  String? _baseUrl;

  static set baseUrl(String value) {
    if (value == instance._baseUrl) {
      return;
    }
    instance._baseUrl = value;
  }

  static String get baseUrl {
    if (instance._baseUrl == null) {
      throw Exception('Base Url is not set');
    }
    return instance._baseUrl!;
  }


  static Future<ResponseModel> post(dynamic request, String method) async {
    var url = instance._baseUrl! + method;
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 60);
    var body = jsonEncode(request);
    dio.options.headers["X-API-KEY"] = "0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ";

    try {
      var response = await dio.post(
        url,
        data: body,
      );

      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return ResponseModel.fromJson(response.data);
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static postByString(dynamic request, String method) async {
    var url = instance._baseUrl! + method;
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 60);
    var body = jsonEncode(request);
    dio.options.headers["X-API-KEY"] = "0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ";

    try {
      var response = await dio.post(
        url,
        data: body,
      );

      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data;
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<ResponseModel> get({dynamic request, required String method}) async {
    var url = instance._baseUrl! + method;
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 60);
    var body = jsonEncode(request?.toJson());
    dio.options.headers["X-API-KEY"] = "0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ";

    try {
      var response = await dio.get(
        url,
        data: body,
      );

      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return ResponseModel.fromJson(response.data);
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<ResponseModel> put(dynamic request, String method) async {
    var url = instance._baseUrl! + method;
    Dio dio = Dio();
    var body = jsonEncode(request.toJson());
    dio.options.headers["X-API-KEY"] = "0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ";

    try {
      var response = await dio.put(
        url,
        data: body,
      );

      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return ResponseModel.fromJson(response.data);
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  static Future<ResponseModel> delete(dynamic request, String method) async {
    var url = instance._baseUrl! + method;
    Dio dio = Dio();
    var body = jsonEncode(request.toJson());
    dio.options.headers["X-API-KEY"] = "0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ";

    try {
      var response = await dio.delete(
        url,
        data: body,
      );

      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return ResponseModel.fromJson(response.data);
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
}
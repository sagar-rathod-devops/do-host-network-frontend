import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:do_host/data/network/base_api_services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../exception/app_exceptions.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  @override
  Future<dynamic> getApi(
    String url, {
    required Map<String, String> headers,
  }) async {
    if (kDebugMode) {
      print('[NetworkApiService][GET] Request URL: $url');
      print('[NetworkApiService][GET] Headers: $headers');
    }

    dynamic responseJson;

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 20));

      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException(
        '[NetworkApiService][GET] No Internet Connection',
      );
    } on TimeoutException {
      throw FetchDataException(
        '[NetworkApiService][GET] Network Request timed out',
      );
    }

    if (kDebugMode) {
      print('[NetworkApiService][GET] Response JSON: $responseJson');
    }

    return responseJson;
  }

  @override
  Future<dynamic> postApi(
    String url,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    if (kDebugMode) {
      print('[NetworkApiService][POST] Request URL: $url');
      print('[NetworkApiService][POST] Payload: $data');
      print(
        '[NetworkApiService][POST] Headers: ${headers ?? {"Content-Type": "application/json", "Accept": "application/json"}}',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(data),
            headers:
                headers ??
                {
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                },
          )
          .timeout(const Duration(seconds: 10));

      return returnResponse(response);
    } catch (e) {
      throw Exception('[NetworkApiService][POST] Network error: $e');
    }
  }

  @override
  Future<dynamic> putApi(
    String url,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    if (kDebugMode) {
      print('[NetworkApiService][PUT] Request URL: $url');
      print('[NetworkApiService][PUT] Payload: $data');
      print(
        '[NetworkApiService][PUT] Headers: ${headers ?? {"Content-Type": "application/json", "Accept": "application/json"}}',
      );
    }

    try {
      final response = await http
          .put(
            Uri.parse(url),
            body: jsonEncode(data),
            headers:
                headers ??
                {
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                },
          )
          .timeout(const Duration(seconds: 10));

      return returnResponse(response);
    } catch (e) {
      throw Exception('[NetworkApiService][PUT] Network error: $e');
    }
  }

  @override
  Future<dynamic> deleteApi(String url, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('[NetworkApiService][DELETE] Request URL: $url');
      print(
        '[NetworkApiService][DELETE] Headers: ${headers ?? {"Content-Type": "application/json", "Accept": "application/json"}}',
      );
    }

    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers:
                headers ??
                {
                  "Content-Type": "application/json",
                  "Accept": "application/json",
                },
          )
          .timeout(const Duration(seconds: 10));

      return returnResponse(response);
    } catch (e) {
      throw Exception('[NetworkApiService][DELETE] Network error: $e');
    }
  }

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print(
        '[NetworkApiService][RESPONSE] Status Code: ${response.statusCode}',
      );
      print('[NetworkApiService][RESPONSE] Body: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
        return jsonDecode(response.body);
      case 401:
        throw BadRequestException(
          '[NetworkApiService][RESPONSE] Unauthorized: ${response.body}',
        );
      case 404:
      case 500:
        throw UnauthorisedException(
          '[NetworkApiService][RESPONSE] Server Error: ${response.body}',
        );
      default:
        throw FetchDataException(
          '[NetworkApiService][RESPONSE] Unknown Error while communicating with server',
        );
    }
  }
}

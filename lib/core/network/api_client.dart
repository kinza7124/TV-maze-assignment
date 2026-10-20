import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// A small wrapper around the http package.
/// It sends GET requests, decodes JSON and converts errors into ApiException.
class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 429) {
        throw ApiException(
          'Too many requests. Please wait a moment and try again.',
          statusCode: response.statusCode,
        );
      }

      throw ApiException(
        'Server error (${response.statusCode}). Please try again.',
        statusCode: response.statusCode,
      );
    } on TimeoutException {
      throw const ApiException('Request timed out. Please try again.');
    } on http.ClientException {
      throw const ApiException(
        'No internet connection. Please check your network.',
      );
    } on FormatException {
      throw const ApiException('Invalid data received from the server.');
    }
  }
}

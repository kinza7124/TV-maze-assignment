import 'dart:convert';

import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// An ApiClient with a fake internet.
/// [routes] maps a full url to the JSON the "server" sends back.
/// Any url that is not in [routes] gets a 404 response.
ApiClient mockApiClient(Map<String, Object> routes) {
  return ApiClient(
    client: MockClient((request) async {
      final body = routes[request.url.toString()];
      if (body == null) return http.Response('Not found', 404);
      return http.Response(jsonEncode(body), 200);
    }),
  );
}

import 'package:flutter_application_1/core/network/api_client.dart';
import 'package:flutter_application_1/core/network/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Creates an ApiClient whose "internet" always answers with [body] and [status].
ApiClient clientReturning(String body, int status) {
  return ApiClient(
    client: MockClient((request) async => http.Response(body, status)),
  );
}

/// Matches an ApiException with the given status code.
TypeMatcher<ApiException> apiException({int? statusCode}) =>
    isA<ApiException>().having(
  (e) => e.statusCode,
  'statusCode',
  statusCode,
);

void main() {
  group('ApiClient.get', () {
    test('returns decoded JSON when the status is 200', () async {
      final client = clientReturning('[{"id": 1}]', 200);

      final data = await client.get('https://api.tvmaze.com/shows');

      expect(data, [
        {'id': 1},
      ]);
    });

    test('sends the request to the given url', () async {
      Uri? calledUrl;
      final client = ApiClient(
        client: MockClient((request) async {
          calledUrl = request.url;
          return http.Response('{}', 200);
        }),
      );

      await client.get('https://api.tvmaze.com/shows/82');

      expect(calledUrl.toString(), 'https://api.tvmaze.com/shows/82');
    });

    test('throws ApiException with code 404 for "not found"', () {
      final client = clientReturning('Not found', 404);
      expect(client.get('url'), throwsA(apiException(statusCode: 404)));
    });

    test('throws a friendly "too many requests" error for 429', () {
      final client = clientReturning('', 429);
      expect(
        client.get('url'),
        throwsA(
          apiException(statusCode: 429).having(
            (e) => e.message,
            'message',
            contains('Too many requests'),
          ),
        ),
      );
    });

    test('throws ApiException with code 500 for server errors', () {
      final client = clientReturning('', 500);
      expect(client.get('url'), throwsA(apiException(statusCode: 500)));
    });

    test('turns a network error into a "no internet" ApiException', () {
      final client = ApiClient(
        client: MockClient((request) => throw http.ClientException('offline')),
      );
      expect(
        client.get('url'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            contains('No internet'),
          ),
        ),
      );
    });

    test('turns broken JSON into an "invalid data" ApiException', () {
      final client = clientReturning('this is not json', 200);
      expect(
        client.get('url'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            contains('Invalid data'),
          ),
        ),
      );
    });
  });

  group('ApiException.messageFrom', () {
    test('returns the message of an ApiException', () {
      expect(ApiException.messageFrom(const ApiException('Oops')), 'Oops');
    });

    test('returns a general message for any other error', () {
      expect(
        ApiException.messageFrom(Exception('x')),
        'Something went wrong. Please try again.',
      );
    });
  });
}

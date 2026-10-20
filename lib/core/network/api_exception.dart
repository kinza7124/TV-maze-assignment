/// Our own error type. Every API problem is turned into an ApiException
/// with a friendly message that we can show to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  /// Converts any error into a user-friendly message.
  static String messageFrom(Object error) {
    if (error is ApiException) return error.message;
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => message;
}

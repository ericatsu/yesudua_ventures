class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super("No internet connection");
}

class DatabaseFailure extends Failure {
  const DatabaseFailure() : super("Database error occurred");
}

class ApiFailure extends Failure {
  const ApiFailure() : super("Server error occurred");
}

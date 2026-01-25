sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message) = Failure<T>;

  T? get currentData => this is Success<T> ? (this as Success<T>).data : null;
  String? get errorMessage => this is Failure<T> ? (this as Failure<T>).message : null;
}

final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final String message;

  const Failure(this.message);
}
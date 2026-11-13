import 'dart:math';
import 'package:dio/dio.dart';
import '../models/todo.dart';

final _dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
));

Future<List<Todo>> fetchTodos({String path = '/todos'}) async {
  final res = await _dio.get(path);
  final raw = res.data as List<dynamic>;
  return raw.map((j) => Todo.fromJson(j as Map<String, dynamic>)).toList();
}

Future<T> withRetry<T>(
  Future<T> Function() op, {
  int maxAttempts = 5,
  void Function(String message)? onLog,
}) async {
  for (var i = 0; ; i++) {
    try {
      return await op();
    } catch (_) {
      if (i == maxAttempts - 1) {
        onLog?.call('Attempt ${i + 1} failed. Giving up.');
        rethrow;
      }
      final base = 400 * (1 << i); // exponential: 400, 800, 1600, 3200 ms
      final delay = base + Random().nextInt(base); // jitter
      onLog?.call('Attempt ${i + 1} failed. Retrying in $delay ms');
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
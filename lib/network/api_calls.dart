import 'dart:convert';

import 'package:bayt/models/todos_model.dart';
import 'package:bayt/utils/error_handler.dart';
import 'package:dio/dio.dart';

class ApiClient {
  ApiClient() {
    var options = BaseOptions(
        receiveTimeout: 5000,
        connectTimeout: 5000,
        baseUrl: 'https://jsonplaceholder.typicode.com/');
    _dio = Dio(options);
  }

  late Dio _dio;

  Future<dynamic> fetchTodos(
      int startIndex, String? sort, String? searchTerm, String? filter) async {
    String baseUrl = '/todos?_start=$startIndex&_limit=10';
    String sortUrl = sort!.isNotEmpty ? '&_sort=title&_order=$sort' : '';
    String searchUrl = '&q=$searchTerm';
    String filterUrl = filter!.isNotEmpty ? '&completed=$filter' : '';
    try {
      final response =
          await _dio.get(baseUrl + sortUrl + searchUrl + filterUrl);

      if (response.statusCode == 200) {
        return todosModelFromJson(json.encode(response.data));
      }
    } on DioError catch (error) {
      return handleError(error);
    }
  }
}

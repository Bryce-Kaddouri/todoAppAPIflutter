/// All todo API call will be here

import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
// static method for deleteById
  static Future<bool> deleteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.delete(uri, headers: {
      'Content-Type': 'application/json', // set content-type header
      'Accept': 'application/json', // set accept header
    });

    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json', // set content-type header
      'Accept': 'application/json', // set accept header
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map data) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json', // set content-type header
        'Accept': 'application/json', // set accept header
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json', // set content-type header
        'Accept': 'application/json', // set accept header
      },
    );
    return response.statusCode == 201;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TodoHelper {
  Future<List> fetchTodo() async {
    Uri url = Uri.parse("https://jsonplaceholder.typicode.com/todos");
    Response response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to fetch data!");
    }
  }
}

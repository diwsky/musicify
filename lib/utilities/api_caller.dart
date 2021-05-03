import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCall {
  ApiCall({this.url});

  final String url;

  Future getData() async {
    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load music: ${response.body}');
      // print('error');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  Uri uri = Uri.parse('https://api.quran.gading.dev/surah');
  var res = await http.get(uri);

  List data = (json.decode(res.body) as Map<String, dynamic>)['data'];
  print(data[113]);
}

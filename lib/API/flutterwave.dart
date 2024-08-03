import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

String? baseUrl = dotenv.env['BASE_URL'];

void writeApiResponseToFile(
    List<Map<String, dynamic>> data, String fileName) async {
  try {
    // var jsonResponse = json.decode(data);
    final Directory? externalDir = await getExternalStorageDirectory();

    // final Directory directory = await getApplicationDocumentsDirectory();
    // Write the response to a file
    // File file = File('${directory.path}/$fileName');
    // await file.writeAsString(jsonEncode(data));
    // print('API response written to file: ${file.path}');

    if (externalDir != null) {
      // Write the response to a file in the external storage directory
      File file = File('${externalDir.path}/$fileName');
      await file.writeAsString(jsonEncode(data));

      print('API response written to file: ${file.path}');
    } else {
      print('External storage directory not available.');
    }
  } catch (e) {
    print('Error writting file: $e');
  }
}

import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;

class HttpHeler {
  static String apiEndpoint = 'https://posapi.getravenbank.com/v1/app';
  static Future<dynamic> postRequest(Map map, String api,
      {Map<String, String>? header}) async {
    var url = Uri.parse('$apiEndpoint/$api');

    try {
      http.Response response = await http.post(url, body: map, headers: header);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      //print(e.toString());

      return 'failed';
    }
  }

  static Future<dynamic> uploadImage(
      String path, String url, String serverImageName, String typeToken) async {
    Map<String, String> map = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization':
          'Bearer RVSEC-8bb756a159b787007fa50b556b45d11d0b49c0c0c0a7b47b3364fa7d094009d2b404a106a71103b9aecb33f73b82f5be-1662632092469'
    };

    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(path, headerBytes: [0xFF, 0xD8])?.split('/');
    // Intilize the multipart request

    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(serverImageName, path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    // imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.fields['type'] = 'bvn';
    imageUploadRequest.fields['token'] = typeToken;
    imageUploadRequest.files.add(file);
    imageUploadRequest.headers['content-type'] = 'application/json';
    imageUploadRequest.headers['Authorization'] =
        'Bearer RVSEC-8bb756a159b787007fa50b556b45d11d0b49c0c0c0a7b47b3364fa7d094009d2b404a106a71103b9aecb33f73b82f5be-1662632092469';

    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    // print('status code = ' + response.statusCode.toString());
    // print('response body = ' +  response.body.toString());

    print(response.body.toString());
    if (response.statusCode == 200) {
      String data = response.body;

      print(data.toString());
      var decodedData = jsonDecode(data);

      return decodedData;
    } else {
      return 'failed';
    }
  }
}
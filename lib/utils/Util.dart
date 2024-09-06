import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:answer_me/schemas/ChatMessage.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

typedef LLMCallbackFunction = void Function(String result, bool finish);

class Util {
  static String getMd5(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static Future<String> copyImageToAppDir() async {
    final directory = await getApplicationCacheDirectory();
    // 假设图片文件位于assets文件夹
    ByteData data = await rootBundle.load('assets/images/1.png');
    List<int> bytes = data.buffer.asUint8List();
    File imageFile = File('${directory.path}/default-avatar.png');
    await imageFile.writeAsBytes(bytes);
    return imageFile.path;
  }

  static Future<String> saveImageFromUrl(String url) async {
    final directory = await getApplicationCacheDirectory();
    File imageFile = File('${directory.path}/cache/${getMd5(url)}');
    if (imageFile.existsSync() && imageFile.lengthSync() != 0) {
      return imageFile.path;
    } else {
      imageFile.createSync(recursive: true);
    }
    Uri uri = Uri.parse(url);
    var request = http.Request('GET', uri);
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient client = new IOClient(httpClient);
    return client.send(request).then((response) {
      return response.stream.toBytes().then((value) {
        return imageFile.writeAsBytes(value).then((value) {
          return imageFile.path;
        });
      });
    });
  }

  static Future<String> saveImageFromByteData(ByteData byteData) async {
    final directory = await getApplicationCacheDirectory();
    File imageFile = File(
        '${directory.path}/cache/${getMd5(DateTime.now().toString())}.png');
    await imageFile.writeAsBytes(byteData.buffer.asUint8List());
    return imageFile.path;
  }

  static Future<String> saveImageFromBytes(Uint8List imageBytes) async {
    final directory = await getApplicationCacheDirectory();
    File imageFile = File(
        '${directory.path}/cache/${getMd5(DateTime.now().toString())}.png');
    await imageFile.writeAsBytes(imageBytes);
    return imageFile.path;
  }

  static Future<String> pickAndSaveImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationCacheDirectory();
      final File imageFile =
          File('${directory.path}/select-images/${pickedFile.name}');
      if (imageFile.existsSync() == false) {
        imageFile.createSync(recursive: true);
      }
      await imageFile.writeAsBytes(await pickedFile.readAsBytes());
      return imageFile.path;
    }
    return '';
  }

  static void writeFile(String filename, String content) async {
    final directory = await getApplicationCacheDirectory();
    final File imageFile = File('${directory.path}/files/$filename');
    if (imageFile.existsSync() == false) {
      imageFile.createSync(recursive: true);
    }
    await imageFile.writeAsString(content);
  }

  static Future<String> readFile(String filename) async {
    final directory = await getApplicationCacheDirectory();
    final File file = File('${directory.path}/files/$filename');
    if (file.existsSync() == false) {
      return '';
    }
    return file.readAsString();
  }

  static void postStream(String url, Map<String, String> header,
      Map<String, dynamic> body, Function callback) async {
    Uri uri = Uri.parse(url);
    var request = http.Request('POST', uri);
    request.body = jsonEncode(body);
    Map<String, String> headers = {'Content-Type': 'application/json'};
    headers.addAll(header);
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient client = new IOClient(httpClient);
    client.head(uri, headers: headers);
    client.send(request).then((response) {
      response.stream.listen((List<int> data) {
        callback(data);
        print(data);
      });
    });
  }

  static void post(
      String url, Map<String, String> header, Map<String, dynamic> body) async {
    Uri uri = Uri.parse(url);
    var request = http.Request('POST', uri);
    request.body = jsonEncode(body);
    Map<String, String> headers = {};
    headers.addAll(header);
    request.headers.addAll(headers);
    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    return ioClient.send(request).then((response) {
      return response.stream.bytesToString();
    });
  }

  static void askLLM(
      String basicUrl,
      String model,
      double temperature,
      String accessKey,
      List<ChatMessage> message,
      LLMCallbackFunction callback,
      Function err,
      {bufferContent = ''}) async {
    print(jsonEncode(message));
    final messages = [];
    for (var m in message) {
      messages.add({
        "role": m.role,
        "content": m.content,
      });
    }
    final requestBody = {
      "model": model,
      "messages": messages,
      "temperature": temperature,
      "stream": true
    };
    basicUrl = basicUrl.endsWith('/') ? basicUrl : '$basicUrl/';
    var request =
        http.Request('POST', Uri.parse('${basicUrl}v1/chat/completions'));
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    request.body = jsonEncode(requestBody);

    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(httpClient);
    ioClient.send(request).then((response) {
      String showContent = bufferContent;
      final stream = response.stream.transform(utf8.decoder);
      stream.listen((data) {
        if (response.statusCode != 200) {
          String finalData = data;
          if (!finalData.endsWith("```")) {
            if (finalData.contains('<html>')) {
              finalData = "\n```html\n$finalData\n```";
            } else {
              finalData = "\n```json\n$finalData\n```";
            }
          }
          showContent += "Request failed: ${response.statusCode}\n$finalData";
          callback(showContent, false);
          return;
        }
        final dataLines =
            data.split('\n').where((element) => element.isNotEmpty).toList();
        for (String line in dataLines) {
          if (!line.startsWith("data: ")) continue;
          final data = line.substring(6);
          if (data == '[DONE]') break;

          Map<String, dynamic> responseData = json.decode(data);
          List<dynamic> choices = responseData['choices'];
          Map<String, dynamic> choice = choices[0];
          Map<String, dynamic> delta = choice['delta'];
          String content = delta['content'] ?? '';
          showContent += content;
          callback(showContent, false);
          if (choice['finish_reason'] != null) break;
        }
      }, onDone: () {
        callback(showContent, true);
      }, onError: (error) => err(error));
    });
  }
}

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SelfieLiveness {
  static const MethodChannel _channel =
      MethodChannel("elatech_liveliness_plugin");

  static Future<String> detectLiveness(
      {required String poweredBy,
      required String assetLogo,
      required int compressQualityiOS,
      required int compressQualityandroid}) async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return "platform not supported";
    }
    var response = await _channel.invokeMethod("detectliveliness", {
          "msgselfieCapture": "Place your face inside the oval shaped panel",
          "msgBlinkEye": defaultTargetPlatform == TargetPlatform.iOS
              ? "Blink 3 Times"
              : "Blink Your Eyes",
          "assetPath": assetLogo,
          "poweredBy": poweredBy
        }) ??
        "";
    if (response == "") {
      return "";
    }

    File file = File(response);
    try {
      var data = await _compressImage(
          file: file,
          compressQualityandroid: compressQualityandroid,
          compressQualityiOS: compressQualityiOS);

      return data.path;
    } catch (ex) {
      return file.path;
    }
  }

  //comopression

  static Future<File> _compressImage(
      {required File file,
      required int compressQualityandroid,
      required int compressQualityiOS}) async {
    Directory tempDir = await getTemporaryDirectory();
    print(tempDir.path);
    String dir = "${tempDir.absolute.path}/test.jpeg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      dir,
      quality: TargetPlatform.iOS == defaultTargetPlatform
          ? compressQualityiOS
          : compressQualityandroid,
    );

    return result!;
  }

  static String getVideoExtension(String filePath) {
    List<String> data = filePath.split(".");
    return data[data.length - 1];
  }
}

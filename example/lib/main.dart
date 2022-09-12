import 'package:flutter/material.dart';
import 'dart:io';
import 'package:selfie_liveness/selfie_liveness.dart';

void main() {
  runApp(ElatechLiveliness());
}

class ElatechLiveliness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ElatechLiveliness();
  }
}

class _ElatechLiveliness extends State<ElatechLiveliness> {
  String value = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            value != ""
                ? Image.file(new File(value), key: UniqueKey())
                : const SizedBox(),
            Text("Press The Button To Take Photo"),
            ElevatedButton(
                onPressed: () async {
                  //clear listenable inorder to notify flutter

                  value = await SelfieLiveness.detectLiveness(
                      msgselfieCapture:
                          "Place your face inside the oval shaped panel",
                      msgBlinkEye: "Blink your eyes to capture");
                  await FileImage(File(value)).evict();
                  setState(() {});
                },
                child: const Text("Click Me"))
          ]),
        ),
      ),
    );
  }

  // void loadImage() async {
  //   String fileName = "profilepicture";
  //   String path = (await getApplicationDocumentsDirectory()).path;

  //   if (await File("$path/$fileName").exists()) {
  //     print('The image exists. Loading image from:');
  //     print('$path/$fileName');
  //     await FileImage(File('$path/$fileName)).evict();
  //     setState(() {
  //       pickedFile = XFile("$path/$fileName");
  //     });
  //   }
  // }
}

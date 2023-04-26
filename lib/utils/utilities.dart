import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

class Variables {
  static String getInitials(String name) {
    List<String> nameSplit = name.split(' ');
    String firstNameInitials = nameSplit[0][0];
    String lastNameInitials = nameSplit[1][0];
    return firstNameInitials + lastNameInitials;
  }

  static Widget circleIcon(double size, Color color, Color iconColor,
      IconData icon, double iconSize, EdgeInsets padding) {
    return Container(
      height: size,
      width: size,
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  static Future<File> pickImage({required String imagePath}) async {
    File selectedImage = File(imagePath);
    print('ANOTHER $selectedImage');
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(1000);
    Im.Image? image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image!, width: 500, height: 500);

    return File('$path/diaspearingImg_$random.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}

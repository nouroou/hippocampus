import 'package:flutter/material.dart';
import 'package:hippocampus/enum/screen_type.dart';

class ScreenInformation {
  final Orientation orientation;
  final ScreenTypes screenTypes;
  final Size screenSize;
  final Size localWidgetSize;

  ScreenInformation(
      {required this.orientation,
      required this.screenTypes,
      required this.screenSize,
      required this.localWidgetSize});

  @override
  String toString() {
    return 'Orientation: $orientation DeviceType: $screenTypes ScreenSize: $screenSize LocalSize: $localWidgetSize';
  }
}

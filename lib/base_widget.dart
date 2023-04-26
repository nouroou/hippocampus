import 'package:flutter/material.dart';
import 'package:hippocampus/enum/screen_type.dart';
import 'package:hippocampus/screen_information.dart';

class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, ScreenInformation screenInformation) builder;

  const BaseWidget(this.builder, {super.key});
  @override
  Widget build(BuildContext context) {
    var screenInformation;
    return builder(context, screenInformation);
  }
}

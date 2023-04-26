import 'package:flutter/material.dart';
import 'package:hippocampus/providers/user_provider.dart';
import 'package:hippocampus/utils/utilities.dart';
import 'package:provider/provider.dart';

class UserCircle extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const UserCircle(
      {required this.height, required this.width, required this.child});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          shape: BoxShape.circle),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              Variables.getInitials(userProvider.getUser.name),
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        ],
      ),
    );
  }
}

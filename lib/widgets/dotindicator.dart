import 'package:flutter/material.dart';

class WidDotIndicator extends StatelessWidget {
  const WidDotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 200,
        ),
        height: 8,
        width: isActive ? 18 : 8,
        decoration: BoxDecoration(
          color: isActive ? Color.fromARGB(255, 115, 232, 119) : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

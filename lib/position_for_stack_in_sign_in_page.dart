import 'package:flutter/cupertino.dart';

class Positioned_for_Auth_Pages extends StatelessWidget {
  Positioned_for_Auth_Pages({
    super.key,

    required this.image_for_page, required this.opacity,
  });
  final int opacity;

  final String image_for_page;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: opacity.toDouble(),
        duration: Duration(
          seconds: 1,
        ),
        curve: Curves.linear,
        child: Image.network(
          '$image_for_page',
          height: 400,
        ),
      ),
    );
  }
}

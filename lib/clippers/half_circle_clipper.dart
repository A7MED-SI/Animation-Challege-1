import 'package:flutter/cupertino.dart';

enum HalfCircleSide { left, right }

class HalfCircleClipper extends CustomClipper<Path> {
  HalfCircleClipper(this.halfCircleSide);

  HalfCircleSide halfCircleSide;
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (halfCircleSide == HalfCircleSide.left) path.moveTo(size.width, 0);
    double endPointX = halfCircleSide == HalfCircleSide.left ? size.width : 0;
    path.arcToPoint(
      Offset(endPointX, size.height),
      radius: Radius.circular(
        size.width * 0.5,
      ),
      clockwise: halfCircleSide == HalfCircleSide.right,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

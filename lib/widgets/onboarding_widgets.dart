import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final double height;
  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[800],
        ),
        child: SvgPicture.asset(
          imagePath,
          height: height,
        ),
      ),
    );
  }
}

class LineSeparatorWithText extends StatelessWidget {
  final String text;
  final Color lineColor;
  final Color textColor;

  const LineSeparatorWithText({
    super.key,
    required this.text,
    this.lineColor = Colors.grey,
    this.textColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: 1.2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: lineColor,
            thickness: 1.2,
          ),
        ),
      ],
    );
  }
}

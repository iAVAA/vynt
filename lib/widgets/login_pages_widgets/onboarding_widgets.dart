import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SquareTile extends StatefulWidget {
  final String imagePath;
  final double imageHeight;
  final Function()? onTap;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.imageHeight,
    required this.onTap,
  });

  @override
  _SquareTileState createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
  double _elevation = 2.0;

  void _increaseElevation() {
    setState(() {
      _elevation = 8.0;
    });
  }

  void _resetElevation() {
    setState(() {
      _elevation = 2.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _elevation,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (isHighlighted) {
          if (isHighlighted) {
            _increaseElevation();
          } else {
            _resetElevation();
          }
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
            child: SvgPicture.asset(
              widget.imagePath,
              height: widget.imageHeight,
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
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
      ),
    );
  }
}

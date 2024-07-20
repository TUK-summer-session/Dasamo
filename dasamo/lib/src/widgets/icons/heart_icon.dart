import 'package:flutter/material.dart';

class HeartIcon extends StatefulWidget {
  final bool isFavorited;
  final Function(bool) onTap;

  const HeartIcon({
    required this.isFavorited,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _HeartIconState createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hovered) {
        setState(() {
          _hovered = hovered;
        });
      },
      onTap: () {
        widget.onTap(!_hovered);
      },
      child: Icon(
        widget.isFavorited
            ? Icons.favorite
            : (_hovered ? Icons.favorite : Icons.favorite_border),
        color: widget.isFavorited ? Colors.red : (_hovered ? Colors.red : null),
      ),
    );
  }
}

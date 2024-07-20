import 'package:flutter/material.dart';

class BookmarkIcon extends StatefulWidget {
  final bool isBookmarked;
  final Function(bool) onTap;

  const BookmarkIcon({
    required this.isBookmarked,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _BookmarkIconState createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
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
        widget.isBookmarked
            ? Icons.bookmark
            : (_hovered ? Icons.bookmark : Icons.bookmark_border),
        color: widget.isBookmarked ? Color.fromRGBO(255, 193, 100, 1.0) : (_hovered ? Color.fromRGBO(255, 193, 100, 1.0) : null),
      ),
    );
  }
}

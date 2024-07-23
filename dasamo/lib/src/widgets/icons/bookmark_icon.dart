import 'package:flutter/material.dart';

class BookmarkIcon extends StatefulWidget {
  final bool isBookmarked;
  final Function(bool) onTap;

  const BookmarkIcon({
    required this.isBookmarked,
    required this.onTap,
    super.key,
  });

  @override
  _BookmarkIconState createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await widget.onTap(_isBookmarked);
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
      },
      child: Icon(
        _isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
        color: _isBookmarked ? Color.fromARGB(255, 219, 205, 72) : null,
      ),
    );
  }
}

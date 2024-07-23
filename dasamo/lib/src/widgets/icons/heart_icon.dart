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
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await widget.onTap(_isFavorited);
        setState(() {
          _isFavorited = !_isFavorited;
        });
      },
      child: Icon(
        _isFavorited ? Icons.favorite : Icons.favorite_border,
        color: _isFavorited ? Colors.red : null,
      ),
    );
  }
}
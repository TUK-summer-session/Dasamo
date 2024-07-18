import 'package:flutter/material.dart';

class ExpandText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const ExpandText({
    Key? key,
    required this.text,
    required this.style,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool _expanded = false;
  bool _isHoveringMore = false;
  bool _isHoveringLess = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: widget.style);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              maxLines: _expanded ? null : widget.maxLines,
            ),
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setState(() {
                      _isHoveringMore = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHoveringMore = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: Text(
                      _expanded ? '간략히' : '더보기',
                      style: TextStyle(
                        color: _isHoveringMore
                            ? Color.fromRGBO(175, 99, 120, 1.0)
                            : Color.fromRGBO(175, 99, 120, 0.43),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                // Add space between the two buttons if needed
                SizedBox(width: 10),
              ],
            ),
          ],
        );
      },
    );
  }
}

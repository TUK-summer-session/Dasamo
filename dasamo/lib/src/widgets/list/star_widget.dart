import 'package:flutter/material.dart';

class StarWidget extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;

  const StarWidget({
    Key? key,
    this.initialRating = 1,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarWidgetState createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  void _onStarTap(int index) {
    setState(() {
      _rating = index + 1;
    });
    widget.onRatingChanged(_rating);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      stars.add(
        GestureDetector(
          onTap: () => _onStarTap(i),
          child: Container(
            width: 23,
            height: 11,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(i < _rating
                    ? 'assets/images/sweet_potato1.jpg'
                    : 'assets/images/sweet_potato2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: stars,
    );
  }
}

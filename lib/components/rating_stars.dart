import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double initialRating;

  const StarRating({this.initialRating = 0});

  @override
  _StarRatingState createState() => _StarRatingState(initialRating);
}

class _StarRatingState extends State<StarRating> {
  double _rating;

  _StarRatingState(this._rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 1; i <= 5; i++)
           Icon(
              _getStarIcon(i),
              color: Colors.amber,
            ),
      ],
    );
  }

  IconData _getStarIcon(int index) {
    if (_rating >= index) {
      return Icons.star;
    } else if (_rating >= index - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }
}
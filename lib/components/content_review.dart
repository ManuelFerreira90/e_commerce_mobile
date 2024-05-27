import 'package:flutter/material.dart';

class ContentReview extends StatelessWidget {
  const ContentReview({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
  });

  final String name;
  final int rating;
  final String comment;

  _reviewStar() {
    return Row(children: [
      for (int i = 0; i < rating; i++)
        Icon(
          Icons.star,
          color: Colors.yellow[800],
        )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const Expanded(child: Icon(Icons.person, color: Colors.grey)),
          Expanded(
            flex: 8,
            child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(width: 5.0),
                        _reviewStar(),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(comment, style: const TextStyle(color: Colors.black54),),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
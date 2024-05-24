import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/content_review.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<ContentReview> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Widget _reviewLoading() {
    if (reviews.isEmpty) {
      return const Center(
        child: Text('No reviews'),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: reviews,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: kColorSlider,
            ))
          : _reviewLoading(),
    );
  }

  void fetchReviews() async {
    final Map<String, dynamic> products = await getOneProducts(
        context, 'https://dummyjson.com/products/${widget.id}');
    final List<dynamic> reviewsApi = products['reviews'];
    final List<ContentReview> copyReviews = [];
    for (int i = 0; i < reviewsApi.length; i++) {
      copyReviews.add(ContentReview(
          name: reviewsApi[i]['reviewerName'],
          rating: reviewsApi[i]['rating'],
          comment: reviewsApi[i]['comment']));
    }
    setState(() {
      reviews = copyReviews;
      isLoading = false;
    });
  }
}



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_rating_service.dart';
import 'package:panda_technician/helper/dialog_helper.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/models/review_model.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key, required this.customerInfo}) : super(key: key);
  final Info customerInfo;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  RatingReviewService _ratingReviewService = Get.find<RatingReviewService>();
  bool isLoading = true;
  List<ReviewModel> reviews = [];
  Future<void> fetchReview() async {
    reviews = await _ratingReviewService.getReview(widget.customerInfo.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.customerInfo.fullName} Reviews',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading ..."),
                ],
              ),
            )
          : Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Overall Rating",
                      style: TextStyle(color: Color(0xffC0BFBD), fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.customerInfo.rating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    RatingBar.builder(
                      initialRating: widget.customerInfo.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Color(0xffE76F4F),
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Based on ${widget.customerInfo.reviewCount} reviews",
                      style: const TextStyle(
                        color: Color(0xffC0BFBD),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                const Divider(),
                if (reviews.isEmpty)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No reviews yet!"),
                  )),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: review.userData.profilePicture,
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 50,
                                    placeholder: (context, url) =>
                                        const Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset("assets/avater.png"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                        review.userData.fullName.capitalize!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(height: 5),
                                      RatingBar.builder(
                                        itemSize: 10,
                                        initialRating: review.rating.toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Color(0xffE76F4F),
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(height: 5),
                                      Text(review.review),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Date / ${review.createdAt}",
                                        style: const TextStyle(
                                          color: Color(0xffC0BFBD),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ]))
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 10),
                          ]),
                        );
                      }),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          DialogHelper.showReviewPopup(context, widget.customerInfo.fullName,
              widget.customerInfo.id, null, (review) {
            setState(() {
              reviews.add(review);
              widget.customerInfo.rating = (widget.customerInfo.reviewCount *
                          widget.customerInfo.rating +
                      review.rating) /
                  (widget.customerInfo.reviewCount + 1);
              widget.customerInfo.reviewCount++;
            });
          });
        },
        label: const Row(
          children: [Icon(Icons.add), Text("Review")],
        ),
      ),
    );
  }
}

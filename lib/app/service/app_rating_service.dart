import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_api_service.dart';
import 'package:panda_technician/models/review_model.dart';

class RatingReviewService extends GetxService {
  final AppApiService _apiService = Get.find<AppApiService>();
  Future<RatingReviewService> init() async {
    return this;
  }

  Future<List<ReviewModel>> getMyReviews() async {
    var response = await _apiService.authGet("/reviews/get_my_reviews");

    List<dynamic> data = List.from(response.data);
    return data.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
  }

  Future<List<ReviewModel>> getFeedBack(context) async {
    var response = await _apiService.authGet("/reviews/get_my_feedbacks");

    List<dynamic> data = List.from(response.data);
    return data.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
  }

  Future<List<ReviewModel>> getReview(id) async {
    var response = await _apiService
        .authGet("/reviews/get_review?email=${Uri.encodeComponent(id)}");

    List<dynamic> list = List.from(response.data);
    return list.map<ReviewModel>((e) => ReviewModel.fromMap(e)).toList();
  }

  Future<bool> deleteReview(id) async {
    await _apiService.authDelete("reviews/$id");
    return true;
  }

  Future<ReviewModel> sendRating(
      String to, double rating, String? requestId, String feedback) async {
    var response = await _apiService.authPost("/reviews/add_review", data: {
      "rating": rating,
      "to_email": to,
      "requestId": requestId,
      "review": feedback
    });

    return ReviewModel.fromMap(response.data as Map<String, dynamic>);
  }
}

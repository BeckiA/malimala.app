class RatingRequestModel {
  final int rating;
  final String review;
  final int ratedUser;
  final int ratingUser;

  RatingRequestModel({
    required this.rating,
    required this.review,
    required this.ratedUser,
    required this.ratingUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review,
      'rated_user': ratedUser,
      'rating_user': ratingUser,
    };
  }
}

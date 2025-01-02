class RatingModel {
  final String id;
  final int rating;
  final String review;
  final String ratedUser;
  final String ratingUser;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.rating,
    required this.review,
    required this.ratedUser,
    required this.ratingUser,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rating: json['rating'],
      review: json['review'],
      ratedUser: json['rated_user'],
      ratingUser: json['rating_user'],
      createdAt: json['createdAt'],
    );
  }
}

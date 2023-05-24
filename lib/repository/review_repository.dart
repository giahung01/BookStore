import '../data/model/review.dart';

abstract class ReviewRepository {
  void addReview(Review review);
  void deleteReview(String reviewId);
  Future<List<Review>> getReviewListByEmail();
  Future<List<Review>> getReviewListByBook(String bookId);
  Future<List<Review>> getReviewListByRating(int rating);
  Future<bool> isCommentedOnBookByUser(String bookId);
  Future<Review> getReview(String bookId);
}
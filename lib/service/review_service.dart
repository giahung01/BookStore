import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week_2/data/model/review.dart';
import 'package:week_2/repository/review_repository.dart';
import 'package:week_2/service/book_service.dart';

import '../data/instance.dart';

class ReviewService extends ReviewRepository {
  final reviewCollection = FirebaseFirestore.instance.collection('Review');
  final userEmail = UserInstance.getEmail();
  final bookService = BookService();

  @override
  void addReview(Review review) {
    reviewCollection.doc(review.id).set({
      "id": review.id,
      "email": userEmail,
      "bookId": review.bookId,
      "comment": review.comment,
      "rating": review.rating
    }).then((value) => bookService.updateAverageRating(review.bookId));
  }

  @override
  Future<List<Review>> getReviewListByBook(String bookId) async {
    final snapshot = await reviewCollection
        .where("bookId", isEqualTo: bookId)
        .get();

    final reviewList = snapshot.docs.map((e) => Review.fromSnapshot(e)).toList();
    return reviewList;
  }

  @override
  Future<List<Review>> getReviewListByEmail() async {
    final snapshot = await reviewCollection
        .where("email", isEqualTo: userEmail)
        .get();

    final reviewList = snapshot.docs.map((e) => Review.fromSnapshot(e)).toList();
    return reviewList;
  }

  @override
  Future<bool> isCommentedOnBookByUser(String bookId) async {
    final snapshot = await reviewCollection
        .where("email", isEqualTo: userEmail)
        .where("bookId", isEqualTo: bookId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<Review> getReview(String bookId) async {
    final snapshot = await reviewCollection
        .where("bookId", isEqualTo: bookId)
        .where("email", isEqualTo: userEmail)
        .get();

    final review = snapshot.docs.map((e) => Review.fromSnapshot(e)).single;
    return review;
  }

  @override
  Future<List<Review>> getReviewListByRating(int rating) async {
    final snapshot = await reviewCollection
        .where("rating", isEqualTo: rating)
        .get();

    final reviewList = snapshot.docs.map((e) => Review.fromSnapshot(e)).toList();
    return reviewList;
  }

  @override
  void deleteReview(String reviewId) async {
    QuerySnapshot snapshot = await reviewCollection
        .where('id', isEqualTo: reviewId)
        .get();


    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

}
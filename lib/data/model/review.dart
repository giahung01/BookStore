import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id = "";
  String email = "";
  String bookId = "";
  String comment = "";
  int rating = 0;

  late final DocumentReference reference ;

  Review();


  Review.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<dynamic, dynamic>,
    reference: snapshot.reference,
  );

  Review.fromMap(
      Map<dynamic, dynamic> map, {
        required this.reference,
      })  : assert(map['id'] != null),
        assert(map['email'] != null),
        assert(map['bookId'] != null),
        assert(map['comment'] != null),
        assert(map['rating'] != null),
        id = map['id'],
        email = map['email'],
        bookId = map['bookId'],
        comment = map['comment'],
        rating = map['rating'];
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteBook {
  String id = "";
  String email = "";
  String bookId = "";

  late final DocumentReference reference ;

  FavouriteBook();

  FavouriteBook.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<dynamic, dynamic>,
    reference: snapshot.reference,
  );

  FavouriteBook.fromMap(
      Map<dynamic, dynamic> map, {
        required this.reference,
      })  : assert(map['id'] != null),
        assert(map['email'] != null),
        assert(map['bookId'] != null),
        id = map['id'],
        email = map['email'],
        bookId = map['bookId'];
}
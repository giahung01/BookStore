import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String email = "";
  String bookId = "";
  int quantity = 0;

  late final DocumentReference reference ;


  Cart(this.email, this.bookId, this.quantity);

  Cart.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
    snapshot.data() as Map<dynamic, dynamic>,
    reference: snapshot.reference,
  );

  Cart.fromMap(
      Map<dynamic, dynamic> map, {
        required this.reference,
      })  :
        assert(map['email'] != null),
        assert(map['bookId'] != null),
        assert(map['quantity'] != null),
        email = map['email'],
        bookId = map['bookId'],
        quantity = map['quantity'];
}


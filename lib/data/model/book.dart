import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String id = "-1";
  String bookName = "";
  String imgSrc = "";
  double price = 0;
  double rating = 0;  // average rating
  int sold = 0;
  int remain = 0;
  String publisher = "";
  String category = "";
  String description = "";
  late final DocumentReference reference ;

  Book();

  // Book( this.id, this.bookName, this.price, this.rating, this.sold, this.remain,
  //     this.publisher, this.category, this.description, this.reference, this.imgSrc);

  // factory Book.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data()!;
  //   return Book(
  //     document.id,
  //     data["bookName"],
  //     data["price"],
  //     data["rating"],
  //     data["sold"],
  //     data["remain"],
  //     data["publisher"],
  //     data["category"],
  //     data["description"],
  //   );
  // }

  Book.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<dynamic, dynamic>,
          reference: snapshot.reference,
        );

  Book.fromMap(
    Map<dynamic, dynamic> map, {
    required this.reference,
  })  : assert(map['id'] != null),
        assert(map['bookName'] != null),
        assert(map['price'] != null),
        assert(map['rating'] != null),
        assert(map['sold'] != null),
        assert(map['remain'] != null),
        assert(map['publisher'] != null),
        assert(map['category'] != null),
        assert(map['description'] != null),
        assert(map['imgSrc'] != null),
        id = map['id'],
        bookName = map['bookName'],
        price = map['price'],
        rating = map['rating'],
        sold = map['sold'],
        remain = map['remain'],
        publisher = map['publisher'],
        category = map['category'],
        description = map['description'],
        imgSrc = map['imgSrc'];
}

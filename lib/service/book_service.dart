import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/data/model/book.dart';
import 'package:week_2/data/model/favourite_book.dart';
import 'package:week_2/repository/book_repository.dart';

class BookService implements BookRepository {
  final bookCollection = FirebaseFirestore.instance.collection('Book');
  final reviewCollection = FirebaseFirestore.instance.collection('Review');
  final favouriteBookCollection = FirebaseFirestore.instance.collection('FavouriteBook');
  final userEmail = UserInstance.getEmail();

  CollectionReference<Map<String, dynamic>> getInstance() {
    return bookCollection;
  }

  @override
  Future<Book> getBook(String id) async {
    final snapshot = await bookCollection.where("id", isEqualTo: id).get();
    final book = snapshot.docs.map((e) => Book.fromSnapshot(e)).single;
    return book;
  }

  @override
  Future<List<Book>> getBookList() async{
    final snapshot = await bookCollection.get();
    final bookList = snapshot.docs.map((e) => Book.fromSnapshot(e)).toList();
    return bookList;
  }

  @override
  void addBook(Book newBook) {
    final book = bookCollection;
    newBook.id = InstanceCode.getIdV4();

    book.doc(newBook.id).set({
      'id': newBook.id,
      'bookName': newBook.bookName,
      'price': newBook.price,
      'rating': newBook.rating,
      'sold': newBook.sold,
      'remain': newBook.remain,
      'publisher': newBook.publisher,
      'category': newBook.category,
      'description': newBook.description,
      'imgSrc': newBook.imgSrc
    });
  }

  @override
  Future<List<String>> getBookNameList() async {
    final snapshot = await bookCollection.get();
    final bookList = snapshot.docs.map((e) => Book.fromSnapshot(e)).toList();
    final nameList = bookList.map((book) => book.bookName).toList();

    return nameList;
  }

  @override
  void addFavouriteBook(String bookId) async {
    final snapshot = await favouriteBookCollection
        .where("email", isEqualTo: userEmail)
        .where("bookId", isEqualTo: bookId)
        .get();

    // add to favourite book if it's not exist
    if (snapshot.docs.isEmpty) {
      favouriteBookCollection.add({
        'id': InstanceCode.getIdV4(),
        'email': userEmail,
        'bookId': bookId,
      });
    }

  }

  @override
  Future<List<FavouriteBook>> getFavouriteBookList() async{
    final snapshot = await favouriteBookCollection.get();
    final bookList = snapshot.docs.map((e) => FavouriteBook.fromSnapshot(e)).toList();
    return bookList;
  }

  @override
  void deleteFavouriteBook(String bookId) async {
    QuerySnapshot snapshot = await favouriteBookCollection
        .where('email', isEqualTo: userEmail)
        .where('bookId', isEqualTo: bookId)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  @override
  Stream<List<DocumentSnapshot>> getBestSellingBooks() {
    return bookCollection
        .orderBy('sold', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Future<Book> getBookByName(String name) async {
    final snapshot = await bookCollection.where("bookName", isEqualTo: name).get();
    final book = snapshot.docs.map((e) => Book.fromSnapshot(e)).single;
    return book;
  }

  @override
  void updateBook(Book book) {

    bookCollection.doc(book.id).set({
      'id': book.id,
      'bookName': book.bookName,
      'price': book.price,
      'rating': book.rating,
      'sold': book.sold,
      'remain': book.remain,
      'publisher': book.publisher,
      'category': book.category,
      'description': book.description,
      'imgSrc': book.imgSrc
    });
  }

  @override
  void deleteBook(String bookId) async {
    QuerySnapshot snapshot = await bookCollection
        .where('id', isEqualTo: bookId)
        .get();


    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  @override
  void updateAverageRating(String bookId) async {
    var snapshot = await reviewCollection
        .where("bookId", isEqualTo: bookId)
        .get();


    double totalRating = 0;
    int count = 0;

    for (var doc in snapshot.docs) {
      var rating = doc.data()["rating"];
      totalRating += rating;
      count++;
    }

    double averageRating = count > 0 ? totalRating / count : 0;

    double roundedRating = double.parse(averageRating.toStringAsFixed(1));

    _updateRatingForBook(bookId, roundedRating);
  }

  void _updateRatingForBook(String bookId, double averageRating) async {
    var snapshot = await bookCollection.where("id", isEqualTo: bookId).get();
    if (snapshot.docs.isNotEmpty) {
      final orderRef = snapshot.docs.first.reference;

      await orderRef.update({'rating': averageRating});
    }
  }

  @override
  void soldBook(String bookId) async {
    var snapshot = await bookCollection.where("id", isEqualTo: bookId).get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var sold = doc.data()["sold"];
      var remain = doc.data()["remain"];

      // Tăng giá trị của trường "sold" và giảm giá trị của trường "remain"
      doc.reference.update({
        "sold": sold + 1,
        "remain": remain - 1,
      });
    }

  }

}
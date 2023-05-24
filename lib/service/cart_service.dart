import 'package:week_2/data/instance.dart';
import 'package:week_2/data/model/user.dart';
import 'package:week_2/repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week_2/service/book_service.dart';

import '../data/model/book.dart';
import '../data/model/cart.dart';

class CartService implements CartRepository {
  final cartCollection = FirebaseFirestore.instance.collection('Cart');
  final userEmail = UserInstance.getEmail();

  @override
  void addToCart(String bookId) async {
    //Check is book exist in cart
    final QuerySnapshot result = await cartCollection
        .where('email', isEqualTo: userEmail)
        .where('bookId', isEqualTo: bookId)
        .get();

    final List<DocumentSnapshot> documents = result.docs;


    if (documents.isNotEmpty) {
      Cart cart = await _getCart(bookId);
      setQuantity(bookId, cart.quantity + 1);
    } else {
      // Add book to cart
      cartCollection.add({'email': userEmail, 'bookId': bookId, 'quantity': 1});
    }
  }

  Future<Cart> _getCart(String bookId) async {
    final snapshot = await cartCollection
        .where("email", isEqualTo: userEmail)
        .where("bookId", isEqualTo: bookId)
        .get();
    final cart = snapshot.docs.map((e) => Cart.fromSnapshot(e)).single;
    return cart;
  }

  @override
  void setQuantity(String bookId, int quantity) async {
    String email = UserInstance.getEmail();
    QuerySnapshot snapshot = await cartCollection
        .where('email', isEqualTo: email)
        .where('bookId', isEqualTo: bookId)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.update({'quantity': quantity});
    }
  }

  @override
  Future<List<Cart>> getCartList() async {
    final snapshot =
        await cartCollection.where("email", isEqualTo: userEmail).get();
    final cartList = snapshot.docs.map((e) => Cart.fromSnapshot(e)).toList();
    return cartList;
  }

  @override
  Future<int> getCartSize() async {
    var snapshot =
        await cartCollection.where("email", isEqualTo: userEmail).count().get();
    return snapshot.count;
  }

  @override
  void deleteBookFromCart(Cart cart) async {
    String email = UserInstance.getEmail();
    QuerySnapshot snapshot = await cartCollection
        .where('email', isEqualTo: email)
        .where('bookId', isEqualTo: cart.bookId)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  @override
  Future<double> getTotalPrice() async {
    BookService bookService = BookService();
    List<Cart> cartList = await getCartList();
    List<Book> bookList = await Future.wait(
        cartList.map((cart) => bookService.getBook(cart.bookId)));

    double totalPrice = 0;

    for (var i = 0; i < cartList.length; i++) {
      totalPrice += bookList[i].price * cartList[i].quantity;
    }

    return totalPrice;
  }

  @override
  void deleteAll() async {
    cartCollection
        .where('email', isEqualTo: userEmail)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}

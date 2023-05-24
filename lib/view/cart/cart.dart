import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/cart_service.dart';
import 'package:week_2/view/payment/pay_screen.dart';

import '../../data/model/book.dart';
import '../../data/model/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartService cartService = CartService();
  BookService bookService = BookService();

  List<Cart> cartList = [];
  Map<String, Book> bookMap = {};

  bool _isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    cartList = await cartService.getCartList();

    if (cartList.isNotEmpty) {
      final List<Future<Book>> bookFutures = cartList
          .map((cartItem) => bookService.getBook(cartItem.bookId))
          .toList();

      final List<Book> books = await Future.wait(bookFutures);

      for (var i = 0; i < cartList.length; i++) {
        bookMap[cartList[i].bookId] = books[i];
      }

      print(
          "LOAD DATA: SUCCESS (cartList: ${cartList.length}, bookMap: ${bookMap.length})");

      // Future.delayed(const Duration(milliseconds: 10));
    } else {
      cartList = [];
      print("LOAD DATA: FAILED");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : (cartList.isEmpty)
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: _buildNoItemInCart(),
              )
            : Scaffold(
        appBar: AppBar(
          title: const Text("Giỏ hàng"),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
        ),
                body:
                buildScreen()
    );
  }

  Widget buildListView() {
    return ListView(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: cartList.length,
            itemBuilder: (context, index) {
              final cart = cartList[index];
              final book = bookMap[cart.bookId];

              // print("CART IN LISTVIEW: ${book?.bookName}");

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    cartItem(cart, book!),
                    const SizedBox(
                      height: 18,
                    )
                  ],
                ),
              );
            }),
        const SizedBox(
          height: 60,
        )
      ],
    );
  }

  buildScreen() {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: buildListView(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Color(0xffdedede), width: 2.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text("Tổng cộng",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13)),
                    FutureBuilder(
                      future: cartService.getTotalPrice(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                              "${NumberFormat.currency(locale: 'vi', symbol: '').format(snapshot.data)}đ",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffdd485b)));
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PayScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffdd485b)),
                    child: const Text("Mua hàng"),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Container cartItem(Cart cart, Book book) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                )),
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: NetworkImage(book.imgSrc))),
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: Text(
                        book.bookName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(4.0)),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (cart.quantity > 1) {
                                  cart.quantity--;
                                  cartService.setQuantity(
                                      cart.bookId, cart.quantity);
                                } else {
                                  _showAlertDialog(cart);
                                }
                              });
                            },
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 15.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "${cart.quantity}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(4.0)),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                cart.quantity++;
                                cartService.setQuantity(
                                    cart.bookId, cart.quantity);
                              });
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15.0,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${NumberFormat.currency(locale: 'vi', symbol: '').format(book.price * cart.quantity)}đ",
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                onPressed: () {
                  _showAlertDialog(cart);
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                )),
          )
        ],
      ),
    );
  }

  void _showAlertDialog(Cart cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Loại '),
          content: const Text('Loại sản phẩm khỏi giỏ hàng?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Xóa'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Không'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        setState(() {
          // Yes
          cartList.remove(cart);
          bookMap.remove(cart.bookId);
          cartService.deleteBookFromCart(cart);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }

  Widget _buildNoItemInCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.shopping_cart_outlined,
          size: 300,
        ),
        Text(
          "Chưa có sản phẩm nào trong giỏ hàng",
          style: TextStyle(fontSize: 30),
        )
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/cart_service.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/main_screen/home_page/book_detail/book_description.dart';
import 'package:week_2/view/main_screen/home_page/book_detail/comment_book_detail.dart';

import '../../../../data/model/book.dart';
import '../../../../data/model/review.dart';
import '../../../../data/model/user.dart';
import '../../../cart/cart.dart';
import '../../../login_regis/login_screen.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  const BookDetail({super.key, required this.book});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final cartService = CartService();
  final bookService = BookService();
  final userService = UserService();

  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var email = UserInstance.getEmail();
    bool isLogin = true;
    if (email == "") {
      isLogin = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),

        /* title: const Text('Pickup',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 20.0,
                color: Color(0xFF545D68))),*/
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.book, color: BookStoreColor.blueBackground()),
            onPressed: () {
              if (isLogin) {
                bookService.addFavouriteBook(widget.book.id);

                _showToast('Đã thêm vào sách yêu thích');
              } else {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()))
                    .then((value) => setState(() {}));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: BookStoreColor.greyBackground(),
            child: ListView(children: [
              buildBookInfo(),
              const SizedBox(
                height: 10.0,
              ),
              /* buildDeliveredTo(),
              const SizedBox(
                height: 10.0,
              ),*/
              buildBookDetail(),
              const SizedBox(
                height: 10.0,
              ),
              buildBookDescription(),
              const SizedBox(
                height: 10.0,
              ),
              _buildWidget(),
              const SizedBox(
                height: 100.0,
              ),
            ]),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (isLogin) {
                    cartService.addToCart(widget.book.id);

                    _showToast('Thêm vào giỏ hàng thành công');
                  } else {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()))
                        .then((value) => setState(() {}));
                  }

                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CartScreen()));*/
                  // print("TAGY: ${cartService.getCartSize()}");
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffdd485b)),
                child: const Text("Thêm vào giỏ hàng"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookInfo() {
    return Column(
      children: [
        Hero(
          tag: widget.book.imgSrc,
          child: Image(
            image: NetworkImage(widget.book.imgSrc),
            fit: BoxFit.contain,
            height: 300,
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.book.bookName,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 7,
                  ),
                  Text("${widget.book.rating}",
                      style: const TextStyle(color: Colors.black38, fontSize: 15)),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "|",
                    style: TextStyle(color: Colors.black38, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Đã bán: ${widget.book.sold}",
                    style: const TextStyle(color: Colors.black38, fontSize: 15),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(InstanceCode.currencyFormat(widget.book.price),
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: BookStoreColor.redBackground())),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDeliveredTo() {
    return Container(
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Giao đến ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'abc',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ))
      ]),
    );
  }

  Widget buildBookDetail() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Thông tin chi tiết",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(0.5),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xfffafafa),
                ),
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Thể loại',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.book.category,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xfffafafa),
                ),
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Nhà sản xuất',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.book.publisher,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBookDescription() {
    return Container(
        color: Colors.white,
        child: Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Mô tả",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.book.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black
                        ),
                      ),
                      WidgetSpan(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.grey.withOpacity(1),
                              ],
                              // stops: const [-0.4, 0.5],
                            ).createShader(bounds);
                          },
                          // child: Image.network(
                          //   'https://cdn0.fahasa.com/media/catalog/product/i/m/image_240307.jpg'
                          //   ,),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDescriptionScreen(
                                description: widget.book.description)));
                  },
                  child: const Text("Xem tất cả"))),
        ]));
  }

  Widget _buildWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Review')
          .where('bookId', isEqualTo: widget.book.id)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20.0),
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
          if (snapshot.isNotEmpty)
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllCommentInBookDetailScreen(
                                        bookId: widget.book.id)));
                      },
                      child: const Text("Xem tất cả"))),
            ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final review = Review.fromSnapshot(data);
    return _buildCommentSpace(review);
  }

  Widget _buildCommentSpace(Review review) {
    return FutureBuilder(
        future: userService.getUserByEmail(review.email),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var user = snapshot.data!;
          var rating = review.rating;

          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: rating >= 1 ? Colors.orange : Colors.grey,
                        ),
                        Icon(
                          Icons.star,
                          color: rating >= 2 ? Colors.orange : Colors.grey,
                        ),
                        Icon(
                          Icons.star,
                          color: rating >= 3 ? Colors.orange : Colors.grey,
                        ),
                        Icon(
                          Icons.star,
                          color: rating >= 4 ? Colors.orange : Colors.grey,
                        ),
                        Icon(
                          Icons.star,
                          color: rating >= 5 ? Colors.orange : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    review.comment,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Divider(
                    height: 2,
                    color: Color(0xfff5f5fa),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showToast(String message) {
    fToast.showToast(
        child: toast(message),
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            bottom: 30.0,
            right: 0.0,
            left: 0.0,
            child: child,
          );
        });
  }

  Widget toast(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.teal,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );
  }
}

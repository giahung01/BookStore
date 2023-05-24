import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/order_service.dart';
import 'package:week_2/service/review_service.dart';
import 'package:week_2/data/model/order.dart' as MyOrder;

import '../../../../data/instance.dart';
import '../../../../data/model/order.dart';
import 'comment_screen.dart';

class ListCommentItemScreen extends StatefulWidget {
  final String orderId;

  const ListCommentItemScreen({super.key, required this.orderId});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<ListCommentItemScreen> {
  var orderService = OrderService();
  var reviewService = ReviewService();
  var bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Đánh giá'),
        centerTitle: true,
      ),
      body: _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('OrderItem')
          .where('orderId', isEqualTo: widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final orderItem = MyOrder.OrderItem.fromSnapshot(data);

    return _buildItem(orderItem);
  }

  Widget _buildItem(MyOrder.OrderItem orderItem) {
    return FutureBuilder(
        future: bookService.getBook(orderItem.bookId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var book = snapshot.data!;
          return GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext builder) {
                  return DialogCommentScreen(
                    bookId: book.id,
                  );
                }),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Image(
                      image: NetworkImage(
                          book.imgSrc),
                      fit: BoxFit.contain,
                      height: 50,
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text(
                              book.bookName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ], 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });

  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/instance.dart';
import '../../data/model/book.dart';
import '../../data/model/review.dart';
import '../../service/user_service.dart';
import '../main_screen/home_page/book_detail/book_description.dart';
import '../main_screen/home_page/book_detail/comment_book_detail.dart';

class AdminReadBookScreen extends StatefulWidget {
  final Book book;
  const AdminReadBookScreen({super.key, required this.book});

  @override
  _ReadBookState createState() => _ReadBookState();

}

class _ReadBookState extends State<AdminReadBookScreen> {
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
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

      ),
      body: Container(
        color: const Color(0xfff5f5fa),
        child: ListView(children: [
          buildBookInfo(),
          const SizedBox(
            height: 10.0,
          ),
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
                children:  <Widget>[
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
                    "${widget.book.sold}",
                    style: const TextStyle(color: Colors.black38, fontSize: 15),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(InstanceCode.currencyFormat(widget.book.price),
                      style: const TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF17532))),
                ),
              ),
            ],
          ),
        ),
      ],
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
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Số sách còn trong kho',
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
                        "${widget.book.remain}",
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
                  color: Colors.white,
                ),
                children: [
                  const TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Đã bán',
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
                        "${widget.book.sold}",
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
}
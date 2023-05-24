import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/instance.dart';
import '../../../data/model/book.dart';
import '../../../service/book_service.dart';
import 'book_detail/book_detail.dart';

class BestSellingBooksList extends StatefulWidget {
  const BestSellingBooksList({super.key});

  @override
  _ListState createState() => _ListState();

}
class _ListState extends State<BestSellingBooksList> {

  BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffca2128),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Xác nhận đơn hàng"),
        centerTitle: true,
      ),
      body: buildProductDisplay(),
    );
  }

  buildProductDisplay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Book')
                    .orderBy("sold", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  return _buildGridView(context, snapshot.data?.docs ?? []);
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      primary: false,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.8,
      children: snapshot.map((data) => _buildGridItem(context, data)).toList(),
    );
  }

  Widget _buildGridItem(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);
    return _buildBookDisplayItem(book);
  }

  Widget _buildBookDisplayItem(Book book) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetail(book: book)))
              .then((value) => setState(() {}));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0)
              ],
              color: Colors.white),
          child: Column(
            children: [
              Hero(
                  tag: book.imgSrc,
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(book.imgSrc),
                            fit: BoxFit.contain)),
                  )),
              const SizedBox(
                height: 7.0,
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(book.bookName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Color(0XFF575E67),
                            fontFamily: 'Varela',
                            fontSize: 12.0)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 7,
                    ),
                    Text("${book.rating}",
                        style: const TextStyle(color: Colors.black38, fontSize: 10)),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 10,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "|",
                      style: TextStyle(color: Colors.black38, fontSize: 10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Đã bán: ${book.sold}",
                      style: const TextStyle(color: Colors.black38, fontSize: 10),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, left: 7, bottom: 7),
                    child: Text(InstanceCode.currencyFormat(book.price),
                        style: const TextStyle(
                            color: Color(0xFFCC8053),
                            fontFamily: 'Varela',
                            fontSize: 15.0)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

}
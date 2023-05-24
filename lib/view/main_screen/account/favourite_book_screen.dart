import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:week_2/data/instance.dart';

import '../../../data/model/book.dart';
import '../../../data/model/favourite_book.dart';
import '../../../service/book_service.dart';
import '../home_page/book_detail/book_detail.dart';

class FavouriteBookScreen extends StatefulWidget {
  const FavouriteBookScreen({super.key});

  @override
  _FavouriteBookScreenState createState() => _FavouriteBookScreenState();
}

class _FavouriteBookScreenState extends State<FavouriteBookScreen> {

  BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sách yêu thích"),
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
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('FavouriteBook').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    BookService bookService = BookService();
    final favouriteBook = FavouriteBook.fromSnapshot(data);

    return FutureBuilder(
        future: bookService.getBook(favouriteBook.bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitRotatingCircle(
              color: Colors.blue,
              size: 50.0,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final book = snapshot.data;
            return _cartItem(book!);
          }
        });
  }

  Widget _cartItem(Book book) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookDetail(
                book: book,
              )));
        },
        child: Card(
          elevation: 3,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 300, child: Text(book.bookName)),
                    ],
                  ),
                ),
                Text(
                  InstanceCode.currencyFormat(book.price),
                  textAlign: TextAlign.right,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                      onPressed: () {
                        _showAlertDialog(book);
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Loại '),
          content: const Text('Xóa khỏi danh sách yêu thích?'),
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
         bookService.deleteFavouriteBook(book.id);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/view/admin/add_book.dart';
import 'package:week_2/view/admin/edit_book.dart';
import 'package:week_2/view/admin/read_book.dart';

import '../../data/model/book.dart';
import '../../data/model/cart.dart';
import '../../service/book_service.dart';

class AdminBookListScreen extends StatefulWidget {
  const AdminBookListScreen({super.key});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<AdminBookListScreen> {
  BookService bookService = BookService();
  late Future<List<String>> bookNameList;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    bookNameList = bookService.getBookNameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý sách"),
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
      body: Container(
        color: BookStoreColor.greyBackground(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                           BookStoreColor.redBackground()),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),

                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminAddBookScreen()));
                    },
                    child: const Text(
                      'Thêm sách',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              buildSearchBar(),
              _buildWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Book').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);

    return _cartItem(book);
  }

  Widget _cartItem(Book book) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminReadBookScreen(
                      book: book,
                    )));
      },
      child: Container(
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
                      Text(
                        book.bookName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            InstanceCode.currencyFormat(book.price),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminEditBookScreen(
                                  book: book,
                                )));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  )),
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
    );
  }

  buildSearchBar() {
    return FutureBuilder(
        future: Future.wait([bookNameList]),
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final list = snapshot.data![0] as List<String>;
            return Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            child: Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                } else {
                                  List<String> filteredSuggestions(
                                      String query) {
                                    return list
                                        .where((suggestion) => suggestion
                                            .toLowerCase()
                                            .contains(query.toLowerCase()))
                                        .toList();
                                  }

                                  return filteredSuggestions(
                                      textEditingValue.text);
                                }
                              },
                              onSelected: (String selection) async {
                                _textEditingController.text = selection;
                                Book book =
                                    await bookService.getBookByName(selection);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AdminReadBookScreen(
                                          book: book,
                                        )));
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (String value) {
                                    onFieldSubmitted();
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 7),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xff5ac18e),
                                    ),
                                    suffix: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.focused)) {
                                            return Colors.red;
                                          }
                                          return null; // Defer to the widget's default.
                                        }),
                                      ),
                                      onPressed: () {
                                        onFieldSubmitted();
                                      },
                                      child: const Text('Search'),
                                    ),
                                    hintText: 'Search',
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                  ),
                                );
                              },
                            )),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        });
  }

  void _showAlertDialog(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Xóa sách?'),
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
          bookService.deleteBook(book.id);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }
}

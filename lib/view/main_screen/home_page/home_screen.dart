import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/cart_service.dart';
import 'package:week_2/view/cart/cart.dart';
import 'package:week_2/view/login_regis/login_screen.dart';
import 'package:week_2/view/main_screen/home_page/best_selling_list.dart';
import 'package:week_2/view/main_screen/home_page/top_rated_book_list.dart';

import '../../../data/model/book.dart';
import 'book_detail/book_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BookService bookService = BookService();
  CartService cartService = CartService();

  late Future<List<String>> bookNameList;
  final TextEditingController _textEditingController = TextEditingController();
  bool isLogin = true;
  var email = UserInstance.getEmail();

  @override
  void initState() {
    bookNameList = bookService.getBookNameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (email == "") {
      isLogin = false;
    }

    print("EMAIL HOME SCREEN: $email");

    return Scaffold(
        body: FutureBuilder(
            future: Future.wait([bookNameList]),
            builder:
                (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
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
                // print("LIST: $list");
                return AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.light,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(color: BookStoreColor.greyBackground()),
                      child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return <Widget>[];
                            },
                            body: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  buildSearchBar(list),
                                  const SizedBox(height: 5),
                                  _topRatedBookSpace(),
                                  const SizedBox(height: 5),
                                  _bestSellingBookSpace(),
                                  const SizedBox(height: 10),
                                  _allBookSpace(),
                                ],
                              ),
                            ),
                          )),
                    ));
              }
            }));
  }

  _topRatedBookSpace() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TopRatedBooksList()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Sách nổi bật",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                )
              ],
            ),
          ),
        ),
        _buildTopRatedBook()
      ]),
    );
  }

  _bestSellingBookSpace() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BestSellingBooksList()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Sách bán chạy",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15,
                )
              ],
            ),
          ),
        ),
        _buildBestSellingBook()
      ]),
    );
  }

  _allBookSpace() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Sách",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        buildProductDisplay()
      ]),
    );
  }

  buildSearchBar(List<String> list) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 8),
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
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        } else {
                          /*return list.where((String option) {
                            return option
                                .contains(textEditingValue.text.toLowerCase());
                          }).toList();*/
                          List<String> filteredSuggestions(String query) {
                            return list
                                .where((suggestion) => suggestion
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList();
                          }

                          return filteredSuggestions(textEditingValue.text);
                        }
                      },
                      onSelected: (String selection) async {
                        _textEditingController.text = selection;
                        Book book = await bookService.getBookByName(selection);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BookDetail(
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
                            contentPadding: const EdgeInsets.only(top: 7),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xff5ac18e),
                            ),
                            suffix: TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
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
                            hintStyle: const TextStyle(color: Colors.black38),
                          ),
                        );
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isLogin) {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartScreen()))
                              .then((value) => setState(() {}));
                        } else {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()))
                              .then((value) => setState(() {}));
                        }
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      iconSize: 30,
                      color: BookStoreColor.blueBackground(),
                    ),
                    Positioned(
                      top: 0,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: BookStoreColor.redBackground(),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: FutureBuilder<int>(
                          future: cartService.getCartSize(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return  Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                "${snapshot.data}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  buildProductDisplay() {
    return SizedBox(
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
              stream: FirebaseFirestore.instance.collection('Book').snapshots(),
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
    );
  }

  Widget _buildGridView(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
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
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 10)),
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
                      style:
                          const TextStyle(color: Colors.black38, fontSize: 10),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, left: 7, bottom: 7),
                    child: Text(InstanceCode.currencyFormat(book.price),
                        style: TextStyle(
                            color: BookStoreColor.redBackground(),
                            fontFamily: 'Varela',
                            fontSize: 15.0)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRatedBook() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Book')
          .orderBy("rating", descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildBestSellingBook() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Book')
          .orderBy("sold", descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return SizedBox(
      height: 240,
      child: Expanded(
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemExtent: 150,
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final book = Book.fromSnapshot(data);

    return _buildBookDisplayItem(book);
  }
}

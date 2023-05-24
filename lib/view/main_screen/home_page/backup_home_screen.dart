import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/cart_service.dart';
import 'package:week_2/view/cart/cart.dart';

import '../../../data/model/book.dart';
import 'book_detail/book_detail.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  BookService bookService = BookService();
  CartService cartService = CartService();

  late Future<List<String>> bookNameList;

  final TextEditingController _textEditingController = TextEditingController();
  final int _numItemInCart = 0;

  @override
  void initState() {
    bookNameList = bookService.getBookNameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([bookNameList]),
          builder:
              (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final list = snapshot.data![0] as List<String>;
              //print("LIST: $list");
              return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xffca2128)),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            buildSearchBar(list),
                            const SizedBox(height: 5),
                            const SizedBox(
                              height: 10,
                            ),
                            buildProductDisplay(),
                            //const ProductDisplay()
                          ],
                        ),
                      ),
                    ),
                  ));
            }
          }),
    );
  }

  buildSearchBar(List<String> list) {
    return Column(
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
                          return list.where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase())).toList();
                        }
                        return filteredSuggestions(textEditingValue.text);
                      }
                    },
                    onSelected: (String selection) {
                      _textEditingController.text = selection;
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
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()))
                          .then((value) => setState(() {}));
                    },
                    icon: const Icon(Icons.shopping_cart),
                    iconSize: 30,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 0,
                    right: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: FutureBuilder<int>(
                        future: cartService.getCartSize(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Icon(
                              Icons.shopping_cart,
                              size: 30,
                              color: Colors.white,
                            );
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
              padding: const EdgeInsets.only(right: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: bookService.getInstance().snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LinearProgressIndicator();
                  return _buildGridView(context, snapshot.data?.docs ?? []);
                },
              )),
          const SizedBox(
            height: 100.0,
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
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookDetail(
                    book: book,
                  )));
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
                  children: const <Widget>[
                    SizedBox(
                      width: 7,
                    ),
                    Text("4.5",
                        style: TextStyle(color: Colors.black38, fontSize: 10)),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 10,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.black38, fontSize: 10),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Đã bán: 1000",
                      style: TextStyle(color: Colors.black38, fontSize: 10),
                    )
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, left: 7, bottom: 7),
                    child: Text("${book.price} đ",
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

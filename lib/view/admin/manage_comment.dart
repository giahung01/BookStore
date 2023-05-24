import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/review_service.dart';

import '../../data/instance.dart';
import '../../data/model/review.dart';
import '../../service/user_service.dart';
import '../main_screen/account/comment/comment_screen.dart';

class AdminManageCommentScreen extends StatefulWidget {
  const AdminManageCommentScreen({super.key});

  @override
  _ManageCommentState createState() => _ManageCommentState();
}

class _ManageCommentState extends State<AdminManageCommentScreen> {

  final userService = UserService();
  final bookService = BookService();
  final reviewService = ReviewService();

  List<Color> _containerColor = [Colors.white, Colors.white, Colors.white, Colors.white, Colors.white];


  List<Color> _borderColor = [
    BookStoreColor.defaultRatingBorderBackGround(),
    BookStoreColor.defaultRatingBorderBackGround(),
    BookStoreColor.defaultRatingBorderBackGround(),
    BookStoreColor.defaultRatingBorderBackGround(),
    BookStoreColor.defaultRatingBorderBackGround()];

  int rating = 0;
  bool _isSelectFilter = false;

  void _setFilter(int filterRating) {
    setState(() {
      var index = filterRating - 1;
      if (_containerColor[index] == BookStoreColor.selectRatingBackGround()) {
        _containerColor[index] = Colors.white;
        _borderColor[index] = BookStoreColor.defaultRatingBorderBackGround();
        _isSelectFilter = false;
      } else {
        _containerColor = List.generate(
            _containerColor.length, (i) => i == index ? BookStoreColor.selectRatingBackGround() : Colors
            .white);
        _borderColor = List.generate(
            _borderColor.length, (i) => i == index ? BookStoreColor.selectRatingBorderBackGround() :
        BookStoreColor.defaultRatingBorderBackGround());
      }
      if (_containerColor[index] == BookStoreColor.selectRatingBackGround()) {
        _isSelectFilter = true;
        rating = filterRating;
      } /*else {
        _isSelectFilter = false;
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Quản lý bình luận"),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildSelectStarFilter()
              ),
              if (!_isSelectFilter)
                _buildWidget()
              else
                _buildWidgetByRating(rating)
            ],
          ),
        ));
  }

  Widget _buildSelectStarFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _setFilter(5);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor[4],
                width: 1 ,
              ),
              color: _containerColor[4],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: const <Widget>[
                  Text("5",
                      style: TextStyle(
                          color: Colors.black38, fontSize: 15)),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setFilter(4);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor[3],
                width: 1.0,
              ),
              color: _containerColor[3],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: const <Widget>[
                  Text("4",
                      style: TextStyle(
                          color: Colors.black38, fontSize: 15)),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setFilter(3);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor[2],
                width: 1.0,
              ),
              color: _containerColor[2],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: const <Widget>[
                  Text("3",
                      style: TextStyle(
                          color: Colors.black38, fontSize: 15)),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setFilter(2);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor[1],
                width: 1.0,
              ),
              color: _containerColor[1],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: const <Widget>[
                  Text("2",
                      style: TextStyle(
                          color: Colors.black38, fontSize: 15)),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _setFilter(1);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor[0],
                width: 1.0,
              ),
              color: _containerColor[0],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: const <Widget>[
                  Text("1",
                      style: TextStyle(
                          color: Colors.black38, fontSize: 15)),
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetByRating(int rating) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Review')
          .where('rating', isEqualTo: rating)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Review')
          .snapshots(),
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
    final review = Review.fromSnapshot(data);

    return _buildListCommentItem(review);
  }

  Widget _buildListCommentItem(Review review) {
    return FutureBuilder(
        future: userService.getUserByEmail(review.email),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var user = snapshot.data!;
          var rating = review.rating;

          return FutureBuilder(
              future: bookService.getBook(review.bookId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var book = snapshot.data!;

                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext builder) {
                          return AdminDialogCommentScreen(
                            bookId: book.id, review: review,
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.bookName,
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
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
                                        color:
                                            rating >= 1 ? Colors.orange : Colors.grey,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color:
                                            rating >= 2 ? Colors.orange : Colors.grey,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color:
                                            rating >= 3 ? Colors.orange : Colors.grey,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color:
                                            rating >= 4 ? Colors.orange : Colors.grey,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color:
                                            rating >= 5 ? Colors.orange : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  review.comment,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(
                                  height: 2,
                                  color: Color(0xfff5f5fa),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                                onPressed: () {
                                   _showAlertDialog(review);
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
                );
              });
        });
  }

  void _showAlertDialog(Review review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Xóa đánh giá?'),
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
          reviewService.deleteReview(review.id);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }
}

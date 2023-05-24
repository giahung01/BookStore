import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/review_service.dart';
import '../../../../data/model/book.dart';
import '../../../../data/model/review.dart';

class CommentListScreen extends StatefulWidget {
  const CommentListScreen({super.key});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentListScreen> {
  var reviewService = ReviewService();
  var bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Đánh giá sản phẩm"),
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
        body: _buildWidget());
  }

  Widget _buildWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Review')
          .where('email', isEqualTo: UserInstance.getEmail())
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
    final review = Review.fromSnapshot(data);

    return _buildItem(review);
  }

  Widget _buildItem(Review review) {
    return FutureBuilder(
        future: bookService.getBook(review.bookId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var book = snapshot.data!;
          var rating = review.rating;

          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const CommentScreen()));
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogCommentScreen(
                      bookId: book.id,
                    );
                  });
            },
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
                              style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                           ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star, color: rating >= 1 ? Colors.orange : Colors.grey,),
                          Icon(Icons.star, color: rating >= 2 ? Colors.orange : Colors.grey,),
                          Icon(Icons.star, color: rating >= 3 ? Colors.orange : Colors.grey,),
                          Icon(Icons.star, color: rating >= 4 ? Colors.orange : Colors.grey,),
                          Icon(Icons.star, color: rating >= 5 ? Colors.orange : Colors.grey,),
                        ],
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

class DialogCommentScreen extends StatefulWidget {
  final String bookId;

  const DialogCommentScreen({super.key, required this.bookId});

  @override
  _DialogCommentState createState() => _DialogCommentState();
}

class _DialogCommentState extends State<DialogCommentScreen> {
  var myColorOne = Colors.grey;
  var myColorTwo = Colors.grey;
  var myColorThree = Colors.grey;
  var myColorFour = Colors.grey;
  var myColorFive = Colors.grey;

  var bookService = BookService();
  var reviewService = ReviewService();

  late FToast fToast;
  var rating = 5;
  var review = Review();
  var isLoadedData = false;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 250,
        child: Scaffold(
          body: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: FutureBuilder(
                  future: bookService.getBook(widget.bookId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var book = snapshot.data!;

                    return FutureBuilder(
                        future: reviewService
                            .isCommentedOnBookByUser(widget.bookId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          var isExist = snapshot.data!;
                          if (isExist) {
                            if (!isLoadedData) {
                              isLoadedData = true;
                              return FutureBuilder(
                                  future:
                                      reviewService.getReview(widget.bookId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    review = snapshot.data!;
                                    rating = review.rating;
                                    _textFieldController.text = review.comment;
                                    return _buildDisplay(book);
                                  });
                            }
                          }

                          return _buildDisplay(book);
                        });
                  })),
        ),
      ),
    );
  }

  Widget _buildDisplay(Book book) {
    return Column(
      children: [
        Row(
          children: [
            Image(
              image: NetworkImage(book.imgSrc),
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
                    width: 220,
                    child: Text(
                      book.bookName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _selectedStar()
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 100),
            child: TextField(
              maxLines: null,
              controller: _textFieldController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: 'Vì sao bạn thích sản phẩm?',
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (review.id == "") {
              review.id = InstanceCode.getIdV4();
            }
            review.rating = rating;
            review.bookId = book.id;
            review.comment = _textFieldController.text.trim();
            reviewService.addReview(review);

            _showToast();

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            textStyle: const TextStyle(
              fontSize: 13,
            ),
            minimumSize: const Size(double.infinity, 0),
          ),
          child: const Text('Gửi đánh giá'),
        ),
      ],
    );
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.teal,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        // Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Đánh giá đã được gửi"),
      ],
    ),
  );

  Widget _selectedStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 1),
          color: rating >= 1 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 2),
          color: rating >= 2 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 3),
          color: rating >= 3 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 4),
          color: rating >= 4 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 5),
          color: rating == 5 ? Colors.orange : Colors.grey,
        ),
      ],
    );
  }

  void _showToast() {
    fToast.showToast(
        child: toast,
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
}

class AdminDialogCommentScreen extends StatefulWidget {
  final String bookId;
  final Review review;

  const AdminDialogCommentScreen({
    super.key,
    required this.bookId,
    required this.review
  });

  @override
  _AdminDialogCommentState createState() => _AdminDialogCommentState();
}

class _AdminDialogCommentState extends State<AdminDialogCommentScreen> {
  var myColorOne = Colors.grey;
  var myColorTwo = Colors.grey;
  var myColorThree = Colors.grey;
  var myColorFour = Colors.grey;
  var myColorFive = Colors.grey;

  var bookService = BookService();
  var reviewService = ReviewService();

  late FToast fToast;
  var rating = 5;
  var isLoadedData = false;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 250,
        child: Scaffold(
          body: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: FutureBuilder(
                  future: bookService.getBook(widget.bookId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    var book = snapshot.data!;
                    _textFieldController.text = widget.review.comment;
                    rating = widget.review.rating;
                    return _buildDisplay(book);

                  })),
        ),
      ),
    );
  }

  Widget _buildDisplay(Book book) {
    return Column(
      children: [
        Row(
          children: [
            Image(
              image: NetworkImage(book.imgSrc),
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
                    width: 220,
                    child: Text(
                      book.bookName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _selectedStar()
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 130),
            child: TextField(
              maxLines: null,
              controller: _textFieldController,
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: 'Vì sao bạn thích sản phẩm?',
              ),
            ),
          ),
        ),

        /*Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              if (review.id == "") {
                review.id = InstanceCode.getIdV4();
              }
              review.rating = rating;
              review.bookId = book.id;
              review.comment = _textFieldController.text.trim();
              reviewService.addReview(review);

              _showToast();

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Text('Xóa'),
          ),
        ),*/
      ],
    );
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.teal,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        // Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Đánh giá đã được gửi"),
      ],
    ),
  );

  Widget _selectedStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 1),
          color: rating >= 1 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 2),
          color: rating >= 2 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 3),
          color: rating >= 3 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 4),
          color: rating >= 4 ? Colors.orange : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: () => setState(() => rating = 5),
          color: rating == 5 ? Colors.orange : Colors.grey,
        ),
      ],
    );
  }

  void _showToast() {
    fToast.showToast(
        child: toast,
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


}

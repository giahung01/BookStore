import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../data/model/book.dart';
import '../../service/book_service.dart';

class AdminEditBookScreen extends StatefulWidget {
  final Book book;

  const AdminEditBookScreen({super.key, required this.book});

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<AdminEditBookScreen> {
  var bookService = BookService();

  final TextEditingController _imgLinkController = TextEditingController();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookDesController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _remainController = TextEditingController();

  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _loadData();
    super.initState();
  }

  void _loadData() {
    _imgLinkController.text = widget.book.imgSrc;
    _bookNameController.text = widget.book.bookName;
    _bookDesController.text = widget.book.description;
    _categoryController.text = widget.book.category;
    _priceController.text = widget.book.price.toString();
    _publisherController.text = widget.book.publisher;
    _remainController.text = widget.book.remain.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Link liên kết hình ảnh",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  maxLines: null,
                  controller: _imgLinkController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'https://...',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Tên sách",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  maxLines: null,
                  controller: _bookNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Tên sách',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Mô tả",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  maxLines: null,
                  controller: _bookDesController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Mô tả',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Thể loại",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Thể loại',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Giá",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  /*inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],*/
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Giá sách',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Nhà xuất bản",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  controller: _publisherController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'NXB',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Số lượng trong kho",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _remainController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: '0',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!hasEmptyField()) {
                    updateBook();
                    _showToast("Cập nhật thành công");
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Điền vào chỗ trống"),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool hasEmptyField() {
    return [
      _imgLinkController,
      _bookNameController,
      _bookDesController,
      _categoryController,
      _priceController,
      _publisherController,
      _remainController,
    ].any((controller) => controller.text.isEmpty);
  }

  void updateBook() {
    widget.book.imgSrc = _imgLinkController.text.trim();
    widget.book.bookName = _bookNameController.text.trim();
    widget.book.description = _bookDesController.text.trim();
    widget.book.category = _categoryController.text.trim();
    widget.book.price = double.tryParse(_priceController.text.trim()) ?? 0;
    widget.book.publisher = _publisherController.text.trim();
    widget.book.remain = int.tryParse(_remainController.text.trim()) ?? 0;

    bookService.updateBook(widget.book);
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

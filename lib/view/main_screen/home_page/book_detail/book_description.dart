import 'package:flutter/material.dart';

class BookDescriptionScreen extends StatefulWidget {
  final String description;
  const BookDescriptionScreen({super.key, required this.description});

  @override
  _BookDescriptionState createState() => _BookDescriptionState();

}

class _BookDescriptionState extends State<BookDescriptionScreen> {

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
        title: const Text("Mô tả"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.description),
      )),
    );
  }
}


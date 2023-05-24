import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  _CancelOrderState createState() => _CancelOrderState();

}

class _CancelOrderState extends State<CancelOrderScreen> {
  final TextEditingController _textFieldController = TextEditingController();


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
        title: const Text("Hủy đơn"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.greenAccent,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding (
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lý do hủy đơn",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Lý do hủy đơn',
                ),
                maxLines: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // user.name = _textFieldController.text.trim();
                  // userService.setUser(user);
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
                child: const Text('Nộp'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
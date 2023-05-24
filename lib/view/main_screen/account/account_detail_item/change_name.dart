import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/user_service.dart';

import '../../../../data/model/user.dart';

class ChangeNameScreen extends StatelessWidget {
  final User user;
  ChangeNameScreen({super.key, required this.user});

  UserService userService = UserService();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Họ & Tên"),
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
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Họ & Tên",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Họ & tên',
                ),
              ),
              const Text(
                "Họ & tên gồm 2 từ trở lên",
                style: TextStyle(fontSize: 13),
              ),
              ElevatedButton(
                onPressed: () {
                  user.name = _textFieldController.text.trim();
                  userService.setUser(user);
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
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

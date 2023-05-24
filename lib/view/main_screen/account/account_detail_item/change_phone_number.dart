import 'package:flutter/material.dart';

import '../../../../data/instance.dart';
import '../../../../data/model/user.dart';
import '../../../../service/user_service.dart';

class ChangePhoneScreen extends StatelessWidget {
  final User user;
  ChangePhoneScreen({super.key, required this.user});

  UserService userService = UserService();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Số điện thoại"),
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
                "Số điện thoại",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _textFieldController,
                maxLength: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: '0123465789',
                ),
              ),
              const Text(
                "Mã xác thực (OTP) sẽ được gửi đến số điện thoại này để xác minh số điện thoại là của bạn",
                style: TextStyle(fontSize: 13),
              ),
              ElevatedButton(
                onPressed: () {
                  user.phone = _textFieldController.text.trim();
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

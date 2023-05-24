import 'package:flutter/material.dart';

import '../../../../data/instance.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {

  bool passwordVisible = false;
  bool newPasswordVisible = false;
  bool reEnterNewPasswordVisible = false;
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnterNewPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    newPasswordController.dispose();
    reEnterNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
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
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Mật khẩu hiện tại",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 14),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xff5ac18e),
                    ),
                    hintText: 'Nhập mật khẩu hiện tại',
                    hintStyle: const TextStyle(color: Colors.black38),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              const Text(
                "Mật khẩu mới",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: !newPasswordVisible,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 14),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xff5ac18e),
                    ),
                    hintText: 'Nhập mật khẩu mới',
                    hintStyle: const TextStyle(color: Colors.black38),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            newPasswordVisible = !newPasswordVisible;
                          });
                        },
                        icon: Icon(newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              const Text(
                "Nhập lại mật khẩu mới",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: reEnterNewPasswordController,
                obscureText: !reEnterNewPasswordVisible,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 14),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xff5ac18e),
                    ),
                    hintText: 'Nhập lại mật khẩu mới',
                    hintStyle: const TextStyle(color: Colors.black38),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            reEnterNewPasswordVisible = !reEnterNewPasswordVisible;
                          });
                        },
                        icon: Icon(reEnterNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off))),
              ),
              ElevatedButton(
                onPressed: () {},
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

import 'dart:io';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:week_2/service/user_service.dart';

import '../../data/model/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String imgLogoPath =
      "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/39999/bookstore-clipart-xl.png";

  bool defaultValue = false;
  bool passwordVisible = false;
  bool retypePasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  final otpVerify = TextEditingController();

  EmailOTP myAuth = EmailOTP();

  UserService userService = UserService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    retypePasswordController.dispose();
    super.dispose();
  }

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
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xffca2128)
                      // gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter,
                      //     colors: [
                      //   Color(0xffC11E38),
                      //   Color(0xffD94E54),
                      //   Color(0xffEF566A),
                      //   Color(0xffCA2128),
                      // ])
                      ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: NetworkImage(imgLogoPath),
                              fit: BoxFit.contain,
                              height: 200,
                              width: 200,
                            ),
                            // const Text(
                            //   'Sign In',
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 30,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            const SizedBox(height: 20),
                            buildEmailField(),
                            // const SizedBox(height: 20),
                            buildPasswordField(),
                            // const SizedBox(height: 20),
                            buildRetypePasswordField(),

                            // buildVerifyOTP(),
                            const SizedBox(height: 20),
                            buildRegisterButton(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
            controller: emailController,
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
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
                hintText: 'Password',
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
        ),
      ],
    );
  }

  Widget buildRetypePasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextField(
            controller: retypePasswordController,
            obscureText: !retypePasswordVisible,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Retype Password',
                hintStyle: const TextStyle(color: Colors.black38),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        retypePasswordVisible = !retypePasswordVisible;
                      });
                    },
                    icon: Icon(retypePasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off))),
          ),
        ),
      ],
    );
  }

  Widget buildVerifyOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2))
                    ]),
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black87),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xff5ac18e),
                      ),
                      hintText: 'OTP',
                      hintStyle: TextStyle(color: Colors.black38)),
                  controller: otpVerify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffca2128)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                    onPressed: () {
                      sendOtp();
                    },
                    child: const Text(
                      'Gửi OTP',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ],
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          /*if (otpVerify.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Bạn chưa xác thực Email"),
            ));
          } else {
            verify();
            // TODO: Xác thực sai và đúng OTP
          }*/

          if (retypePasswordController.text == passwordController.text) {
            User user = User();
            user.email = emailController.text;
            user.password = passwordController.text;

            if (_isValidEmail(user.email)) {
              if (await userService.isRegisterNewUser(user)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Đăng kí thành công"),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Email đã tồn tại"),
                ));
              }
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Định dạng email không hợp lệ"),
              ));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Nhập lại mật khẩu không chính xác"),
            ));
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xff93faa5),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Color(0xffca2128),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void verify() async {
    if (await myAuth.verifyOTP(otp: otpVerify.text.trim()) == true) {
      print("OTP Verified");
    } else {
      print("Invalid OTP");
    }
  }

  void sendOtp() async {
    myAuth.setConfig(
        appEmail: "contact@hdevcoder.com",
        appName: "Book Store",
        userEmail: emailController.text,
        otpLength: 4,
        otpType: OTPType.digitsOnly);

    if (await myAuth.sendOTP() == true) {
      print("OTP sent");
    } else {
      print("Send failed");
    }
  }
}

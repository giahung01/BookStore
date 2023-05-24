import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:week_2/view/main_screen/home_page/home_screen.dart';
import 'package:week_2/view/login_regis/register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String imgLogoPath =
      "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/39999/bookstore-clipart-xl.png";

  bool defaultValue = false;
  bool passwordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
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
                  child: SingleChildScrollView(
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
                        buildEmail(),
                        const SizedBox(height: 20),
                        buildSendEmailButton(context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget buildEmail() {
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

  Widget buildSendEmailButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Coming soon"))),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xff93faa5),
        ),
        child: const Text(
          'SEND',
          style: TextStyle(
            color: Color(0xffca2128),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

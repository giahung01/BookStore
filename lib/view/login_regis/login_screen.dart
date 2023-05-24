import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/admin/home.dart';
import 'package:week_2/view/login_regis/forgot_password_screen.dart';
import 'package:week_2/view/login_regis/register_screen.dart';
import '../main_screen/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String imgLogoPath =
      "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/39999/bookstore-clipart-xl.png";

  bool defaultValue = false;
  bool passwordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserService userService = UserService();

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
        backgroundColor: const Color(0xffca2128),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  decoration: const BoxDecoration(color: Color(0xffca2128)),
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
                        const SizedBox(height: 20),
                        buildEmailField(),
                        const SizedBox(height: 20),
                        buildPasswordField(),
                        const SizedBox(height: 20),
                        buildRememberAndForgotPassword(),
                        buildLoginButton(context),
                        buildRegisterButton(context)
                      ],
                    ),
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
                hintText: 'Mật khẩu',
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

  Widget buildRememberAndForgotPassword() {
    return Row(
      // Remember and forgot password
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
              ),
              child: Checkbox(
                value: defaultValue,
                onChanged: (newValue) {
                  setState(() {
                    defaultValue = !defaultValue;
                  });
                },
                checkColor: Colors.white,
                hoverColor: Colors.white,
              ),
            ),
            const Text(
              "Nhớ mật khẩu",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen())),
          child: const Text(
            "Quên mật khẩu",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xff89c4f4),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          String email = emailController.text;
          String password = passwordController.text;
          if (await userService.isLoginSuccess(email, password)) {
            UserInstance.setEmail(email);
            // print("EMAIL_LOGINSCREEN: ${UserInstance.getEmail()}");

            var user = await userService.getUserByEmail(email);

            if (user.role == 1) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminMainScreen()));
            } else {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Email hoặc mật khẩu không đúng"),
            ));
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            color: Color(0xff5ac18e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterScreen())),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xff93faa5),
        ),
        child: const Text(
          'Đăng ký',
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

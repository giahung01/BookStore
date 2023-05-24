import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/view/admin/book_list.dart';
import 'package:week_2/view/admin/home.dart';
import 'package:week_2/view/admin/manage_comment.dart';
import 'package:week_2/view/admin/manage_order.dart';
import 'package:week_2/view/cart/cart.dart';
import 'package:week_2/view/login_regis/login_screen.dart';
import 'package:week_2/view/login_regis/register_screen.dart';
import 'package:week_2/view/main_screen/account/account_screen.dart';
import 'package:week_2/view/main_screen/account/favourite_book_screen.dart';
import 'package:week_2/view/main_screen/account/shiping_info/cancel_order.dart';
import 'package:week_2/view/main_screen/home_page/backup_home_screen.dart';
import 'package:week_2/view/main_screen/home_page/book_detail/book_detail.dart';
import 'package:week_2/view/main_screen/home_page/search.dart';
import 'package:week_2/view/main_screen/main_screen.dart';
import 'package:week_2/view/payment/pay_screen.dart';
import 'package:week_2/view/test_widget.dart';

import 'admin/add_book.dart';
import 'main_screen/account/account_detail.dart';
import 'main_screen/account/shiping_info/shipping_info.dart';
import 'main_screen/category/category_screen.dart';
import 'main_screen/home_page/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDOLCPudXN08xuvos2P0EN2USmGAYjnX9Y"
          , appId: "1:1076754415693:android:9b3e17a2c803f538bf1c04"
          , messagingSenderId: "1076754415693"
          , projectId: "bookstore-9bf1d"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      home: MainScreen()
    );
  }

}



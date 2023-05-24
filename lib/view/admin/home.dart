import 'package:flutter/material.dart';
import 'package:week_2/view/admin/book_list.dart';
import 'package:week_2/view/admin/manage_comment.dart';
import 'package:week_2/view/admin/manage_order.dart';

import '../../data/instance.dart';
import '../main_screen/main_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: BookStoreColor.greyBackground(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AdminBookListScreen()));
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Icon(Icons.book, size: 80,),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Sách", style: TextStyle(fontSize: 20),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AdminManageCommentScreen()));
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Icon(Icons.chat, size: 80,),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Bình luận", style: TextStyle(fontSize: 20),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const AdminManageOrderScreen()));
                      },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(Icons.shopping_cart, size: 80,),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Đơn hàng", style: TextStyle(fontSize: 20),),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        UserInstance.defaultEmail();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()));
                      },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: const [
                                Icon(Icons.logout, size: 80,),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Đăng xuất", style: TextStyle(fontSize: 20),),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
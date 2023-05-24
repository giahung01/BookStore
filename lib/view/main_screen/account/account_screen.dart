import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/view/login_regis/login_screen.dart';
import 'package:week_2/view/main_screen/account/account_detail.dart';
import 'package:week_2/view/cart/cart.dart';
import 'package:week_2/view/main_screen/account/comment/comment_screen.dart';
import 'package:week_2/view/main_screen/account/favourite_book_screen.dart';
import 'package:week_2/view/main_screen/account/shiping_info/shipping_info.dart';

import '../../../service/cart_service.dart';
import '../../../service/user_service.dart';
import '../main_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final cartService = CartService();
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    var email = UserInstance.getEmail();
    bool isLogin = true;
    if (email == "") {
      isLogin = false;
    }

    return Scaffold(
        body: Container(
          color: BookStoreColor.greyBackground(),
          child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (isLogin)
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CartScreen()))
                                  .then((value) => setState(() {}));
                            }
                          else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          }

                        },
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: BookStoreColor.blueBackground(),
                        ),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: 0,
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: FutureBuilder<int>(
                            future: cartService.getCartSize(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  "${snapshot.data}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AccountDetailScreen()));
                },
                child: Card(
                    elevation: 5,
                    child: (() {
                      if (isLogin) {
                        return _isLoginCardScreen();
                      } else {
                        return _isNotLoginCardScreen();
                      }
                    }())),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ShippingInfoScreen(
                            tabIndex: 0,
                          )));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Đơn hàng của tôi",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1 Dang xu ly
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShippingInfoScreen(
                                      tabIndex: 1,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffeff7ff),
                            side: const BorderSide(
                                width: 1, color: Colors.transparent),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.move_to_inbox,
                                  size: 25,
                                  color: Color(0xff1377e6),
                                ),
                              )),
                        ),
                      ),
                      const Text(
                        "Đang xử lý",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                // 2 Dang van chuyen
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShippingInfoScreen(
                                      tabIndex: 2,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffeff7ff),
                            side: const BorderSide(
                                width: 1, color: Colors.transparent),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.local_shipping,
                                  size: 25,
                                  color: Color(0xff1377e6),
                                ),
                              )),
                        ),
                      ),
                      const Text(
                        "Đang vận chuyển",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                // 3 Da giao
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShippingInfoScreen(
                                      tabIndex: 3,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffeff7ff),
                            side: const BorderSide(
                                width: 1, color: Colors.transparent),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.done,
                                  size: 25,
                                  color: Color(0xff1377e6),
                                ),
                              )),
                        ),
                      ),
                      const Text(
                        "Đã giao",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                // 3 Da huy
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ShippingInfoScreen(
                                      tabIndex: 4,
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffeff7ff),
                            side: const BorderSide(
                                width: 1, color: Colors.transparent),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.cancel_outlined,
                                  size: 25,
                                  color: Color(0xff1377e6),
                                ),
                              )),
                        ),
                      ),
                      const Text(
                        "Đã hủy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const CommentListScreen())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Đánh giá sản phẩm",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const FavouriteBookScreen())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Sách yêu thích",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            ),
            if (UserInstance.getEmail() != "")
              Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            UserInstance.defaultEmail();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          child: const Text("Đăng xuất"))),
                ],
              ),
            )
          ],
      ),
    ),
        ));
  }

  Widget _isNotLoginCardScreen() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle_rounded,
            size: 50,
            color: BookStoreColor.blueBackground(),
          ),
          const SizedBox(
            width: 20,
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: BookStoreColor.blueBackground()),
            ),
            child: const Text(
              "Đăng nhập",
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  Widget _isLoginCardScreen() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
           Icon(
            Icons.account_circle_rounded,
            size: 50,
            color: BookStoreColor.blueBackground(),
          ),
          const SizedBox(
            width: 20,
          ),
          FutureBuilder(
              future: userService.getUserByEmail(UserInstance.getEmail()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var user = snapshot.data!;
                return Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              })
        ],
      ),
    );
  }
}

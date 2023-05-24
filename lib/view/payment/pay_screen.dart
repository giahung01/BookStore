import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/data/model/order.dart' as MyOrder;
import 'package:week_2/service/cart_service.dart';
import 'package:week_2/service/order_service.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/main_screen/main_screen.dart';
import 'package:week_2/view/payment/select_address.dart';

import '../../data/model/book.dart';
import '../../data/model/cart.dart';
import '../../data/model/user.dart';
import '../../service/book_service.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<PayScreen> {
  final UserService userService = UserService();
  final CartService cartService = CartService();
  final BookService bookService = BookService();
  final OrderService orderService = OrderService();
  late Future<User> _user;
  late Future<String> _address;

  @override
  void initState() {
    _user = userService.getUser();
    _address = userService.getSelectedAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Xác nhận đơn hàng"),
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
        body: FutureBuilder(
            future: Future.wait([_user, _address]),
            builder:
                (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final user = snapshot.data![0] as User;
                final address = snapshot.data![1] as String;
                return Stack(children: [
                  Container(
                    color: const Color(0xffeeeeee),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectAddressScreen()));

                            setState(() {});
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        color: Color(0xff1377e6),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      const Text(
                                        "|",
                                        style: TextStyle(
                                          color: Color(0xffefefef),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        user.phone,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        FutureBuilder(
                                          future:
                                              userService.getSelectedAddress(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return Expanded(
                                                  child: Text(
                                                snapshot.data!,
                                                style: const TextStyle(
                                                    color: Color(0xff828282)),
                                              ));
                                            }
                                          },
                                        ),
                                        const Icon(
                                          Icons.navigate_next,
                                          color: Color(0xff797979),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      "Sản phẩm đã chọn",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                _buildBody(context),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Phương thức thanh toán",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Xem tất cả",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color(0xff2a71a9),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.radio_button_checked),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Icon(
                                              Icons.payments_outlined,
                                              color: Color(0xff006bea),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text(
                                                "Thanh toán bằng tiền mặt"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Tạm tính",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    FutureBuilder(
                                      future: cartService.getTotalPrice(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Text(
                                              "${NumberFormat.currency(locale: 'vi', symbol: '').format(snapshot.data)}đ",
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ));
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("Phí vận chuyển",
                                          style: TextStyle(fontSize: 13)),
                                      Text("0đ", style: TextStyle(fontSize: 13))
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Divider(
                                    color: Color(0xffefefef),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Tổng tiền",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                    FutureBuilder(
                                      future: cartService.getTotalPrice(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Text(
                                              "${NumberFormat.currency(locale: 'vi', symbol: '').format(snapshot.data)}đ",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold));
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text("Tổng tiền",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 13)),
                              FutureBuilder(
                                future: cartService.getTotalPrice(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text(
                                        "${NumberFormat.currency(locale: 'vi', symbol: '').format(snapshot.data)}đ",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffdd485b)));
                                  }
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OrderSuccess()));
                                _createOrder();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffdd485b)),
                              child: const Text("Đặt hàng"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ]);
              }
            }));
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Cart')
          .where("email", isEqualTo: UserInstance.getEmail())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    BookService bookService = BookService();
    final cart = Cart.fromSnapshot(data);

    return FutureBuilder<Book>(
        future: bookService.getBook(cart.bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitRotatingCircle(
              color: Colors.blue,
              size: 50.0,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final book = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _cartItem(cart, book!),
                  const SizedBox(
                    height: 18,
                  )
                ],
              ),
            );
          }
        });
  }

  Widget _cartItem(Cart cart, Book book) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(book.imgSrc),
              fit: BoxFit.contain,
              height: 50,
              width: 50,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 300, child: Text(book.bookName)),
                  Text("SL: x${cart.quantity}")
                ],
              ),
            ),
            Text(
              "${NumberFormat.currency(locale: 'vi', symbol: '').format(book.price * cart.quantity)}đ",
              textAlign: TextAlign.right,
            )
          ],
        ),
      ),
    );
  }

  void _createOrder() async {
    MyOrder.Order order = MyOrder.Order();
    order.id = InstanceCode.getOrderCode();
    order.orderDate = InstanceCode.getTime();
    order.address = await userService.getSelectedAddress();
    order.email = UserInstance.getEmail();
    order.totalPrice = await cartService.getTotalPrice();

    orderService.addOrder(order);

    _createOrderItem(order.id);
  }

  void _createOrderItem(String orderId) async {
    List<Cart> cartList = await cartService.getCartList();
    for (Cart cart in cartList) {
      MyOrder.OrderItem orderItem = MyOrder.OrderItem();
      orderItem.orderId = orderId;
      orderItem.bookId = cart.bookId;
      orderItem.quantity = cart.quantity;

      orderService.addOrderItem(orderItem);
    }
    cartService.deleteAll();
  }
}

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle,
                size: 250,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Đặt hàng thành công",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffdd485b)),
                    child: const Text("Quay về trang chủ"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

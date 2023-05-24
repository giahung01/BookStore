import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/order_service.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/cart/cart.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;

  const OrderDetail({super.key, required this.orderId});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  OrderService orderService = OrderService();
  BookService bookService = BookService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn hàng"),
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
      body: Stack(
        children: [
          ListView(
            children: [FutureBuilder(
      future: orderService.getOrder(widget.orderId),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.hasError) {
            return Text('Error: ${orderSnapshot.error}');
          }
          if (!orderSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var order = orderSnapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.list_alt_outlined),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mã đơn hàng: ${order.id}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text("Ngày đặt hàng: ${order.orderDate}"),
                        Text(
                          OrderInstance.getStringStatus(order.status),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.location_pin),
                    ),
                    FutureBuilder(
                        future: userService.getUser(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasError) {
                            return Text(
                                'Error: ${userSnapshot.error}');
                          }
                          if (!userSnapshot.hasData) {
                            return const Align(
                                alignment: Alignment.centerLeft,
                                child: Center(child: CircularProgressIndicator()));
                          }

                          var user = userSnapshot.data!;

                          return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Địa chỉ người nhận",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(user.name),
                                Text(user.phone),
                                SizedBox(
                                    width: 300,
                                    child: Text(
                                      order.address,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ]);
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: FutureBuilder(
                      future: orderService.getOrderItemList(order.id),
                      builder: (context, snapshotList) {
                        if (snapshotList.hasError) {
                          return Text('Error: ${snapshotList.error}');
                        }
                        if (!snapshotList.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        var orderItemList = snapshotList.data!;
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderItemList.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FutureBuilder(
                                      future: bookService.getBook(
                                          orderItemList[index]
                                              .bookId),
                                      builder:
                                          (context, bookSnapshot) {
                                        if (bookSnapshot.hasError) {
                                          return Text(
                                              'Error: ${bookSnapshot.error}');
                                        }
                                        if (!bookSnapshot.hasData) {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                        var book = bookSnapshot.data!;
                                        return Row(
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  book.imgSrc),
                                              fit: BoxFit.contain,
                                              height: 50,
                                              width: 50,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                      width: 300,
                                                      child: Text(
                                                        book.bookName,
                                                        maxLines: 2,
                                                      )),
                                                  Text(
                                                    "SL: ${orderItemList[index].quantity}",
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${NumberFormat.currency(locale: 'vi', symbol: '').format(book.price)}đ",
                                              textAlign:
                                              TextAlign.right,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              );
                            });
                      })),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.payment_rounded),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hình thức thanh toán",
                          style:
                          TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Thanh toán tiền mặt khi nhận hàng"),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tạm tính"),
                          Text(
                            "${NumberFormat.currency(locale: 'vi', symbol: '').format(order.totalPrice)}đ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(
                        padding:
                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Divider(
                          height: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Phí vận chuyển"),
                          Text(
                            "0 đ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(
                        padding:
                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Divider(
                          height: 3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Thành tiền"),
                          Text(
                            "${NumberFormat.currency(locale: 'vi', symbol: '').format(order.totalPrice)}đ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
              const SizedBox(
                height: 70,
              )
            ],
          );
        })]),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    orderService.addOrderItemToCart(widget.orderId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                  child: const Text("Mua lại"),
                )),
          )
        ],
      ),
    );
  }
}


class AdminOrderDetail extends StatefulWidget {
  final String orderId;

  const AdminOrderDetail({super.key, required this.orderId});

  @override
  _AdminOrderDetailState createState() => _AdminOrderDetailState();
}

class _AdminOrderDetailState extends State<AdminOrderDetail> {
  OrderService orderService = OrderService();
  BookService bookService = BookService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đơn hàng"),
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
      body: ListView(
          children: [FutureBuilder(
              future: orderService.getOrder(widget.orderId),
              builder: (context, orderSnapshot) {
                if (orderSnapshot.hasError) {
                  return Text('Error: ${orderSnapshot.error}');
                }
                if (!orderSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var order = orderSnapshot.data!;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.list_alt_outlined),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mã đơn hàng: ${order.id}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Ngày đặt hàng: ${order.orderDate}"),
                              Text(
                                OrderInstance.getStringStatus(order.status),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.location_pin),
                          ),
                          FutureBuilder(
                              future: userService.getUser(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return Text(
                                      'Error: ${userSnapshot.error}');
                                }
                                if (!userSnapshot.hasData) {
                                  return const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Center(child: CircularProgressIndicator()));
                                }

                                var user = userSnapshot.data!;

                                return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Địa chỉ người nhận",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(user.name),
                                      Text(user.phone),
                                      SizedBox(
                                          width: 300,
                                          child: Text(
                                            order.address,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ]);
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: FutureBuilder(
                            future: orderService.getOrderItemList(order.id),
                            builder: (context, snapshotList) {
                              if (snapshotList.hasError) {
                                return Text('Error: ${snapshotList.error}');
                              }
                              if (!snapshotList.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              var orderItemList = snapshotList.data!;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: orderItemList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FutureBuilder(
                                            future: bookService.getBook(
                                                orderItemList[index]
                                                    .bookId),
                                            builder:
                                                (context, bookSnapshot) {
                                              if (bookSnapshot.hasError) {
                                                return Text(
                                                    'Error: ${bookSnapshot.error}');
                                              }
                                              if (!bookSnapshot.hasData) {
                                                return const Center(child: CircularProgressIndicator());
                                              }
                                              var book = bookSnapshot.data!;
                                              return Row(
                                                children: [
                                                  Image(
                                                    image: NetworkImage(
                                                        book.imgSrc),
                                                    fit: BoxFit.contain,
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                            width: 300,
                                                            child: Text(
                                                              book.bookName,
                                                              maxLines: 2,
                                                            )),
                                                        Text(
                                                          "SL: ${orderItemList[index].quantity}",
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "${NumberFormat.currency(locale: 'vi', symbol: '').format(book.price)}đ",
                                                    textAlign:
                                                    TextAlign.right,
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    );
                                  });
                            })),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.payment_rounded),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Hình thức thanh toán",
                                style:
                                TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Thanh toán tiền mặt khi nhận hàng"),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tạm tính"),
                                Text(
                                  "${NumberFormat.currency(locale: 'vi', symbol: '').format(order.totalPrice)}đ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Padding(
                              padding:
                              EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Divider(
                                height: 3,
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Phí vận chuyển"),
                                Text(
                                  "0 đ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Padding(
                              padding:
                              EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Divider(
                                height: 3,
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Thành tiền"),
                                Text(
                                  "${NumberFormat.currency(locale: 'vi', symbol: '').format(order.totalPrice)}đ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                );
              })]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week_2/data/model/order.dart' as MyOrder;
import '../../data/instance.dart';
import '../../service/book_service.dart';
import '../../service/order_service.dart';
import '../cart/cart.dart';
import '../main_screen/account/comment/comment_list.dart';
import '../main_screen/account/comment/comment_screen.dart';
import '../main_screen/account/shiping_info/cancel_order.dart';
import '../main_screen/account/shiping_info/order_detail.dart';

class AdminManageOrderScreen extends StatefulWidget {
  const AdminManageOrderScreen({super.key});

  @override
  _ManageOrderState createState() => _ManageOrderState();
}

class _ManageOrderState extends State<AdminManageOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BookService bookService = BookService();
  OrderService orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 5,
        vsync: this,
        initialIndex:
            0); // số lượng tab là 3 và vsync là this (nếu StatefulWidget của bạn kế thừa TickerProviderStateMixin)
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(child: Text("Tất cả đơn")),
                Tab(child: Text("Chờ xác nhận")),
                Tab(child: Text("Đang vận chuyển")),
                Tab(child: Text("Đã giao")),
                Tab(child: Text("Đã hủy")),
              ],
            ),
          ),
          title: const Text('Quản lý đơn hàng'),
          centerTitle: true,
        ),
        body: Container(
          color: BookStoreColor.greyBackground(),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllOrdersWidget(),
              _buildWaitingOrdersWidget(),
              _buildDeliveringOrdersWidget(),
              _buildDeliveredOrdersWidget(),
              _buildCanceledOrdersWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllOrdersWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Order').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var isNoOrder = snapshot.data?.docs ?? [];

        if (isNoOrder.isEmpty) {
          return _buildNoItemInCart();
        }

        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildWaitingOrdersWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where("status", isEqualTo: 0)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var isNoOrder = snapshot.data?.docs ?? [];

        if (isNoOrder.isEmpty) {
          return _buildNoItemInCart();
        }

        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildDeliveringOrdersWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where("status", isEqualTo: 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var isNoOrder = snapshot.data?.docs ?? [];

        if (isNoOrder.isEmpty) {
          return _buildNoItemInCart();
        }

        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildDeliveredOrdersWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where("status", isEqualTo: 2)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var isNoOrder = snapshot.data?.docs ?? [];

        if (isNoOrder.isEmpty) {
          return _buildNoItemInCart();
        }

        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildCanceledOrdersWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where("status", isEqualTo: 3)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var isNoOrder = snapshot.data?.docs ?? [];

        if (isNoOrder.isEmpty) {
          return _buildNoItemInCart();
        }

        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final order = MyOrder.Order.fromSnapshot(data);
    final orderItemList = orderService.getOrderItemList(order.id);

    return _buildItem(order, orderItemList);
  }

  Widget _buildItem(
      MyOrder.Order order, Future<List<MyOrder.OrderItem>> orderItemList) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: FutureBuilder<List<MyOrder.OrderItem>>(
              future: orderItemList,
              builder: (context, snapshotList) {
                if (snapshotList.hasError) {
                  return Text('Error: ${snapshotList.error}');
                }
                if (!snapshotList.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var bookId = snapshotList.data![0].bookId;
                var listSize = snapshotList.data!.length;
                return FutureBuilder(
                    future: bookService.getBook(bookId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var book = snapshot.data!;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(OrderInstance.getStringStatus(
                                      order.status))),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Divider(
                              height: 1,
                            ),
                          ),
                          Row(
                            children: [
                              Image(
                                image: NetworkImage(book.imgSrc),
                                fit: BoxFit.contain,
                                height: 50,
                                width: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        book.bookName,
                                        maxLines: 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text("Số lượng: $listSize"),
                                        const Text(" | "),
                                        Text(
                                          InstanceCode.currencyFormat(
                                              order.totalPrice),
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (_tabController.index == 1)
                                _turnToDelivering(order),
                              if (_tabController.index == 2)
                                _turnToDelivered(order),
                              if (_tabController.index == 1 ||
                                  _tabController.index == 2)
                                _cancelOrder(order),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          UserInstance.setEmail(order.email);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      AdminOrderDetail(
                                                        orderId: order.id,
                                                      )));
                                        },
                                        child: const Text("Xem chi tiết")),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    });
              })),
    );
  }

  Widget _buildNoItemInCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.shopping_cart_outlined,
          size: 300,
        ),
        Text(
          "Chưa có đơn hàng nào",
          style: TextStyle(fontSize: 30),
        )
      ],
    );
  }

  Widget _turnToDelivering(MyOrder.Order order) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: IconButton(
          onPressed: () {
            _showDialog("Chuyển sang Đang vận chuyển?", order.id, 1);
          },
          icon: const Icon(
            Icons.local_shipping,
            color: Colors.blue,
          )),
    );
  }

  Widget _turnToDelivered(MyOrder.Order order) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: IconButton(
          onPressed: () {
            _showDialogDelivered("Người nhận đã nhận hàng?", order.id, 2);
          },
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          )),
    );
  }

  Widget _cancelOrder(MyOrder.Order order) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: IconButton(
          onPressed: () {
            _showDialog("Hủy đơn hàng?", order.id, 3);
          },
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
          )),
    );
  }

  void _showDialog(String message, String orderId, int newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Không'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        setState(() {
          orderService.changeStatus(orderId, newStatus);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }

  void _showDialogDelivered(String message, String orderId, int newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Có'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Không'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        setState(() async {
          orderService.changeStatus(orderId, newStatus);

          var orderItemList = await orderService.getOrderItemList(orderId);

          for (var orderItem in orderItemList) {
            bookService.soldBook(orderItem.bookId);
          }

        });
      } else {
        // No
        setState(() {});
      }
    });
  }
}

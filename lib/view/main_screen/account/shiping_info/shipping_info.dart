import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/data/model/order.dart' as MyOrder;
import 'package:week_2/service/book_service.dart';
import 'package:week_2/service/order_service.dart';
import 'package:week_2/view/main_screen/account/shiping_info/cancel_order.dart';
import 'package:week_2/view/main_screen/home_page/book_detail/book_detail.dart';
import 'package:week_2/view/cart/cart.dart';
import 'package:week_2/view/main_screen/account/comment/comment_screen.dart';
import 'package:week_2/view/main_screen/account/shiping_info/order_detail.dart';

import '../../../../data/model/book.dart';
import '../comment/comment_list.dart';

class ShippingInfoScreen extends StatefulWidget {
  final int tabIndex;

  const ShippingInfoScreen({Key? key, required this.tabIndex})
      : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfoScreen>
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
        initialIndex: widget
            .tabIndex); // số lượng tab là 3 và vsync là this (nếu StatefulWidget của bạn kế thừa TickerProviderStateMixin)
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
          title: const Text('Đơn hàng của tôi'),
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
      stream: FirebaseFirestore.instance
          .collection('Order')
          .where("email", isEqualTo: UserInstance.getEmail())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

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
          .where("email", isEqualTo: UserInstance.getEmail())
          .where("status", isEqualTo: 0)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

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
          .where("email", isEqualTo: UserInstance.getEmail())
          .where("status", isEqualTo: 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

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
          .where("email", isEqualTo: UserInstance.getEmail())
          .where("status", isEqualTo: 2)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

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
          .where("email", isEqualTo: UserInstance.getEmail())
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
                              if (order.status == 2 )
                                _writeReview(listSize, order, book),
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
                                      width: 300,
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
                                          "${NumberFormat.currency(locale: 'vi', symbol: '').format(order.totalPrice)}đ",
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      OrderDetail(
                                                        orderId: order.id,
                                                      )));
                                        },
                                        child: const Text("Xem chi tiết")),
                                  ),
                                ),
                                if (_tabController.index == 0 ||
                                    _tabController.index == 3 ||
                                    _tabController.index == 4)
                                  _buildRepurchase(),
                                if (_tabController.index == 1)
                                  _buildCancelOrder(),
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

  Widget _buildRepurchase() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: OutlinedButton(
          onPressed: () {
            /* orderService
                    .addOrderItemToCart(order.id);*/
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          },
          child: const Text("Mua lại")),
    ));
  }

  Widget _buildCancelOrder() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xffca2128),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CancelOrderScreen()));
          },
          child: const Text(
            'Hủy đơn',
            style: TextStyle(color: Color(0xffca2128)),
          ),
        ),
      ),
    ));
  }

  Widget _writeReview(int listSize, MyOrder.Order order, Book book) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              if (listSize > 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListCommentItemScreen(
                              orderId: order.id,
                            )));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext builder) {
                      return DialogCommentScreen(
                        bookId: book.id,
                      );
                    });
              }
            },
            child: Icon(
              Icons.edit_note,
              color: BookStoreColor.selectRatingBorderBackGround(),
            )),
        GestureDetector(
            onTap: () {
              if (listSize > 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListCommentItemScreen(
                              orderId: order.id,
                            )));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext builder) {
                      return DialogCommentScreen(
                        bookId: book.id,
                      );
                    });
              }
            },
            child: Text(
              "Viết đánh giá",
              style: TextStyle(
                  color: BookStoreColor.selectRatingBorderBackGround()),
            ))
      ],
    );
  }
}

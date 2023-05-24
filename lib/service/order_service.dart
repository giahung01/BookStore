import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:week_2/repository/order_repository.dart';
import 'package:week_2/service/cart_service.dart';
import '../data/model/order.dart' as MyOrder;
import '../data/instance.dart';

class OrderService implements OrderRepository{
  final orderCollection = FirebaseFirestore.instance.collection('Order');
  final orderItemCollection = FirebaseFirestore.instance.collection('OrderItem');
  final cartService = CartService();
  final userEmail = UserInstance.getEmail();

  @override
  void addOrder(MyOrder.Order order) {
    orderCollection.add({
      'email': UserInstance.getEmail(),
      'id': order.id,
      'address': order.address,
      'orderDate': order.orderDate,
      'payMethod': order.payMethod,
      'status': order.status,
      'totalPrice': order.totalPrice
    });
  }



  @override
  void addOrderItem(MyOrder.OrderItem orderItem) {
    orderItemCollection.add({
      'orderId': orderItem.orderId,
      'bookId': orderItem.bookId,
      'quantity': orderItem.quantity
    });
  }

  @override
  Future<MyOrder.Order> getOrder(String orderId)  async {
    final snapshot = await orderCollection
        .where("id", isEqualTo: orderId)
        .where("email", isEqualTo: userEmail)
        .get();
    final order = snapshot.docs.map((e) => MyOrder.Order.fromSnapshot(e)).single;
    return order;
  }

  @override
  Future<MyOrder.OrderItem> getOrderItem(String orderId) async {
    final snapshot = await orderItemCollection.where("orderId", isEqualTo: orderId).get();
    final orderItem = snapshot.docs.map((e) => MyOrder.OrderItem.fromSnapshot(e)).single;
    return orderItem;
  }

  @override
  Future<List<MyOrder.OrderItem>> getOrderItemList(String orderId) async {
    final snapshot = await orderItemCollection.where("orderId", isEqualTo: orderId).get();
    final orderItemList = snapshot.docs.map((e) => MyOrder.OrderItem.fromSnapshot(e)).toList();
    return orderItemList;
  }

  @override
  Future<List<MyOrder.Order>> getOrderList() async {
    final snapshot = await orderCollection.where("email", isEqualTo: userEmail).get();
    final orderList = snapshot.docs.map((e) => MyOrder.Order.fromSnapshot(e)).toList();
    return orderList;
  }

  @override
  Future<int> getOrderSize(String orderId) async {
    var orderItemList = await getOrderItemList(orderId);
    int size = orderItemList.length;

    if (size > 0) {
      return size;
    }
    return -1;
  }

  @override
  void addOrderItemToCart(String orderId) async {
    var orderItemList = await getOrderItemList(orderId);
    var length = orderItemList.length;
    for (var i = 0; i < length; i++) {
      cartService.addToCart(orderItemList[i].bookId);
    }
  }

  @override
  void changeStatus(String orderId, int newStatus) async {
    final orderSnapshot = await orderCollection.where('id', isEqualTo: orderId).get();

    if (orderSnapshot.docs.isNotEmpty) {
      final orderRef = orderSnapshot.docs.first.reference;

      await orderRef.update({'status': newStatus});
    }

  }

}
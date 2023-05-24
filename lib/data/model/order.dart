import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id = "";
  String email = "";
  String address = "";
  String orderDate = "";
  int payMethod = 0;
  int status = OrderStatus.processing.index;
  double totalPrice = 0;
  late final DocumentReference reference;

  Order();

  Order.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<dynamic, dynamic>,
          reference: snapshot.reference,
        );

  Order.fromMap(
    Map<dynamic, dynamic> map, {
    required this.reference,
  })  : assert(map['id'] != null),
        assert(map['email'] != null),
        assert(map['address'] != null),
        assert(map['orderDate'] != null),
        assert(map['payMethod'] != null),
        assert(map['status'] != null),
        assert(map['totalPrice'] != null),
        id = map['id'],
        email = map['email'],
        address = map['address'],
        orderDate = map['orderDate'],
        payMethod = map['payMethod'],
        status = map['status'],
        totalPrice = map['totalPrice'];
}

enum OrderStatus { processing, delivering, delivered, canceled }

class OrderItem {
  String orderId = "";
  String bookId = "";
  int quantity = 0;
  late final DocumentReference reference;

  OrderItem();

  OrderItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<dynamic, dynamic>,
          reference: snapshot.reference,
        );

  OrderItem.fromMap(
    Map<dynamic, dynamic> map, {
    required this.reference,
  })  : assert(map['orderId'] != null),
        assert(map['bookId'] != null),
        assert(map['quantity'] != null),
        orderId = map['orderId'],
        bookId = map['bookId'],
        quantity = map['quantity'];
}

import '../data/model/order.dart';

abstract class OrderRepository {
  void addOrder(Order order);
  void addOrderItem(OrderItem orderItem);
  void addOrderItemToCart(String orderId);
  void changeStatus(String orderId, int newStatus);
  Future<Order> getOrder(String orderId);
  Future<OrderItem> getOrderItem(String orderId);
  Future<List<Order>> getOrderList();
  Future<List<OrderItem>> getOrderItemList(String orderId);
  Future<int> getOrderSize(String orderId);

}
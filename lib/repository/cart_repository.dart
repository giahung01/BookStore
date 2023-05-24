import '../data/model/cart.dart';

abstract class CartRepository {
  void addToCart(String bookId);
  void setQuantity(String cart, int quantity);
  void deleteBookFromCart(Cart cart);
  void deleteAll();
  Future<double> getTotalPrice();
  Future<List<Cart>> getCartList();
  Future<int> getCartSize();
}
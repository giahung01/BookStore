import '../data/model/user.dart';

abstract class UserRepository {
  Future<User> getUser();
  void setUser(User user);
  Future<bool> isRegisterNewUser(User user);
  Future<bool> isLoginSuccess(String email, String password);
  void addAddress(String address);
  Future<String> getSelectedAddress();
  Future<List<Address>> getAddressList();
  void setSelectedAddress(Address address);
  void deleteAddress(Address address);
  Future<User> getUserByEmail(String email);
}
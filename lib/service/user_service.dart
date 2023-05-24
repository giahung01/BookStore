import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/repository/user_repository.dart';

import '../data/model/user.dart';

class UserService implements UserRepository {
  final userCollection = FirebaseFirestore.instance.collection('User');
  final addressCollection = FirebaseFirestore.instance.collection('Address');
  final userEmail = UserInstance.getEmail();

  CollectionReference<Map<String, dynamic>> getInstance() {
    return userCollection;
  }

  @override
  Future<User> getUser() async {
    final snapshot =
        await userCollection.where("email", isEqualTo: userEmail).get();
    final user = snapshot.docs.map((e) => User.fromSnapshot(e)).single;
    return user;
  }



  @override
  Future<bool> isRegisterNewUser(User newUser) async {
    CollectionReference user = userCollection;
    bool isExist = await _isExistEmail(newUser.email);
    if (!isExist) {
      user.doc(newUser.email).set({
        'email': newUser.email,
        'password': newUser.password,
        'name': newUser.name,
        'phone': newUser.phone,
        'gender': newUser.gender,
        'birthDay': newUser.birthDay,
        'role': newUser.role,
      });
      return true;
    }
    return false;
  }

  @override
  Future<bool> isLoginSuccess(String email, String password) async {
    if (await _isExistEmail(email)) {
      String dataPassword = await _getPassword(email);
      if (password == dataPassword) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _isExistEmail(String email) async {
    var documentSnapshot = await userCollection
        .where("email", isEqualTo: email)
        .get();
    if (documentSnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> _getPassword(String email) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(email).get();
    if (documentSnapshot.exists) {
      print("Password: ${documentSnapshot.get(FieldPath(const ['password']))}");
      return documentSnapshot.get(FieldPath(const ['password']));
    }
    return "";
  }

  @override
  void addAddress(String sAddress) {
    Address address = Address();
    address.address = sAddress;
    address.email = userEmail;
    address.selected = false;

    addressCollection.add({
      'email': address.email,
      'address': address.address,
      'selected': address.selected
    });
  }

  @override
  Future<String> getSelectedAddress() async {
    final snapshot = await addressCollection
        .where("email", isEqualTo: userEmail)
        .where("selected", isEqualTo: true)
        .get();
    if (snapshot.docs.isEmpty) {
      return "";
    }

    final address = Address.fromSnapshot(snapshot.docs.single);
    return address.address;
  }



  @override
  Future<List<Address>> getAddressList() async {
    final snapshot =
        await addressCollection.where("email", isEqualTo: userEmail).get();
    final addressList =
        snapshot.docs.map((e) => Address.fromSnapshot(e)).toList();
    return addressList;
  }

  @override
  void setSelectedAddress(Address address) async {
    _setFalse();
    final snapshot = await addressCollection
        .where('email', isEqualTo: userEmail)
        .where('address', isEqualTo: address.address)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.update({'selected': true});
    }
  }

  void _setFalse() async {
    final querySnapshot = await addressCollection
        .where('email', isEqualTo: userEmail)
        .where('selected', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      doc.reference.update({'selected': false});
    }
  }

  @override
  void deleteAddress(Address address) async {
    final snapshot = await addressCollection
        .where('email', isEqualTo: userEmail)
        .where('address', isEqualTo: address.address)
        .get();

    for (var doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  @override
  void setUser(User user) async {
    final snapshot =
        await userCollection.where('email', isEqualTo: userEmail).get();

    for (var doc in snapshot.docs) {
      doc.reference.update({
        'password': user.password,
        'name': user.name,
        'phone': user.phone,
        'gender': user.gender,
        'birthDay': user.birthDay,
      });
    }
  }

  @override
  Future<User> getUserByEmail(String email) async {
    final snapshot = await userCollection.where("email", isEqualTo: email).get();
    final user = snapshot.docs.map((e) => User.fromSnapshot(e)).single;
    return user;
  }
}


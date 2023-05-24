import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class User {
  String email = "";
  String password = "";
  String name = "";
  String phone = "";
  String gender = "";
  String birthDay = "";
  int role = 0;
  late final DocumentReference reference;

  User();

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<dynamic, dynamic>,
          reference: snapshot.reference,
        );

  User.fromMap(
    Map<dynamic, dynamic> map, {
    required this.reference,
  })  : assert(map['email'] != null),
        assert(map['password'] != null),
        assert(map['name'] != null),
        assert(map['phone'] != null),
        assert(map['gender'] != null),
        assert(map['birthDay'] != null),
        assert(map['role'] != null),
        email = map['email'],
        password = map['password'],
        name = map['name'],
        phone = map['phone'],
        gender = map['gender'],
        birthDay = map['birthDay'],
        role = map['role'];
}

class Address {
  String email = "";
  String address = "";
  bool selected = false;

  late final DocumentReference reference;

  Address();

  Address.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data() as Map<dynamic, dynamic>,
          reference: snapshot.reference,
        );

  Address.fromMap(
    Map<dynamic, dynamic> map, {
    required this.reference,
  })  : assert(map['email'] != null),
        assert(map['address'] != null),
        assert(map['selected'] != null),
        email = map['email'],
        address = map['address'],
        selected = map['selected'];
}

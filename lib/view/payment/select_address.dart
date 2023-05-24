import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/payment/pay_screen.dart';

import '../../data/model/user.dart';
import 'addNewAddress.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddressScreen> {
  int _selectedValue = 0;
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffca2128),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Địa chỉ giao hàng"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildBody(context),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewAddressScreen()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Thêm địa chỉ mới",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black38,
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Chọn"),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Address').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data?.docs ?? []);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, snapshot[index], index);
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, int index) {
    final address = Address.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio(
              value: index,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value!;
                  userService.setSelectedAddress(address);
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Row(
                    children: const [
                      Text(
                        "Truong Tran Gia Hung",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" | "),
                      Text(
                        "0123465798",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    address.address,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  _showAlertDialog(address);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Loại '),
          content: const Text('Xoá địa chỉ này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Xóa'),
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
          // Yes
          userService.deleteAddress(address);
        });
      } else {
        // No
        setState(() {});
      }
    });
  }
}

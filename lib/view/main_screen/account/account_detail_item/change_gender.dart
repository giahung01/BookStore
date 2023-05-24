import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/data/model/user.dart';

import '../../../../service/user_service.dart';

class ChangeGenderScreen extends StatefulWidget {
  final User user;
  const ChangeGenderScreen({super.key, required this.user});

  @override
  _ChangeGenderState createState() => _ChangeGenderState();

}

class _ChangeGenderState extends State<ChangeGenderScreen> {
  UserService userService = UserService();

  int _selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới tính"),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: BookStoreColor.greyBackground(),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Giới tính",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioListTile(
                title: const Text('Nam'),
                value: 1,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Nữ'),
                value: 2,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Khác'),
                value: 3,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),

              ElevatedButton(
                onPressed: () {
                  String gender;
                  if (_selectedValue == 1) {
                    gender = "Nam";
                  }
                  else if (_selectedValue == 2) {
                    gender = "Nữ";
                  }
                  else {
                    gender = "Khác";
                  }
                  widget.user.gender = gender;
                  userService.setUser(widget.user);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                  ),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

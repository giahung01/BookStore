import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../../data/model/user.dart';
import '../../../../service/user_service.dart';

class ChangeDateOfBirthScreen extends StatefulWidget {
  final User user;
   ChangeDateOfBirthScreen({super.key, required this.user});

  @override
  _ChangeDateOfBirthState createState() => _ChangeDateOfBirthState();
}

class _ChangeDateOfBirthState extends State<ChangeDateOfBirthScreen> {
  TextEditingController dateInput = TextEditingController();
  DateTime _selectedDate = DateTime(2000, 1, 1);
  UserService userService = UserService();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 250,
                child: ScrollDatePicker(
                  selectedDate: _selectedDate,
                  locale: Locale('en'),
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.user.birthDay = DateFormat('dd/MM/yyyy').format(_selectedDate);
                      userService.setUser(widget.user);
                      Navigator.pop(context);
                    });
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

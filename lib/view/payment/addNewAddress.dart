import 'package:flutter/material.dart';
import 'package:week_2/data/model/user.dart';
import 'package:week_2/service/user_service.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddressScreen> {
  final List<String> _currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];

  final _textFieldController  = TextEditingController();
  UserService userService = UserService();

  String _selectedValue = "Food";

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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Nhập địa chỉ mới",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              /*const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tên người nhận",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Nhập Họ tên',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Số điện thoại",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Nhập Số điện thoại',
                  ),
                ),
              ),*/
              /*const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tỉnh/ Thành phố",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "A/B",
                    ),
                    value: _selectedValue,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedValue = value!;
                    }),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Quận/ Huyện",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "A/B",
                    ),
                    value: _selectedValue,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedValue = value!;
                    }),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Phường/ Xã",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "A/B",
                    ),
                    value: _selectedValue,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedValue = value!;
                    }),
              ),*/

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Địa chỉ nhận hàng",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textFieldController ,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'Tòa nhà, số nhà, tên đường',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      userService.addAddress(_textFieldController.text.trim());
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Xác nhận"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

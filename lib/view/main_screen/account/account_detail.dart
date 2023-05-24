import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/service/user_service.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_date_of_birth.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_email.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_gender.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_name.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_password.dart';
import 'package:week_2/view/main_screen/account/account_detail_item/change_phone_number.dart';

import '../../../data/model/user.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetailScreen> {
  UserService userService = UserService();
  late Future<User> _user;

  @override
  void initState() {
    _user = userService.getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin tài khoản"),
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
      body: FutureBuilder(
          future: Future.wait([_user]),
          builder:
              (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final user = snapshot.data![0] as User;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 80,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2021/07/02/04/48/user-6380868_1280.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                        /*  Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangeNameScreen(user: user,)));*/

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNameScreen(user: user)))
                              .then((value) => setState(() {}));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Họ & Tên",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.name)
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return  ChangeDateOfBirthScreen(user: user,);
                              }).then((value) => setState(() {}));
                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangeDateOfBirthScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.date_range,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Ngày sinh",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.birthDay)
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //          ChangeGenderScreen(user: user,)));

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeGenderScreen(user: user)))
                              .then((value) => setState(() {}));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.transgender,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Giới tính",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.gender)
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ChangePhoneScreen(user: user,)));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePhoneScreen(user: user)))
                              .then((value) => setState(() {}));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.phone,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Số điện thoại",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(user.phone)
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChangeEmailScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.mail_outline, size: 20,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text("giahung@gmail.com")
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_forward_ios, size: 15,),
                          ),

                        ],

                      ),
                    ),
                  ),
                ),*/
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Đổi mật khẩu",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

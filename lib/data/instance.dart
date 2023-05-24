import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserInstance {
  static String _userEmail = "";

  static void setEmail(String email) {
    _userEmail = email;
  }

  static String getEmail() {
    return _userEmail;
  }

  static void defaultEmail() {
    _userEmail = "";
  }

}

class InstanceCode {
  static String getTime() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(date);

    return formattedDate;
  }

  static String getIdV4() {
    var uuid = const Uuid();
    return uuid.v4();
  }


  static String getOrderCode() {
    Random random = Random();
    String randomNumber = '';
    for (int i = 0; i < 10; i++) {
      randomNumber += random.nextInt(10).toString();
    }
    return randomNumber;
  }

  static String currencyFormat(double price) {
    return "${NumberFormat.currency(locale: 'vi', symbol: '').format(price)}đ";
  }
}

class OrderInstance {

  static String getStringStatus(int stateCode) {
    switch (stateCode) {
      case 0: return "Chờ xác nhận";
      case 1: return "Đang vận chuyển";
      case 2: return "Đã giao";
      case 3: return "Đã hủy";
      default:
        return "ERROR";
    }
  }
}

enum BookCategoryEnum {
  trinhTham,
  vanHoc,
  sachTuDuy,
  tamLy,
  tonGiaoTamLinh,
  taiChinh,
  hocTiengAnh,
  truyenTranh,
  kienThucBachKhoa
}

extension MyEnumExtension on BookCategoryEnum {
  String get value {
    switch (this) {
      case BookCategoryEnum.trinhTham:
        return "Trinh thám";
      case BookCategoryEnum.vanHoc:
        return "Văn học";
      case BookCategoryEnum.sachTuDuy:
        return "Sách tư duy - Kỹ năng sống";
      case BookCategoryEnum.tamLy:
        return "Tâm lý";
      case BookCategoryEnum.tonGiaoTamLinh:
        return "Tôn giáo - Tâm linh";
      case BookCategoryEnum.taiChinh:
        return "Tài chính, tiền tệ";
      case BookCategoryEnum.hocTiengAnh:
        return "Học tiếng Anh";
      case BookCategoryEnum.truyenTranh:
        return "Truyện tranh, manga";
      case BookCategoryEnum.kienThucBachKhoa:
        return "Kiến thức bách khoa";
      default:
        return "";
    }
  }
}

class BookStoreColor {
  static Color blueBackground() {
    return const Color(0xff1ba9ff);
  }

  static Color redBackground() {
    return const Color(0xffff424e);
  }

  static Color greyButton() {
    return const Color(0xff7c7c7c);
  }

  static Color greyBackground() {
    return const Color(0xffeeeeee);
  }

  static Color blackText() {
    return const Color(0xff3a3a3a);
  }

  static Color greyText() {
    return const Color(0xff7a7a7c);
  }

  static Color selectRatingBackGround() {
    return const Color(0xffeff7ff);
  }

  static Color selectRatingBorderBackGround() {
    return const Color(0xff3c6b7b);
  }

  static Color defaultRatingBorderBackGround() {
    return const Color(0xffe5e5e5);
  }

}

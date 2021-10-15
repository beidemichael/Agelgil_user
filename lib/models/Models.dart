import 'package:flutter/foundation.dart';

class Lounges {
  List category;
  String name;
  String id;
  String images;
  double longitude;
  double latitude;
  String lounge;
  String documentId;
  bool active;
  bool weAreOpen;
  bool eatThere;
  double deliveryRadius;
  String loungeMessagingToken;
  Lounges(
      {this.name,
      this.images,
      this.id,
      this.latitude,
      this.longitude,
      this.category,
      this.lounge,
      this.documentId,
      this.active,
      this.weAreOpen,
      this.deliveryRadius,
      this.eatThere,
      this.loungeMessagingToken});
}

class Lounge {
  String documentId;
  bool eatThere;
  bool weAreOpen;
  String loungeMessagingToken;

  Lounge(
      {this.documentId,
      this.weAreOpen,
      this.eatThere,
      this.loungeMessagingToken});
}

class Orders {
  List food;
  List price;
  List quantity;
  double subTotal;
  int tip;
  double serviceCharge;
  double deliveryFee;
  String loungeName;
  var created;
  bool isTaken;
  bool eatThere;
  String orderCode;
  String userName;
  String userPhone;
  String userUid;
  String userPic;
  String userMesagingToken;
  String documentId;
  double longitude;
  double latitude;
  double loungeLongitude;
  double loungeLatitude;
  String loungeMessagingToken;
  String loungeId;
  double carrierLongitude;
  double carrierLatitude;
  String carrierPhone;
  bool isBeingPrepared;
  String loungeOrderNumber;

  Orders({
    this.food,
    this.price,
    this.quantity,
    this.subTotal,
    this.deliveryFee,
    this.loungeName,
    this.created,
    this.isTaken,
    this.orderCode,
    this.userName,
    this.userPhone,
    this.documentId,
    this.carrierLatitude,
    this.carrierLongitude,
    this.latitude,
    this.longitude,
    this.loungeLatitude,
    this.loungeLongitude,
    this.carrierPhone,
    this.serviceCharge,
    this.tip,
    this.eatThere,
    this.isBeingPrepared,
    this.loungeOrderNumber,
    this.loungeId,
    this.loungeMessagingToken,
    this.userMesagingToken,
    this.userPic,
    this.userUid,
  });
}

class Cart3Items {
  String foodNameL;
  double foodPriceL;
  int foodQuantityL;
  Cart3Items({this.foodNameL, this.foodPriceL, this.foodQuantityL});
}

class Menu with ChangeNotifier {
  String name;
  String id;
  String images;
  String category;
  double price;
  bool isAvailable;

  Menu(
      {this.name,
      this.images,
      this.id,
      this.category,
      this.price,
      this.isAvailable});
}

class UserAuth {
  final String uid;
  UserAuth({this.uid});
}

class UserInfo {
  String userName;
  String userSex;
  String userPhone;
  String userPic;
  String userUid;
  String documentId;
  String userMessagingToken;

  UserInfo({
    this.userName,
    this.userPhone,
    this.userPic,
    this.userUid,
    this.documentId,
    this.userMessagingToken,
    this.userSex,
  });
}

class Controller {
  double serviceCharge;
  double deliveryFee;
  String documentId;
  int version;
  double sFStartsAt;
  bool referralCodeLogin;
  bool referralCodeOrder;
  bool phoneCustomerSupport;
  Controller({
    this.deliveryFee,
    this.serviceCharge,
    this.documentId,
    this.version,
    this.sFStartsAt,
    this.referralCodeLogin,
    this.referralCodeOrder,
    this.phoneCustomerSupport,
  });
}

class CustomerService {
  String name;
  String phone;
  String documentId;
  CustomerService({this.name, this.phone, this.documentId});
}

class Adress {
  String userUid;
  double longitude;
  double latitude;
  String information;
  String name;
  String documentId;
  Adress(
      {this.information,
      this.latitude,
      this.longitude,
      this.userUid,
      this.name,
      this.documentId});
}

class ConfirmOrder {
  String userUid;

  ConfirmOrder({
    this.userUid,
  });
}

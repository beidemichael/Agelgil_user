import 'package:agelgil_user_end/models/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {
  String menuId;
  String userUid;
  DateTime created;
  String orderNumber;
  String id;
  String userPhoneNumber;
  double latitude;
  double longitude;
  String messagingToken;
  String documentUid;

  DatabaseService(
      {this.menuId,
      this.userPhoneNumber,
      this.userUid,
      this.id,
      this.created,
      this.orderNumber,
      this.latitude,
      this.longitude,
      this.messagingToken,
      this.documentUid});
//collecton reference
  final CollectionReference loungesCollection =
      FirebaseFirestore.instance.collection('Lounges');
  final CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('Menu');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('Orders');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference adressCollection =
      FirebaseFirestore.instance.collection('Adress');
  final CollectionReference controllerCollection =
      FirebaseFirestore.instance.collection('Controller');
  final CollectionReference customerSupportCollection =
      FirebaseFirestore.instance.collection('Customer Service');

  final geo = Geoflutterfire();

  //******************************************************************************************** */

  List<Controller> _controllerInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Controller(
          serviceCharge: doc.data()['ServiceCharge'].toDouble() ?? 0.0,
          deliveryFee: doc.data()['DeliveryFee'].toDouble() ?? 0.0,
          version: doc.data()['AndroidUserVersion'].toInt() ?? 0,
          sFStartsAt: doc.data()['SFStartsAt'].toDouble() ?? 0.0,
          referralCodeLogin: doc.data()['referralCodeLogin'] ?? false,
          referralCodeOrder: doc.data()['referralCodeOrder'] ?? false,
          phoneCustomerSupport: doc.data()['PhoneCustomerSupport'] ?? false,
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<Controller>> get controllerInfo {
    return controllerCollection
        .snapshots()
        .map(_controllerInfoListFromSnapshot);
  }

  List<CustomerService> _customerServiceListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CustomerService(
          name: doc.data()['Name'] ?? '',
          phone: doc.data()['Phone'] ?? '',
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<CustomerService>> get customerService {
    return customerSupportCollection
        // .where('Visible', isEqualTo: true)
        .orderBy('Priority', descending: false)
        .snapshots()
        .map(_customerServiceListFromSnapshot);
  }

  //*************************************user related******************************************************* */
  Future newUserData(
    String profilePic,
    String name,
    String userUid,
    String referralCode,
  ) async {
    usersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isEmpty) {
        return await usersCollection.doc(userUid).set({
          'created': Timestamp.now(),
          'profilePic': profilePic,
          'name': name,
          'phoneNumber': userPhoneNumber,
          'userUid': userUid,
          'referralCode': referralCode
        });
      }
    });
  }

  Future updateCurrentUser(
    String name,
  ) async {
    return await usersCollection.doc(userUid).update({
      'name': name,
    });
  }

  Future updateNameandSex(
    String name,
    String sex,
  ) async {
    return await usersCollection.doc(userUid).update({
      'name': name,
      'sex': sex,
    });
  }

  Future usserInfo() async {
    usersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; i++) {
          return UserInfo(
            userName: docs.docs[i].get('name') ?? '',
            userPhone: docs.docs[i].get('phoneNumber') ?? '',
            userPic: docs.docs[i].get('profilePic') ?? '',
          );
        }
      }
    });
  }

  List<UserInfo> _userInfoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserInfo(
          userPic: doc.data()['profilePic'] ?? '',
          userUid: doc.data()['userUid'] ?? '',
          userName: doc.data()['name'] ?? '',
          userSex: doc.data()['sex'] ?? '',
          userPhone: doc.data()['phoneNumber'] ?? '',
          userMessagingToken: doc.data()['messagingToken'] ?? '',
          documentId: doc.reference.id ?? '');
    }).toList();
  }

  //orders lounges stream
  Stream<List<UserInfo>> get userInfo {
    return usersCollection
        .where('userUid', isEqualTo: userUid)
        .snapshots()
        .map(_userInfoListFromSnapshot);
  }

  // Future newUserMessagingToken() async {
  //   return await usersCollection
  //       .doc(documentUid).
  //       .update({
  //         'messagingToken': 'blad',
  //       })
  //       .then((value) => print('checked from data base'))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  Future newUserMessagingToken(
    String userUid,
    String messagingToken,
    String documentUid,
  ) async {
    usersCollection
        .where('userUid', isEqualTo: userUid)
        .get()
        .then((docs) async {
      if (docs.docs.isNotEmpty) {
        return usersCollection
            .doc(userUid)
            .update({
              'messagingToken': messagingToken,
            })
            .then((value) => print('checked from data base'))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }
  //******************************************User related************************************************** */

  Future updateOrderDataForEatThere(
    List foodName,
    List foodPrice,
    List foodQuantity,
    double subTotal,
    String loungeName,
    bool isTaken,
    bool isDelivered,
    String userName,
    String userPhone,
    String userSex,
    String userUid,
    String userPic,
    String loungeId,
    double longitude,
    double latitude,
    String information,
    DateTime created,
    String orderNumber,
    String loungeOrderNumber,
    double serviceCharge,
    int deliveryFee,
    double tip,
    double distance,
    GeoFirePoint loungeLocation,
    String loungeMessagingToken,
    String userMessagingToken,
  ) async {
    return await orderCollection.add({
      'food': foodName,
      'price': foodPrice,
      'quantity': foodQuantity,
      'subTotal': subTotal,
      'loungeName': loungeName,
      'created': created,
      'isTaken': isTaken,
      'isDelivered': isDelivered,
      'userName': userName,
      'userPhone': userPhone,
      'userSex': userSex,
      'userUid': userUid,
      'userPic': userPic,
      'orderCode': orderNumber,
      'loungeOrderNumber': loungeOrderNumber,
      'loungeId': loungeId,
      'Longitude': longitude,
      'Latitude': latitude,
      'information': information,
      'carrierName': null,
      'carrierphone': null,
      'carrierUserUid': null,
      'carrierUserPic': null,
      'serviceCharge': serviceCharge,
      'deliveryFee': deliveryFee,
      'tip': tip,
      'distance': distance,
      'LoungeLocation': loungeLocation.data,
      'isPaid': false,
      'isBeingPrepared': false,
      'eatThere': true,
      'loungeMessagingToken': loungeMessagingToken,
      'userMessagingToken': userMessagingToken,
    });
  }

  Future updateOrderData(
    List foodName,
    List foodPrice,
    List foodQuantity,
    double subTotal,
    String loungeName,
    bool isTaken,
    bool isDelivered,
    String userName,
    String userPhone,
    String userSex,
    String userUid,
    String userPic,
    String loungeId,
    double longitude,
    double latitude,
    String information,
    DateTime created,
    String orderNumber,
    String loungeOrderNumber,
    double serviceCharge,
    int deliveryFee,
    double tip,
    double distance,
    GeoFirePoint loungeLocation,
    String loungeMessagingToken,
    String userMessagingToken,
    String referralCode,
  ) async {
    return await orderCollection.add({
      'food': foodName,
      'price': foodPrice,
      'quantity': foodQuantity,
      'subTotal': subTotal,
      'loungeName': loungeName,
      'created': created,
      'isTaken': isTaken,
      'isDelivered': isDelivered,
      'userName': userName,
      'userPhone': userPhone,
      'userSex':userSex,
      'userUid': userUid,
      'userPic': userPic,
      'orderCode': orderNumber,
      'loungeOrderNumber': loungeOrderNumber,
      'loungeId': loungeId,
      'Longitude': longitude,
      'Latitude': latitude,
      'information': information,
      'carrierName': null,
      'carrierphone': null,
      'carrierUserUid': null,
      'carrierUserPic': null,
      'serviceCharge': serviceCharge,
      'deliveryFee': deliveryFee,
      'tip': tip,
      'distance': distance,
      'LoungeLocation': loungeLocation.data,
      'isPaid': false,
      'isBeingPrepared': false,
      'eatThere': false,
      'loungeMessagingToken': loungeMessagingToken,
      'userMessagingToken': userMessagingToken,
      'referralCode': referralCode
    }).then((result) {
   
   print("Success!");

 });
  }

  Future updateOrderByUser() async {
    orderCollection.doc(id).update({
      'isDelivered': true,
    });
  }

  List<ConfirmOrder> _confirmOrderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ConfirmOrder(
        userUid: doc.data()['userUid'] ?? '',
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<ConfirmOrder>> get confirmOrder {
    return orderCollection
        .where('userUid', isEqualTo: userUid)
        .where('orderCode', isEqualTo: orderNumber)
        .snapshots()
        .map(_confirmOrderListFromSnapshot);
  }
  //******************************************************************************************** */

  //******************************************************************************************** */
// lounge list from a snapshot
  List<Lounges> _loungesListFromSnapshot(List<DocumentSnapshot> snapshot) {
    return snapshot.map((doc) {
      return Lounges(
        name: doc.data()['name'] ?? '',
        images: doc.data()['image'] ?? '',
        id: doc.data()['id'] ?? '',
      
        loungeMessagingToken: doc.data()['messagingToken'] ?? '',
        longitude: doc.data()['Location']['geopoint'].longitude ?? 0,
        latitude: doc.data()['Location']['geopoint'].latitude ?? 0,
        category: doc.data()['category'] ?? '',
        lounge: doc.data()['lounge'] ?? '',
        active: doc.data()['active'] ?? '',
        weAreOpen: doc.data()['weAreOpen'] ?? '',
        eatThere: doc.data()['eatThere'] ?? false,
        deliveryRadius: doc.data()['deliveryRadius'].toDouble() ?? '',
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<Lounges>> get lounges {
    GeoFirePoint myLocation = Geoflutterfire().point(
        latitude: latitude == null ? 0.0 : latitude,
        longitude: longitude == null ? 0.0 : longitude);
    return geo
        .collection(collectionRef: loungesCollection)
        .within(
            center: myLocation,
            radius: 40.0,
            field: 'Location',
            strictMode: true)
        .map(_loungesListFromSnapshot);
  }

  List<Lounge> _loungesIsOpenListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Lounge(
        weAreOpen: doc.data()['weAreOpen'] ?? '',
        eatThere: doc.data()['eatThere'] ?? '',
        loungeMessagingToken: doc.data()['messagingToken'] ?? '',
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //get lounges stream
  Stream<List<Lounge>> get loungesIsOpen {
    return loungesCollection
        .where('id', isEqualTo: id)
        .snapshots()
        .map(_loungesIsOpenListFromSnapshot);
  }
  //******************************************************************************************** */

  //******************************************************************************************** */
//orders list from a snapshot
  List<Orders> _ordersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Orders(
        food: doc.data()['food'] ?? '',
        quantity: doc.data()['quantity'] ?? '',
        price: doc.data()['price'] ?? '',
        deliveryFee: doc.data()['deliveryFee'].toDouble() ?? 0.0,
        serviceCharge: doc.data()['serviceCharge'].toDouble() ?? 0.0,
        tip: doc.data()['tip'].toInt() ?? 0,
        subTotal: doc.data()['subTotal'] ?? '',
        loungeName: doc.data()['loungeName'] ?? '',
        created: doc.data()['created'] ?? '',
        isTaken: doc.data()['isTaken'] ?? '',
        orderCode: doc.data()['orderCode'] ?? '',
        userName: doc.data()['userName'] ?? '',
        userPhone: doc.data()['userPhone'] ?? '',
        documentId: doc.reference.id ?? '',
        latitude: doc.data()['Latitude'] ?? 0.0,
        longitude: doc.data()['Longitude'] ?? 0.0,
        eatThere: doc.data()['eatThere'] ?? false,
        loungeLatitude:
            doc.data()['LoungeLocation']['geopoint'].latitude ?? 0.0,
        loungeLongitude:
            doc.data()['LoungeLocation']['geopoint'].longitude ?? 0.0,
        carrierLatitude: doc.data()['carrierLatitude'] ?? 0.0,
        carrierLongitude: doc.data()['carrierLongitude'] ?? 0.0,
        carrierPhone: doc.data()['carrierphone'] ?? '',
        isBeingPrepared: doc.data()['isBeingPrepared'] ?? false,
        loungeOrderNumber: doc.data()['loungeOrderNumber'] ?? '',
        userUid: doc.data()['userUid'] ?? '',
        userPic: doc.data()['userPic'] ?? '',
        userMesagingToken: doc.data()['userMessagingToken'] ?? '',
        loungeMessagingToken: doc.data()['loungeMessagingToken'] ?? '',
        loungeId: doc.data()['loungeId'] ?? '',
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<Orders>> get orders {
    return orderCollection
        .where('isDelivered', isEqualTo: false)
        .where('userUid', isEqualTo: userUid)
        .orderBy('created', descending: true)
        .snapshots()
        .map(_ordersListFromSnapshot);
  }

  Future removeOrder() async {
    return orderCollection.doc(id).delete();
  }
  //******************************************************************************************** */

  //******************************************************************************************** */
//menu list from a snapshot
  List<Menu> _menuListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Menu(
          images: doc.data()['images'] ?? '',
          name: doc.data()['name'] ?? '',
          id: doc.data()['id'] ?? '',
          category: doc.data()['category'] ?? '',
          isAvailable: doc.data()['isAvaliable'] ?? false,
          price: doc.data()['price'] ?? '');
    }).toList();
  }

  //menu lounges stream
  Stream<List<Menu>> get menu {
    return menuCollection
        .where('id', isEqualTo: menuId)
        .where('isAvaliable', isEqualTo: true)
        .orderBy('category', descending: true)
        .snapshots()
        .map(_menuListFromSnapshot);
  }

  //******************************************************************************************** */

  List<Adress> _adressListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Adress(
        longitude: doc.data()['Longitude'] ?? '',
        latitude: doc.data()['Latitude'] ?? '',
        userUid: doc.data()['userUid'] ?? '',
        name: doc.data()['name'] ?? '',
        information: doc.data()['information'] ?? '',
        documentId: doc.reference.id ?? '',
      );
    }).toList();
  }

  //orders lounges stream
  Stream<List<Adress>> get adress {
    return adressCollection
        .where('userUid', isEqualTo: userUid)
        .snapshots()
        .map(_adressListFromSnapshot);
  }

  Future removeAdress() async {
    return adressCollection.doc(id).delete();
  }

  Future addAdress(
    double latitude,
    double longitude,
    String userUid,
    String name,
    String information,
  ) async {
    return await adressCollection.add({
      'created': Timestamp.now(),
      'Latitude': latitude,
      'Longitude': longitude,
      'userUid': userUid,
      'name': name,
      'information': information,
    });
  }
}

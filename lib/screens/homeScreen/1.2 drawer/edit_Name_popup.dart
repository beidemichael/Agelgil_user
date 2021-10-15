
import 'package:agelgil_user_end/service/database.dart';
import 'package:flutter/material.dart';

class EditNameSettingPopup extends StatefulWidget {
  String name;

   String documentId;
  EditNameSettingPopup({this.name,this.documentId});
  @override
  _EditNameSettingPopupState createState() => _EditNameSettingPopupState();
}

class _EditNameSettingPopupState extends State<EditNameSettingPopup> {
  String newName;
  int newIndex;
  String documentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newName = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit name",
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            SizedBox(
              height: 35.0,
            ),
            TextFormField(
              onChanged: (val) {
                newName = val;
              },
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500
                  // decorationColor: Colors.white,
                  ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),

                //Label Text/////////////////////////////////////////////////////////
                labelText: newName,
                // labelText: Texts.PHONE_NUMBER_LOGIN,
                focusColor: Colors.orange[900],
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0,
                    color: Colors.grey[600]),
                /* hintStyle: TextStyle(
                                  color: Colors.orange[900]
                                  ) */
                ///////////////////////////////////////////////

                //when it's not selected////////////////////////////
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey[400])),
                ////////////////////////////////

                ///when textfield is selected//////////////////////////
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.orange[200])),
                ////////////////////////////////////////
              ),
            ),
            SizedBox(height: 35),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: Center(
                    child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 21.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w100)),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(35.0))),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                if (newName == null) {
                  newName = widget.name;
                }

                await DatabaseService(userUid: widget.documentId)
                    .updateCurrentUser(newName);
           
                Navigator.of(context).pop();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: Center(
                    child: Text('Update',
                        style: TextStyle(
                            fontSize: 21.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w100)),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(35.0))),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

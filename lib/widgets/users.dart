import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/widgets/status.dart';

class Users {
  List<Widget> children = [];
  List<Widget> adds(Map users) {
    users.forEach((dynamic index, dynamic user) {
      children.add(GestureDetector(
          onTap: () {
            print("Container was tapped");
          },
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 100,
                child:
                    Image.network(user["profilePicOverride"] == "" ? user["currentAvatarThumbnailImageUrl"] : user["profilePicOverride"], fit: BoxFit.fitWidth),
              ),
              Expanded(
                  child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    status(user["status"]),
                    Container(
                      width: 5,
                    ),
                    Text(user["displayName"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                Text(user["statusDescription"])
              ]))
            ],
          )));
    });
    return children;
  }
}

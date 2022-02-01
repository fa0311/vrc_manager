import 'package:flutter/material.dart';

Drawer drawr(context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: const Text('My Page'),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: const Text('Friends'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        )
      ],
    ),
  );
}

import 'package:flutter/material.dart';

Container status(String status) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: statusConverter(status),
    ),
  );
}

Color statusConverter(String status) {
  if (status == "join me") return const Color(0xFF42CAFF);
  if (status == "active") return const Color(0xFF51e57e);
  if (status == "offline") return const Color(0xFF808080);
  if (status == "ask me") return const Color(0xFFe88134);

  if (status == "busy") return const Color(0xFF5b0b0b);
  return const Color(0x00000000);
}

/*
    offline gray #808080
    --status-online: #51e57e;
    --status-joinme: #42caff;
    --status-busy: #5b0b0b;
    --status-askme: #e88134;
    --level-visitor: #CCCCCC;
    --level-new: #1778FF;
    --level-user: #2BCF5C;
    --level-known: #FF7B42;
    --level-trusted: #8143E6;
    --friend: #FFFF00;
    --developer: #B52626;
    --moderator: #B52626;

 */
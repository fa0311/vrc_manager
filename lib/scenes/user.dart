import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileUser extends StatefulWidget {
  final String userId;

  const VRChatMobileUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<VRChatMobileUser> createState() => _UserHomeState();
}

class _UserHomeState extends State<VRChatMobileUser> {
  @override
  Widget build(BuildContext context) {
    Column column = Column(
      children: [
        Text(widget.userId),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: drawr(context),
      body: SafeArea(child: SizedBox(width: MediaQuery.of(context).size.width, child: column)),
    );
  }
}

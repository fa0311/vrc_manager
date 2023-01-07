// Flutter imports:
import 'package:flutter/material.dart';

class FutureTile extends StatefulWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final Future Function() onTap;
  const FutureTile({super.key, this.title, this.subtitle, this.leading, this.trailing, required this.onTap});

  @override
  FutureTileState createState() => FutureTileState();
}

class FutureTileState extends State<FutureTile> {
  late bool state;
  late GlobalKey key;

  @override
  void initState() {
    state = false;
    key = GlobalKey();
    super.initState();
  }

  Future onTap() async {
    try {
      setState(() => state = true);
      await widget.onTap();
    } finally {
      setState(() => state = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      onTap: onTap,
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      trailing: state
          ? const Padding(
              padding: EdgeInsets.only(right: 2, top: 2),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
            )
          : widget.trailing,
    );
  }
}

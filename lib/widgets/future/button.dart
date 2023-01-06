// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum ButtonType {
  textButton,
  outlinedButton,
  elevatedButton;
}

class FutureButton extends StatefulWidget {
  final Widget child;
  final Future Function() onPressed;
  final ButtonType type;
  const FutureButton({super.key, required this.child, required this.onPressed, this.type = ButtonType.textButton});

  @override
  FutureButtonState createState() => FutureButtonState();
}

class FutureButtonState extends State<FutureButton> {
  late bool state;
  late Size size;
  late GlobalKey key;

  @override
  void initState() {
    state = false;
    key = GlobalKey();
    super.initState();
  }

  Future onPressed() async {
    try {
      setState(() => state = true);
      await widget.onPressed();
    } finally {
      setState(() => state = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state) {
      return SizedBox(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: (size.height - 20) / 2, horizontal: (size.width - 20) / 2),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      size = key.currentContext!.size!;
    });

    switch (widget.type) {
      case ButtonType.textButton:
        return TextButton(
          key: key,
          onPressed: onPressed,
          child: widget.child,
        );
      case ButtonType.outlinedButton:
        return OutlinedButton(
          key: key,
          onPressed: onPressed,
          child: widget.child,
        );
      case ButtonType.elevatedButton:
        return ElevatedButton(
          key: key,
          onPressed: onPressed,
          child: widget.child,
        );
    }
  }
}

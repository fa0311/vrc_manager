import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

GridView renderGrid(
  BuildContext context, {
  required int width,
  required int height,
  required List<Widget> children,
}) {
  double screenSize = MediaQuery.of(context).size.width;

  return GridView.count(
    crossAxisCount: screenSize ~/ width + 1,
    crossAxisSpacing: 0,
    mainAxisSpacing: 0,
    childAspectRatio: screenSize / (screenSize ~/ width + 1) / height,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: children,
  );
}

Widget genericTemplate(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  required String imageUrl,
  void Function()? onTap,
  void Function()? onLongPress,
  Widget? bottom,
  List<Widget>? right,
  List<Widget>? stack,
  bool card = true,
  bool half = false,
}) {
  Widget content = Column(
    children: [
      Row(
        children: <Widget>[
          SizedBox(
            height: half ? 50 : 100,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fitWidth,
              progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                width: half ? 50 : 100,
                child: const Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => SizedBox(
                width: half ? 50 : 100,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: half ? 10 : 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
          if (right != null) ...right,
        ],
      ),
      if (bottom != null)
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: bottom,
        ),
    ],
  );
  if (card && stack == null) {
    content = Container(
      padding: EdgeInsets.all(half ? 5 : 10),
      child: content,
    );
  } else if (card) {
    content = Stack(
      children: <Widget>[
        Container(padding: EdgeInsets.all(half ? 5 : 10), child: content),
        ...stack!,
      ],
    );
  }
  if (onTap != null || onLongPress != null) {
    content = InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      onLongPress: onLongPress,
      child: content,
    );
  }
  if (card) {
    content = Card(elevation: 20.0, margin: EdgeInsets.all(half ? 2 : 5), child: content);
  }
  return content;
}

Widget genericTemplateText(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  void Function()? onTap,
  void Function()? onLongPress,
}) {
  return Card(
    margin: const EdgeInsets.all(2),
    elevation: 20.0,
    child: GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
}

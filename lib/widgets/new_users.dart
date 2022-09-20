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
    padding: const EdgeInsets.only(bottom: 30),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: children,
  );
}

Card defaultAdd(BuildContext context, AppConfig appConfig, String imageUrl, List<Widget> children, {void Function()? onTap, Widget? bottom}) {
  return Card(
    elevation: 20.0,
    child: Container(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fitWidth,
                    progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 100,
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              ],
            ),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: bottom,
              ),
          ],
        ),
      ),
    ),
  );
}

List<Text> toTextWidget(List<String> textList, {double fontSize = 14}) {
  return [
    for (String text in textList)
      Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
  ];
}

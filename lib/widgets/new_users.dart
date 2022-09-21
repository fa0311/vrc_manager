import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

Card defaultAdd(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  required String imageUrl,
  void Function()? onTap,
  Widget? bottom,
}) {
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
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

Card privateSimpleWorld(BuildContext context, AppConfig appConfig) {
  return defaultAdd(
    context,
    appConfig,
    children: [
      const SizedBox(width: double.infinity, child: Text("Private")),
      SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.privateWorld,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
  );
}

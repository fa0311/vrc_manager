// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RenderGrid extends ConsumerWidget {
  final int width;
  final int height;
  final List<Widget> children;
  final ScrollPhysics? physics;

  const RenderGrid({
    super.key,
    required this.width,
    required this.height,
    required this.children,
    this.physics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenSize = MediaQuery.of(context).size.width;
    int crossAxisCount = screenSize ~/ width + 1;

    return SizedBox(
      height: (height * ((children.length + 1) ~/ crossAxisCount)).toDouble(),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: screenSize / crossAxisCount / height,
        children: children,
      ),
    );
  }
}

class GenericTemplate extends ConsumerWidget {
  final List<Widget> children;
  final String imageUrl;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Widget? bottom;
  final List<Widget>? right;
  final List<Widget>? stack;
  final bool card;
  final bool half;

  const GenericTemplate({
    super.key,
    required this.children,
    required this.imageUrl,
    this.onTap,
    this.onLongPress,
    this.bottom,
    this.right,
    this.stack,
    this.card = true,
    this.half = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            if (right != null) ...right!,
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
}

class GenericTemplateText extends ConsumerWidget {
  final List<Widget> children;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final List<Widget>? stack;
  final bool card;

  const GenericTemplateText({
    super.key,
    required this.children,
    this.onTap,
    this.onLongPress,
    this.stack,
    this.card = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    if (card && stack != null) {
      content = Stack(
        children: <Widget>[content],
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
      content = Card(elevation: 20.0, margin: const EdgeInsets.all(2), child: content);
    }
    return content;
  }
}

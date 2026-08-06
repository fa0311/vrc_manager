// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T?> showModalBottomSheetConsumer<T>({required BuildContext context, required ConsumerBuilder builder}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    // A modal sheet always extends to the bottom of the screen, and Android now
    // draws edge-to-edge, so the content has to inset itself or its last entry
    // ends up under the navigation bar and cannot be tapped. `useSafeArea` does
    // not help here: it only covers the top, left and right sides.
    builder: (BuildContext context) {
      return SafeArea(top: false, child: Consumer(builder: builder));
    },
  );
}

Future<T?> showModalBottomSheetStatelessWidget<T>({required BuildContext context, required Widget Function() builder}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    // See showModalBottomSheetConsumer above for why this inset is manual.
    builder: (BuildContext context) => SafeArea(top: false, child: builder()),
  );
}
